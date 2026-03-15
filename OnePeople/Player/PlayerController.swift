import Foundation

@MainActor
final class OnePeopleAppModel: ObservableObject {
    @Published private(set) var isAuthenticated: Bool
    @Published private(set) var serverURL: String
    @Published private(set) var lastUsername: String
    @Published private(set) var activeUsername: String?
    @Published private(set) var authErrorMessage: String?
    @Published private(set) var profile = OnePeopleMockData.profile
    @Published private(set) var metrics = OnePeopleMockData.metrics
    @Published private(set) var announcements = OnePeopleMockData.announcements
    @Published private(set) var attendanceHistory = OnePeopleMockData.attendanceHistory
    @Published private(set) var leaveRequests = OnePeopleMockData.leaveRequests
    @Published private(set) var approvals = OnePeopleMockData.approvals
    @Published private(set) var payslips = OnePeopleMockData.payslips
    @Published private(set) var services = OnePeopleMockData.services
    @Published private(set) var homeShortcuts = OnePeopleMockData.homeShortcuts
    @Published private(set) var allMenus = OnePeopleMockData.allMenus
    @Published private(set) var profileMenus = OnePeopleMockData.profileMenus
    @Published private(set) var settingsItems = OnePeopleMockData.settingsItems
    @Published private(set) var messages = OnePeopleMockData.messages
    @Published private(set) var attendanceTimeline = OnePeopleMockData.attendanceTimeline
    @Published private(set) var attendanceReportRows = OnePeopleMockData.attendanceReportRows
    @Published private(set) var attendanceCalendarMarkers = OnePeopleMockData.attendanceCalendarMarkers
    @Published private(set) var rosterMarkers = OnePeopleMockData.rosterMarkers
    @Published private(set) var assets = OnePeopleMockData.assets
    @Published private(set) var assetTransfers = OnePeopleMockData.assetTransfers
    @Published private(set) var payrollSections = OnePeopleMockData.payrollSections
    @Published private(set) var skillProfiles = OnePeopleMockData.skillProfiles
    @Published private(set) var internalProjects = OnePeopleMockData.internalProjects
    @Published private(set) var aiMessages = OnePeopleMockData.aiMessages
    @Published private(set) var aiSuggestedQuestions = OnePeopleMockData.aiSuggestedQuestions
    @Published private(set) var latestAttendanceSelfie: AttendanceSelfieAudit?
    @Published var searchText = ""
    @Published var biometricEnabled = false

    init() {
        let defaults = UserDefaults.standard
        let storedServerURL = Self.migratedServerURL(defaults.string(forKey: Self.serverURLKey) ?? "")
        let storedUsername = defaults.string(forKey: Self.lastUsernameKey) ?? ""
        serverURL = storedServerURL
        lastUsername = storedUsername
        activeUsername = Self.autoLoginEnabled ? (storedUsername.isEmpty ? "eko.ardianto" : storedUsername) : nil
        isAuthenticated = Self.autoLoginEnabled
        authErrorMessage = nil

        if defaults.string(forKey: Self.serverURLKey) != storedServerURL {
            defaults.set(storedServerURL, forKey: Self.serverURLKey)
        }
    }

    var hasConfiguredServer: Bool {
        !serverURL.isEmpty
    }

    var todayAttendance: AttendanceRecord? {
        attendanceHistory.sorted(by: { $0.date > $1.date }).first
    }

    var pendingApprovalsCount: Int {
        approvals.filter { $0.status == .pending }.count
    }

    var pendingLeaveCount: Int {
        leaveRequests.filter { $0.status == .pending }.count
    }

    var nextAttendanceAction: AttendanceActionMode {
        guard let today = todayAttendance else { return .checkIn }
        if today.checkIn == "-" || today.checkOut != "-" {
            return .checkIn
        }
        return .checkOut
    }

    var filteredAttendance: [AttendanceRecord] {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !keyword.isEmpty else { return attendanceHistory }
        return attendanceHistory.filter { record in
            record.status.rawValue.localizedCaseInsensitiveContains(keyword) ||
            record.location.localizedCaseInsensitiveContains(keyword) ||
            Self.dayFormatter.string(from: record.date).localizedCaseInsensitiveContains(keyword)
        }
    }

    var currentEmployeeSkillProfile: EmployeeSkillProfile? {
        skillProfiles.first(where: { $0.employeeId == profile.employeeID })
    }

    func updateServerURL(_ draft: String) -> Bool {
        guard let normalized = Self.normalizedServerURL(from: draft) else {
            authErrorMessage = "Format server URL belum valid."
            return false
        }

        serverURL = normalized
        UserDefaults.standard.set(normalized, forKey: Self.serverURLKey)
        authErrorMessage = nil
        return true
    }

    func login(username: String, password: String) -> Bool {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard hasConfiguredServer else {
            authErrorMessage = "Simpan server URL terlebih dahulu sebelum login."
            return false
        }

        guard !trimmedUsername.isEmpty, !trimmedPassword.isEmpty else {
            authErrorMessage = "Username dan password wajib diisi."
            return false
        }

        lastUsername = trimmedUsername
        activeUsername = trimmedUsername
        isAuthenticated = true
        authErrorMessage = nil
        UserDefaults.standard.set(trimmedUsername, forKey: Self.lastUsernameKey)
        return true
    }

    func logout() {
        isAuthenticated = false
        activeUsername = nil
        authErrorMessage = nil
    }

    func clearAuthErrorMessage() {
        authErrorMessage = nil
    }

    func checkIn() {
        guard let first = attendanceHistory.first else { return }
        if first.checkIn == "-" || first.checkOut != "-" {
            let newRecord = AttendanceRecord(
                id: UUID().uuidString,
                date: Date(),
                checkIn: Self.timeFormatter.string(from: Date()),
                checkOut: "-",
                workHours: "In Progress",
                status: .present,
                location: "Main Office"
            )
            attendanceHistory.insert(newRecord, at: 0)
        }
    }

    func checkOut() {
        guard !attendanceHistory.isEmpty else { return }
        let first = attendanceHistory[0]
        guard first.checkOut == "-" else { return }
        attendanceHistory[0] = AttendanceRecord(
            id: first.id,
            date: first.date,
            checkIn: first.checkIn,
            checkOut: Self.timeFormatter.string(from: Date()),
            workHours: "09h 00m",
            status: first.status,
            location: first.location
        )
    }

    func completeAttendanceAction(mode: AttendanceActionMode) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "dd MMM yyyy | HH:mm:ss"

        latestAttendanceSelfie = AttendanceSelfieAudit(
            id: UUID().uuidString,
            mode: mode,
            capturedAtText: formatter.string(from: Date()),
            note: "Selfie berhasil tersimpan untuk \(mode.rawValue)."
        )

        switch mode {
        case .checkIn:
            checkIn()
        case .checkOut:
            checkOut()
        }
    }

    func saveSkill(
        employeeId: String,
        skillId: String?,
        skillName: String,
        category: String,
        type: EmployeeSkillType,
        level: SkillProficiencyLevel
    ) {
        guard let profileIndex = skillProfiles.firstIndex(where: { $0.employeeId == employeeId }) else { return }

        let trimmedName = skillName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCategory = category.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, !trimmedCategory.isEmpty else { return }

        let updatedSkill = SkillRecord(
            id: skillId ?? UUID().uuidString,
            skillName: trimmedName,
            category: trimmedCategory,
            type: type,
            level: level
        )

        if let existingIndex = skillProfiles[profileIndex].skills.firstIndex(where: { $0.id == updatedSkill.id }) {
            skillProfiles[profileIndex].skills[existingIndex] = updatedSkill
        } else {
            skillProfiles[profileIndex].skills.append(updatedSkill)
        }

        skillProfiles[profileIndex].skills.sort { $0.skillName < $1.skillName }
        skillProfiles[profileIndex].updatedAt = currentTimestamp(dateFormat: "dd MMM yyyy")
    }

    func saveInternalProject(
        projectId: String?,
        title: String,
        description: String,
        businessUnit: String,
        projectOwner: String,
        duration: String,
        workload: String,
        status: InternalProjectStatus,
        requiredSkills: [ProjectSkillRequirement]
    ) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBusinessUnit = businessUnit.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedProjectOwner = projectOwner.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDuration = duration.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedWorkload = workload.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty,
              !trimmedDescription.isEmpty,
              !trimmedBusinessUnit.isEmpty,
              !trimmedProjectOwner.isEmpty,
              !trimmedDuration.isEmpty,
              !trimmedWorkload.isEmpty,
              !requiredSkills.isEmpty else {
            return
        }

        let updatedAt = currentTimestamp(dateFormat: "dd MMM yyyy")

        if let projectId, let index = internalProjects.firstIndex(where: { $0.id == projectId }) {
            internalProjects[index].projectTitle = trimmedTitle
            internalProjects[index].description = trimmedDescription
            internalProjects[index].businessUnit = trimmedBusinessUnit
            internalProjects[index].projectOwner = trimmedProjectOwner
            internalProjects[index].duration = trimmedDuration
            internalProjects[index].workload = trimmedWorkload
            internalProjects[index].status = status
            internalProjects[index].requiredSkills = requiredSkills
            internalProjects[index].updatedAt = updatedAt
        } else {
            let nextProjectNumber = internalProjects.count + 1
            let newProject = InternalProject(
                id: UUID().uuidString,
                projectId: String(format: "PRJ-%04d", nextProjectNumber + 2600),
                projectTitle: trimmedTitle,
                description: trimmedDescription,
                businessUnit: trimmedBusinessUnit,
                projectOwner: trimmedProjectOwner,
                duration: trimmedDuration,
                requiredSkills: requiredSkills,
                workload: trimmedWorkload,
                status: status,
                applicants: [],
                selectedMembers: [],
                createdAt: updatedAt,
                updatedAt: updatedAt
            )
            internalProjects.insert(newProject, at: 0)
        }
    }

    func applyCurrentUser(to projectId: String) {
        guard let projectIndex = internalProjects.firstIndex(where: { $0.id == projectId }),
              let currentSkillProfile = currentEmployeeSkillProfile else {
            return
        }

        guard internalProjects[projectIndex].status == .open else { return }
        guard !internalProjects[projectIndex].applicants.contains(where: { $0.employeeId == currentSkillProfile.employeeId }) else { return }

        let recommendation = candidateRecommendation(for: currentSkillProfile, project: internalProjects[projectIndex])
        let applicant = ProjectApplicant(
            id: UUID().uuidString,
            employeeId: currentSkillProfile.employeeId,
            fullName: currentSkillProfile.fullName,
            department: currentSkillProfile.department,
            position: currentSkillProfile.position,
            skillMatch: recommendation.skillMatch,
            matchingSkills: recommendation.matchingSkills,
            appliedAt: currentTimestamp(dateFormat: "dd MMM yyyy"),
            note: "Saya tertarik bergabung dan bisa kontribusi sesuai skill yang dimiliki."
        )

        internalProjects[projectIndex].applicants.insert(applicant, at: 0)
        internalProjects[projectIndex].updatedAt = currentTimestamp(dateFormat: "dd MMM yyyy")
    }

    func toggleApplicantSelection(projectId: String, applicantId: String) {
        guard let projectIndex = internalProjects.firstIndex(where: { $0.id == projectId }),
              let applicant = internalProjects[projectIndex].applicants.first(where: { $0.id == applicantId }) else {
            return
        }

        if let existingIndex = internalProjects[projectIndex].selectedMembers.firstIndex(of: applicant.employeeId) {
            internalProjects[projectIndex].selectedMembers.remove(at: existingIndex)
        } else {
            internalProjects[projectIndex].selectedMembers.append(applicant.employeeId)
        }

        if internalProjects[projectIndex].status == .open, !internalProjects[projectIndex].selectedMembers.isEmpty {
            internalProjects[projectIndex].status = .inProgress
        }
        internalProjects[projectIndex].updatedAt = currentTimestamp(dateFormat: "dd MMM yyyy")
    }

    func recommendedCandidates(for project: InternalProject) -> [ProjectApplicant] {
        skillProfiles
            .map { candidateRecommendation(for: $0, project: project) }
            .filter { $0.skillMatch > 0 }
            .sorted { lhs, rhs in
                if lhs.skillMatch == rhs.skillMatch {
                    return lhs.fullName < rhs.fullName
                }
                return lhs.skillMatch > rhs.skillMatch
            }
    }

    func recommendedProjectsForCurrentUser(limit: Int = 3) -> [InternalProject] {
        guard let currentSkillProfile = currentEmployeeSkillProfile else { return [] }

        return internalProjects
            .filter { $0.status == .open }
            .sorted { lhs, rhs in
                let lhsScore = candidateRecommendation(for: currentSkillProfile, project: lhs).skillMatch
                let rhsScore = candidateRecommendation(for: currentSkillProfile, project: rhs).skillMatch
                if lhsScore == rhsScore {
                    return lhs.projectTitle < rhs.projectTitle
                }
                return lhsScore > rhsScore
            }
            .prefix(limit)
            .map { $0 }
    }

    func topSkills(limit: Int = 3) -> [(name: String, count: Int)] {
        let counts = Dictionary(grouping: skillProfiles.flatMap(\.skills), by: { $0.skillName })
            .mapValues(\.count)
        return counts
            .map { (name: $0.key, count: $0.value) }
            .sorted { lhs, rhs in
                if lhs.count == rhs.count {
                    return lhs.name < rhs.name
                }
                return lhs.count > rhs.count
            }
            .prefix(limit)
            .map { $0 }
    }

    func skillGapHighlights(limit: Int = 3) -> [String] {
        let openRequirements = internalProjects
            .filter { $0.status != .closed }
            .flatMap(\.requiredSkills)

        let sortedRequirements = openRequirements.sorted {
            if $0.minimumLevel.rank == $1.minimumLevel.rank {
                return $0.skillName < $1.skillName
            }
            return $0.minimumLevel.rank > $1.minimumLevel.rank
        }

        var results: [String] = []
        for requirement in sortedRequirements {
            let matches = skillProfiles.filter { candidate in
                candidate.skills.contains(where: {
                    $0.skillName.caseInsensitiveCompare(requirement.skillName) == .orderedSame &&
                    $0.level.rank >= requirement.minimumLevel.rank
                })
            }

            if matches.count <= 1, !results.contains(requirement.skillName) {
                results.append(requirement.skillName)
            }

            if results.count == limit {
                break
            }
        }

        return results
    }

    func sendAIQuestion(_ question: String) {
        let trimmed = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        aiMessages.append(
            AIHRChatMessage(
                id: UUID().uuidString,
                role: .user,
                text: trimmed,
                timestamp: currentTimestamp(dateFormat: "HH:mm"),
                highlights: []
            )
        )

        aiMessages.append(assistantAnswer(for: trimmed))
    }

    func submitLeaveRequest() {
        let request = LeaveRequest(
            id: UUID().uuidString,
            title: "Annual Leave",
            type: "Annual Leave",
            startDateText: "31 Mar 2026",
            endDateText: "01 Apr 2026",
            durationText: "2 Days",
            reason: "Pengajuan cepat dari mobile app",
            status: .pending
        )
        leaveRequests.insert(request, at: 0)
    }

    func updateApproval(id: String, status: RequestStatus) {
        guard let index = approvals.firstIndex(where: { $0.id == id }) else { return }
        approvals[index].status = status
    }

    func requestStatusColor(_ status: RequestStatus) -> String {
        switch status {
        case .approved:
            return "#2AA6BA"
        case .pending:
            return "#B45309"
        case .rejected:
            return "#B91C1C"
        }
    }

    func attendanceStatusColor(_ status: AttendanceStatus) -> String {
        switch status {
        case .present:
            return "#2AA6BA"
        case .late:
            return "#B45309"
        case .remote:
            return "#1D4ED8"
        case .dayOff:
            return "#6B7280"
        }
    }

    func formattedDay(_ date: Date) -> String {
        Self.dayFormatter.string(from: date)
    }

    private func candidateRecommendation(for profile: EmployeeSkillProfile, project: InternalProject) -> ProjectApplicant {
        let matchingSkills = project.requiredSkills.compactMap { requirement in
            profile.skills.first(where: {
                $0.skillName.caseInsensitiveCompare(requirement.skillName) == .orderedSame &&
                $0.level.rank >= requirement.minimumLevel.rank
            })?.skillName
        }

        let totalRequirements = max(project.requiredSkills.count, 1)
        let score = Int((Double(matchingSkills.count) / Double(totalRequirements)) * 100)

        return ProjectApplicant(
            id: "rec-\(project.id)-\(profile.employeeId)",
            employeeId: profile.employeeId,
            fullName: profile.fullName,
            department: profile.department,
            position: profile.position,
            skillMatch: score,
            matchingSkills: matchingSkills,
            appliedAt: currentTimestamp(dateFormat: "dd MMM yyyy"),
            note: matchingSkills.isEmpty ? "Belum ada skill inti yang cocok." : "Cocok untuk \(matchingSkills.joined(separator: ", "))."
        )
    }

    private func assistantAnswer(for question: String) -> AIHRChatMessage {
        let lowered = question.lowercased()
        let timestamp = currentTimestamp(dateFormat: "HH:mm")

        if lowered.contains("cuti") {
            return AIHRChatMessage(
                id: UUID().uuidString,
                role: .assistant,
                text: "Sisa cuti tahunan Anda saat ini adalah \(profile.annualLeaveBalance) hari. Saat ini juga ada 1 pengajuan izin/cuti yang masih menunggu approval.",
                timestamp: timestamp,
                highlights: ["Sisa cuti: \(profile.annualLeaveBalance) hari", "1 pengajuan pending"]
            )
        }

        if lowered.contains("reimbursement") {
            return AIHRChatMessage(
                id: UUID().uuidString,
                role: .assistant,
                text: "Alur reimbursement internal umumnya: unggah bukti transaksi, isi form reimbursement, lalu tunggu verifikasi finance dan approval atasan.",
                timestamp: timestamp,
                highlights: ["Upload bukti", "Isi form", "Approval finance/atasan"]
            )
        }

        if lowered.contains("gaji") || lowered.contains("payroll") || lowered.contains("slip") {
            let latestPayslip = payslips.first
            return AIHRChatMessage(
                id: UUID().uuidString,
                role: .assistant,
                text: "Slip gaji terbaru Anda tersedia untuk \(latestPayslip?.month ?? "periode berjalan") dengan take home pay \(latestPayslip?.takeHomePay ?? "mock data belum tersedia").",
                timestamp: timestamp,
                highlights: [latestPayslip?.month ?? "Periode berjalan", latestPayslip?.takeHomePay ?? "Payroll"]
            )
        }

        if lowered.contains("benefit") {
            return AIHRChatMessage(
                id: UUID().uuidString,
                role: .assistant,
                text: "Benefit umum yang bisa dicek melalui One People antara lain BPJS, tunjangan operasional, hak cuti, dan dukungan pembelajaran internal. Untuk benefit khusus jabatan, tetap perlu konfirmasi ke HRBP.",
                timestamp: timestamp,
                highlights: ["BPJS", "Cuti", "Tunjangan", "Learning"]
            )
        }

        if lowered.contains("data analyst") || lowered.contains("skill") || lowered.contains("pelajari") {
            let recommendations = recommendedSkillDevelopment(for: lowered)
            return AIHRChatMessage(
                id: UUID().uuidString,
                role: .assistant,
                text: "Saya lihat pertanyaan Anda terkait pengembangan skill. Saya ambil referensi dari skill inventory Anda dan kebutuhan proyek internal yang sedang aktif.",
                timestamp: timestamp,
                highlights: recommendations
            )
        }

        if lowered.contains("proyek") || lowered.contains("project") {
            let recommendedProjects = recommendedProjectsForCurrentUser(limit: 3)
            let projectNames = recommendedProjects.map { $0.projectTitle }
            let responseText: String
            if projectNames.isEmpty {
                responseText = "Saat ini belum ada proyek open dengan skill match tinggi. Anda bisa memperkuat SQL, Data Visualization, atau Power BI untuk memperbesar peluang."
            } else {
                responseText = "Ada beberapa proyek internal yang cocok dengan profil Anda. Saya urutkan dari kecocokan skill tertinggi."
            }

            return AIHRChatMessage(
                id: UUID().uuidString,
                role: .assistant,
                text: responseText,
                timestamp: timestamp,
                highlights: projectNames.isEmpty ? recommendedSkillDevelopment(for: "project") : projectNames
            )
        }

        return AIHRChatMessage(
            id: UUID().uuidString,
            role: .assistant,
            text: "Saya bisa bantu pertanyaan tentang cuti, payroll, reimbursement, benefit, rekomendasi skill, dan proyek internal. Silakan kirim pertanyaan HR yang lebih spesifik.",
            timestamp: timestamp,
            highlights: aiSuggestedQuestions
        )
    }

    private func recommendedSkillDevelopment(for question: String) -> [String] {
        let targetSkills: [String]
        if question.contains("data analyst") {
            targetSkills = ["SQL", "Data Visualization", "Python", "Statistics"]
        } else {
            targetSkills = ["Problem Solving", "Stakeholder Communication", "SQL", "Power BI"]
        }

        let ownedSkills = Set(currentEmployeeSkillProfile?.skills.map { $0.skillName.lowercased() } ?? [])
        let gaps = targetSkills.filter { !ownedSkills.contains($0.lowercased()) }
        return Array((gaps.isEmpty ? targetSkills : gaps).prefix(4))
    }

    private func currentTimestamp(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = dateFormat
        return formatter.string(from: Date())
    }

    private static func normalizedServerURL(from rawValue: String) -> String? {
        let trimmed = migratedServerURL(rawValue.trimmingCharacters(in: .whitespacesAndNewlines))
        guard !trimmed.isEmpty else { return nil }

        let candidate = trimmed.contains("://") ? trimmed : "https://\(trimmed)"
        guard let components = URLComponents(string: candidate),
              let scheme = components.scheme,
              !scheme.isEmpty,
              let host = components.host,
              !host.isEmpty else {
            return nil
        }

        return candidate
    }

    private static func migratedServerURL(_ rawValue: String) -> String {
        guard !rawValue.isEmpty else { return rawValue }

        return rawValue
            .replacingOccurrences(of: "https://hcm.cde-coal.com", with: "https://hcm.ekozer.com")
            .replacingOccurrences(of: "http://hcm.cde-coal.com", with: "https://hcm.ekozer.com")
            .replacingOccurrences(of: "cde-coal.com", with: "ekozer.com")
    }

    private static let serverURLKey = "OnePeople.serverURL"
    private static let lastUsernameKey = "OnePeople.lastUsername"
    private static let autoLoginEnabled = {
        guard let rawValue = ProcessInfo.processInfo.environment["ONE_PEOPLE_AUTO_LOGIN"]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !rawValue.isEmpty else {
            return false
        }

        switch rawValue.lowercased() {
        case "1", "true", "yes":
            return true
        default:
            return false
        }
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE, dd MMM yyyy"
        return formatter
    }()
}
