import SwiftUI

struct SkillInventoryFeatureView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel

    @State private var keyword = ""
    @State private var selectedDepartment = "Semua Department"
    @State private var selectedCategory = "Semua Kategori"
    @State private var selectedLevel = "Semua Level"
    @State private var selectedProfile: SkillProfileRoute?

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Skill Inventory")

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    statsSection
                    SearchField(text: $keyword, placeholder: "Cari nama karyawan atau skill")
                    filterSection

                    if filteredProfiles.isEmpty {
                        EmptyStateBlock(
                            icon: "person.crop.circle.badge.questionmark",
                            title: "Data skill belum ditemukan",
                            subtitle: "Coba ubah kata kunci atau filter untuk melihat profil skill karyawan."
                        )
                        .padding(.top, 40)
                    } else {
                        ForEach(filteredProfiles) { profile in
                            Button {
                                selectedProfile = SkillProfileRoute(employeeId: profile.employeeId)
                            } label: {
                                SkillProfileCard(profile: profile)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 34)
            }
        }
        .background(Color(.systemGroupedBackground))
        .sheet(item: $selectedProfile) { route in
            SkillProfileDetailSheet(employeeId: route.employeeId)
                .environmentObject(appModel)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var filteredProfiles: [EmployeeSkillProfile] {
        appModel.skillProfiles.filter { profile in
            let matchesKeyword: Bool
            let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedKeyword.isEmpty {
                matchesKeyword = true
            } else {
                matchesKeyword =
                    profile.fullName.localizedCaseInsensitiveContains(trimmedKeyword) ||
                    profile.skills.contains(where: { $0.skillName.localizedCaseInsensitiveContains(trimmedKeyword) })
            }

            let matchesDepartment = selectedDepartment == "Semua Department" || profile.department == selectedDepartment
            let matchesCategory = selectedCategory == "Semua Kategori" || profile.skills.contains(where: { $0.category == selectedCategory })
            let matchesLevel = selectedLevel == "Semua Level" || profile.skills.contains(where: { $0.level.rawValue == selectedLevel })

            return matchesKeyword && matchesDepartment && matchesCategory && matchesLevel
        }
    }

    private var departmentOptions: [String] {
        ["Semua Department"] + Array(Set(appModel.skillProfiles.map(\.department))).sorted()
    }

    private var categoryOptions: [String] {
        ["Semua Kategori"] + Array(Set(appModel.skillProfiles.flatMap { $0.skills.map(\.category) })).sorted()
    }

    private var levelOptions: [String] {
        ["Semua Level"] + SkillProficiencyLevel.allCases.map(\.rawValue)
    }

    private var statsSection: some View {
        let topSkill = appModel.topSkills(limit: 1).first
        let gap = appModel.skillGapHighlights(limit: 1).first ?? "-"

        return VStack(spacing: 14) {
            HStack(spacing: 14) {
                TalentStatCard(title: "Total Karyawan", value: "\(appModel.skillProfiles.count)", subtitle: "Profil skill aktif", tintHex: "#2AA6BA")
                TalentStatCard(title: "Top Skill", value: topSkill?.name ?? "-", subtitle: "\(topSkill?.count ?? 0) karyawan", tintHex: "#4F80E1")
            }

            TalentStatCard(title: "Skill Gap", value: gap, subtitle: "Perlu talent tambahan", tintHex: "#D97706")
        }
    }

    private var filterSection: some View {
        VStack(spacing: 12) {
            MenuSelector(value: selectedDepartment, items: departmentOptions) { selectedDepartment = $0 }
            MenuSelector(value: selectedCategory, items: categoryOptions) { selectedCategory = $0 }
            MenuSelector(value: selectedLevel, items: levelOptions) { selectedLevel = $0 }
        }
    }
}

private struct SkillProfileDetailSheet: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel

    let employeeId: String

    @State private var editorContext: SkillEditorContext?

    private var profile: EmployeeSkillProfile? {
        appModel.skillProfiles.first(where: { $0.employeeId == employeeId })
    }

    private var hardSkills: [SkillRecord] {
        profile?.skills.filter { $0.type == .hardSkill } ?? []
    }

    private var softSkills: [SkillRecord] {
        profile?.skills.filter { $0.type == .softSkill } ?? []
    }

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Profil Skill")

            if let profile {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        profileHero(profile)
                        skillSection(title: "Hard Skill", items: hardSkills)
                        skillSection(title: "Soft Skill", items: softSkills)
                        certificationSection(profile.certifications)
                        experienceSection(profile.projectExperience)
                        careerSection(profile.careerInterest)
                    }
                    .onePeopleContentWidth()
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
                .safeAreaInset(edge: .bottom) {
                    Button {
                        editorContext = SkillEditorContext(employeeId: employeeId, skill: nil)
                    } label: {
                        Text("Tambah Skill")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(OnePeoplePalette.accentGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                }
            } else {
                EmptyStateBlock(
                    icon: "person.crop.circle.badge.exclam",
                    title: "Profil tidak ditemukan",
                    subtitle: "Data skill untuk karyawan ini belum tersedia."
                )
                .padding(.top, 80)
            }
        }
        .background(Color(.systemGroupedBackground))
        .sheet(item: $editorContext) { context in
            SkillEditorSheet(employeeId: context.employeeId, existingSkill: context.skill)
                .environmentObject(appModel)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func profileHero(_ profile: EmployeeSkillProfile) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ViewThatFits {
                HStack(spacing: 16) {
                    profileAvatar

                    VStack(alignment: .leading, spacing: 4) {
                        profileIdentity(profile)
                    }
                }

                VStack(alignment: .leading, spacing: 14) {
                    profileAvatar
                    profileIdentity(profile)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Minat Pengembangan Karier")
                    .font(.system(size: 17, weight: .bold))
                FlexibleTagWrap(tags: profile.careerInterest, tintHex: "#2AA6BA", backgroundHex: "#E7F7FA")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 14, y: 8)
    }

    private var profileAvatar: some View {
        ZStack {
            Circle()
                .fill(OnePeoplePalette.softMint)
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 44))
                .foregroundStyle(OnePeoplePalette.teal)
        }
        .frame(width: 74, height: 74)
    }

    private func profileIdentity(_ profile: EmployeeSkillProfile) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(profile.fullName)
                .font(.system(size: 24, weight: .bold))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Text(profile.position)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
            Text("\(profile.department) • \(profile.email)")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
    }

    private func skillSection(title: String, items: [SkillRecord]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Text("\(items.count) skill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            ForEach(items) { item in
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.skillName)
                            .font(.system(size: 17, weight: .semibold))
                        Text(item.category)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button("Edit") {
                        editorContext = SkillEditorContext(employeeId: employeeId, skill: item)
                    }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(OnePeoplePalette.teal)

                    SkillLevelChip(level: item.level)
                }
                if item.id != items.last?.id {
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }

    private func certificationSection(_ items: [CertificationRecord]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Sertifikasi")
                .font(.system(size: 20, weight: .bold))

            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 17, weight: .semibold))
                    Text("\(item.issuer) • \(item.yearText)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                if item.id != items.last?.id {
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }

    private func experienceSection(_ items: [ProjectExperienceRecord]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Pengalaman Proyek")
                .font(.system(size: 20, weight: .bold))

            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.projectName)
                        .font(.system(size: 17, weight: .semibold))
                    Text("\(item.role) • \(item.yearText)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(OnePeoplePalette.teal)
                    Text(item.summary)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                if item.id != items.last?.id {
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }

    private func careerSection(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Career Interest")
                .font(.system(size: 20, weight: .bold))
            FlexibleTagWrap(tags: items, tintHex: "#1D4ED8", backgroundHex: "#E8F1FF")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }
}

private struct SkillEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appModel: OnePeopleAppModel

    let employeeId: String
    let existingSkill: SkillRecord?

    @State private var skillName: String
    @State private var category: String
    @State private var selectedType: EmployeeSkillType
    @State private var selectedLevel: SkillProficiencyLevel

    init(employeeId: String, existingSkill: SkillRecord?) {
        self.employeeId = employeeId
        self.existingSkill = existingSkill
        _skillName = State(initialValue: existingSkill?.skillName ?? "")
        _category = State(initialValue: existingSkill?.category ?? "")
        _selectedType = State(initialValue: existingSkill?.type ?? .hardSkill)
        _selectedLevel = State(initialValue: existingSkill?.level ?? .intermediate)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    editorField(title: "Nama Skill") {
                        TextField("Masukkan nama skill", text: $skillName)
                            .font(.system(size: 17, weight: .medium))
                    }

                    editorField(title: "Kategori Skill") {
                        TextField("Contoh: Analytics / Operations", text: $category)
                            .font(.system(size: 17, weight: .medium))
                    }

                    editorField(title: "Tipe Skill") {
                        MenuSelector(value: selectedType.rawValue, items: EmployeeSkillType.allCases.map(\.rawValue)) {
                            selectedType = EmployeeSkillType(rawValue: $0) ?? .hardSkill
                        }
                    }

                    editorField(title: "Level") {
                        MenuSelector(value: selectedLevel.rawValue, items: SkillProficiencyLevel.allCases.map(\.rawValue)) {
                            selectedLevel = SkillProficiencyLevel(rawValue: $0) ?? .intermediate
                        }
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Tutup") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(existingSkill == nil ? "Tambah Skill" : "Edit Skill")
                        .font(.system(size: 20, weight: .bold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Simpan") {
                        appModel.saveSkill(
                            employeeId: employeeId,
                            skillId: existingSkill?.id,
                            skillName: skillName,
                            category: category,
                            type: selectedType,
                            level: selectedLevel
                        )
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold))
                }
            }
        }
    }

    private func editorField<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
            content()
                .padding(.horizontal, 16)
                .frame(height: 58)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ProjectMarketplaceFeatureView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel

    @State private var keyword = ""
    @State private var selectedStatus = "Semua Status"
    @State private var selectedBusinessUnit = "Semua Divisi"
    @State private var selectedProject: ProjectRoute?
    @State private var editorContext: ProjectEditorContext?

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Project Marketplace")

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    projectSummarySection
                    SearchField(text: $keyword, placeholder: "Cari project internal")
                    MenuSelector(value: selectedStatus, items: statusOptions) { selectedStatus = $0 }
                    MenuSelector(value: selectedBusinessUnit, items: businessUnitOptions) { selectedBusinessUnit = $0 }

                    Button {
                        editorContext = ProjectEditorContext(projectId: nil)
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Buat Project Baru")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                        }
                        .foregroundStyle(OnePeoplePalette.teal)
                        .padding(18)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(OnePeoplePalette.softMint, lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)

                    if filteredProjects.isEmpty {
                        EmptyStateBlock(
                            icon: "folder.badge.questionmark",
                            title: "Belum ada project yang cocok",
                            subtitle: "Coba ubah filter status atau divisi untuk melihat daftar project lain."
                        )
                        .padding(.top, 40)
                    } else {
                        ForEach(filteredProjects) { project in
                            Button {
                                selectedProject = ProjectRoute(projectId: project.id)
                            } label: {
                                ProjectMarketplaceCard(project: project)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 34)
            }
        }
        .background(Color(.systemGroupedBackground))
        .sheet(item: $selectedProject) { route in
            ProjectDetailSheet(
                projectId: route.projectId,
                onEdit: { editorContext = ProjectEditorContext(projectId: $0) }
            )
            .environmentObject(appModel)
        }
        .sheet(item: $editorContext) { context in
            ProjectEditorSheet(projectId: context.projectId)
                .environmentObject(appModel)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var filteredProjects: [InternalProject] {
        appModel.internalProjects.filter { project in
            let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
            let matchesKeyword: Bool
            if trimmedKeyword.isEmpty {
                matchesKeyword = true
            } else {
                matchesKeyword =
                    project.projectTitle.localizedCaseInsensitiveContains(trimmedKeyword) ||
                    project.description.localizedCaseInsensitiveContains(trimmedKeyword)
            }

            let matchesStatus = selectedStatus == "Semua Status" || project.status.rawValue == selectedStatus
            let matchesUnit = selectedBusinessUnit == "Semua Divisi" || project.businessUnit == selectedBusinessUnit
            return matchesKeyword && matchesStatus && matchesUnit
        }
    }

    private var statusOptions: [String] {
        ["Semua Status"] + InternalProjectStatus.allCases.map(\.rawValue)
    }

    private var businessUnitOptions: [String] {
        ["Semua Divisi"] + Array(Set(appModel.internalProjects.map(\.businessUnit))).sorted()
    }

    private var projectSummarySection: some View {
        let openProjects = appModel.internalProjects.filter { $0.status == .open }.count
        let activeProjects = appModel.internalProjects.filter { $0.status == .inProgress }.count
        let recommendedCount = appModel.recommendedProjectsForCurrentUser().count

        return ViewThatFits {
            HStack(spacing: 14) {
                TalentStatCard(title: "Open", value: "\(openProjects)", subtitle: "Project tersedia", tintHex: "#2AA6BA")
                TalentStatCard(title: "In Progress", value: "\(activeProjects)", subtitle: "Sedang berjalan", tintHex: "#D97706")
                TalentStatCard(title: "Rekomendasi", value: "\(recommendedCount)", subtitle: "Cocok untuk Anda", tintHex: "#4F80E1")
            }

            VStack(spacing: 14) {
                TalentStatCard(title: "Open", value: "\(openProjects)", subtitle: "Project tersedia", tintHex: "#2AA6BA")
                TalentStatCard(title: "In Progress", value: "\(activeProjects)", subtitle: "Sedang berjalan", tintHex: "#D97706")
                TalentStatCard(title: "Rekomendasi", value: "\(recommendedCount)", subtitle: "Cocok untuk Anda", tintHex: "#4F80E1")
            }
        }
    }
}

private struct ProjectDetailSheet: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel

    let projectId: String
    let onEdit: (String) -> Void

    private var project: InternalProject? {
        appModel.internalProjects.first(where: { $0.id == projectId })
    }

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Detail Project")

            if let project {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        overviewSection(project)

                        Button {
                            onEdit(project.id)
                        } label: {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                Text("Edit Project")
                                Spacer()
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(OnePeoplePalette.teal)
                            .padding(18)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .buttonStyle(.plain)

                        requirementSection(project.requiredSkills)
                        recommendationSection(project)
                        applicantSection(project)
                        selectedMemberSection(project)
                    }
                    .onePeopleContentWidth()
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 110)
                }
                .safeAreaInset(edge: .bottom) {
                    if project.status == .open {
                        Button {
                            appModel.applyCurrentUser(to: project.id)
                        } label: {
                            Text("Apply Project")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(OnePeoplePalette.accentGradient)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                    }
                }
            } else {
                EmptyStateBlock(
                    icon: "folder.badge.minus",
                    title: "Project tidak ditemukan",
                    subtitle: "Data project sudah berubah atau belum tersedia."
                )
                .padding(.top, 80)
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar(.hidden, for: .navigationBar)
    }

    private func overviewSection(_ project: InternalProject) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(project.projectTitle)
                        .font(.system(size: 24, weight: .bold))
                    Text("\(project.businessUnit) • \(project.projectOwner)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                StatusCapsule(title: project.status.rawValue, tintHex: project.status.tintHex)
            }

            Text(project.description)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                DetailPill(icon: "calendar", text: project.duration)
                DetailPill(icon: "clock", text: project.workload)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 6)
    }

    private func requirementSection(_ requirements: [ProjectSkillRequirement]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Required Skills")
                .font(.system(size: 20, weight: .bold))
            FlexibleTagWrap(
                tags: requirements.map { "\($0.skillName) • \($0.minimumLevel.rawValue)" },
                tintHex: "#7C3AED",
                backgroundHex: "#F4EEFF"
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }

    private func recommendationSection(_ project: InternalProject) -> some View {
        let recommendations = Array(appModel.recommendedCandidates(for: project).prefix(3))

        return VStack(alignment: .leading, spacing: 14) {
            Text("Kandidat Rekomendasi")
                .font(.system(size: 20, weight: .bold))

            if recommendations.isEmpty {
                Text("Belum ada kandidat dengan skill match yang sesuai.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
            } else {
                ForEach(recommendations) { item in
                    CandidateRecommendationCard(item: item)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }

    private func applicantSection(_ project: InternalProject) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Applicant List")
                .font(.system(size: 20, weight: .bold))

            if project.applicants.isEmpty {
                Text("Belum ada applicant untuk project ini.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
            } else {
                ForEach(project.applicants) { item in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.fullName)
                                    .font(.system(size: 17, weight: .semibold))
                                Text("\(item.position) • \(item.department)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(item.skillMatch)%")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(OnePeoplePalette.teal)
                        }

                        FlexibleTagWrap(tags: item.matchingSkills, tintHex: "#2AA6BA", backgroundHex: "#E7F7FA")

                        HStack {
                            Text(item.note)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button(project.selectedMembers.contains(item.employeeId) ? "Batalkan" : "Pilih") {
                                appModel.toggleApplicantSelection(projectId: project.id, applicantId: item.id)
                            }
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(OnePeoplePalette.teal)
                        }
                    }

                    if item.id != project.applicants.last?.id {
                        Divider()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }

    private func selectedMemberSection(_ project: InternalProject) -> some View {
        let memberNames = appModel.skillProfiles
            .filter { project.selectedMembers.contains($0.employeeId) }
            .map(\.fullName)

        return VStack(alignment: .leading, spacing: 14) {
            Text("Selected Members")
                .font(.system(size: 20, weight: .bold))

            if memberNames.isEmpty {
                Text("Belum ada anggota project yang dipilih.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
            } else {
                FlexibleTagWrap(tags: memberNames, tintHex: "#2AA6BA", backgroundHex: "#E7F7FA")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }
}

private struct ProjectEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appModel: OnePeopleAppModel

    let projectId: String?

    @State private var title = ""
    @State private var description = ""
    @State private var businessUnit = ""
    @State private var projectOwner = ""
    @State private var duration = ""
    @State private var workload = ""
    @State private var status: InternalProjectStatus = .open
    @State private var requiredSkillText = ""

    private var existingProject: InternalProject? {
        guard let projectId else { return nil }
        return appModel.internalProjects.first(where: { $0.id == projectId })
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    formField(title: "Judul Project") {
                        TextField("Masukkan judul project", text: $title)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Deskripsi")
                            .font(.system(size: 16, weight: .bold))
                        TextEditor(text: $description)
                            .frame(minHeight: 120)
                            .padding(12)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                    }

                    formField(title: "Business Unit") {
                        TextField("Contoh: HRIS", text: $businessUnit)
                    }

                    formField(title: "Project Owner") {
                        TextField("Nama owner", text: $projectOwner)
                    }

                    formField(title: "Durasi") {
                        TextField("Contoh: 8 Weeks", text: $duration)
                    }

                    formField(title: "Workload") {
                        TextField("Contoh: 6 jam / minggu", text: $workload)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Status")
                            .font(.system(size: 16, weight: .bold))
                        MenuSelector(value: status.rawValue, items: InternalProjectStatus.allCases.map(\.rawValue)) {
                            status = InternalProjectStatus(rawValue: $0) ?? .open
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Required Skills")
                            .font(.system(size: 16, weight: .bold))
                        TextEditor(text: $requiredSkillText)
                            .frame(minHeight: 120)
                            .padding(12)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                        Text("Gunakan format `Skill:Level` per baris. Contoh: `SQL:Intermediate`")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Tutup") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(existingProject == nil ? "Create Project" : "Edit Project")
                        .font(.system(size: 20, weight: .bold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Simpan") {
                        appModel.saveInternalProject(
                            projectId: existingProject?.id,
                            title: title,
                            description: description,
                            businessUnit: businessUnit,
                            projectOwner: projectOwner,
                            duration: duration,
                            workload: workload,
                            status: status,
                            requiredSkills: parsedRequirements
                        )
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold))
                }
            }
            .onAppear {
                guard let existingProject else {
                    projectOwner = appModel.profile.fullName
                    return
                }

                title = existingProject.projectTitle
                description = existingProject.description
                businessUnit = existingProject.businessUnit
                projectOwner = existingProject.projectOwner
                duration = existingProject.duration
                workload = existingProject.workload
                status = existingProject.status
                requiredSkillText = existingProject.requiredSkills
                    .map { "\($0.skillName):\($0.minimumLevel.rawValue)" }
                    .joined(separator: "\n")
            }
        }
    }

    private var parsedRequirements: [ProjectSkillRequirement] {
        requiredSkillText
            .split(whereSeparator: \.isNewline)
            .compactMap { rawLine in
                let parts = rawLine.split(separator: ":", maxSplits: 1).map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                guard let skillName = parts.first, !skillName.isEmpty else { return nil }
                let level = parts.count > 1 ? SkillProficiencyLevel(rawValue: parts[1]) ?? .intermediate : .intermediate
                return ProjectSkillRequirement(id: UUID().uuidString, skillName: skillName, minimumLevel: level)
            }
    }

    private func formField(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
            content()
                .font(.system(size: 17, weight: .medium))
                .padding(.horizontal, 16)
                .frame(height: 58)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AIHRAssistantFeatureView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel

    @State private var inputText = ""

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "AI HR Assistant")

            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        assistantHero
                        suggestedQuestions

                        ForEach(appModel.aiMessages) { message in
                            AIMessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .onePeopleContentWidth()
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 110)
                }
                .onChange(of: appModel.aiMessages.count) { _ in
                    if let lastId = appModel.aiMessages.last?.id {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 12) {
                TextField("Tulis pertanyaan HR Anda", text: $inputText)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.horizontal, 16)
                    .frame(height: 54)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                Button {
                    sendQuestion()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(OnePeoplePalette.teal)
                }
            }
            .onePeopleContentWidth()
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var assistantHero: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tanya HR lebih cepat")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(OnePeoplePalette.ink)
            Text("Saya bisa bantu FAQ cuti, payroll, reimbursement, rekomendasi skill, dan proyek internal berdasarkan data mock yang ada di aplikasi.")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(OnePeoplePalette.ink.opacity(0.78))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(OnePeopleFlowingBackdrop(cornerRadius: 24))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var suggestedQuestions: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 150), spacing: 10, alignment: .leading)],
            alignment: .leading,
            spacing: 10
        ) {
            ForEach(appModel.aiSuggestedQuestions, id: \.self) { question in
                Button {
                    inputText = question
                    sendQuestion()
                } label: {
                    Text(question)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(OnePeoplePalette.teal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(OnePeoplePalette.softMint)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func sendQuestion() {
        let question = inputText
        inputText = ""
        appModel.sendAIQuestion(question)
    }
}

private struct SkillProfileCard: View {
    let profile: EmployeeSkillProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(profile.fullName)
                        .font(.system(size: 19, weight: .bold))
                    Text("\(profile.position) • \(profile.department)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(profile.skills.count) skill")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(OnePeoplePalette.teal)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(OnePeoplePalette.softMint)
                    .clipShape(Capsule())
            }

            FlexibleTagWrap(tags: Array(profile.skills.prefix(4)).map { "\($0.skillName) • \($0.level.rawValue)" }, tintHex: "#2AA6BA", backgroundHex: "#E7F7FA")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }
}

private struct SkillLevelChip: View {
    let level: SkillProficiencyLevel

    var body: some View {
        Text(level.rawValue)
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(Color(hex: level.tintHex))
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Color(hex: level.tintHex).opacity(0.12))
            .clipShape(Capsule())
    }
}

private struct ProjectMarketplaceCard: View {
    let project: InternalProject

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(project.projectTitle)
                        .font(.system(size: 19, weight: .bold))
                    Text("\(project.businessUnit) • \(project.projectOwner)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                StatusCapsule(title: project.status.rawValue, tintHex: project.status.tintHex)
            }

            Text(project.description)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(3)

            FlexibleTagWrap(tags: project.requiredSkills.map { $0.skillName }, tintHex: "#7C3AED", backgroundHex: "#F4EEFF")

            HStack(spacing: 10) {
                DetailPill(icon: "calendar", text: project.duration)
                DetailPill(icon: "person.2", text: "\(project.applicants.count) applicant")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }
}

private struct CandidateRecommendationCard: View {
    let item: ProjectApplicant

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.fullName)
                        .font(.system(size: 17, weight: .semibold))
                    Text("\(item.position) • \(item.department)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(item.skillMatch)%")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(OnePeoplePalette.teal)
            }

            FlexibleTagWrap(tags: item.matchingSkills, tintHex: "#2AA6BA", backgroundHex: "#E7F7FA")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct AIMessageBubble: View {
    let message: AIHRChatMessage

    var body: some View {
        VStack(alignment: message.role == .assistant ? .leading : .trailing, spacing: 8) {
            Text(message.text)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(message.role == .assistant ? Color.primary : .white)
                .padding(16)
                .background(message.role == .assistant ? Color.white : OnePeoplePalette.teal)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            if !message.highlights.isEmpty {
                FlexibleTagWrap(
                    tags: message.highlights,
                    tintHex: message.role == .assistant ? "#2AA6BA" : "#FFFFFF",
                    backgroundHex: message.role == .assistant ? "#E7F7FA" : "#4F80E1"
                )
            }

            Text(message.timestamp)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: message.role == .assistant ? .leading : .trailing)
    }
}

private struct TalentStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let tintHex: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(hex: tintHex))
                .lineLimit(2)
                .minimumScaleFactor(0.75)
            Text(subtitle)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 6)
    }
}

private struct StatusCapsule: View {
    let title: String
    let tintHex: String

    var body: some View {
        Text(title)
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(Color(hex: tintHex))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(hex: tintHex).opacity(0.12))
            .clipShape(Capsule())
    }
}

private struct DetailPill: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(.secondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
    }
}

private struct FlexibleTagWrap: View {
    let tags: [String]
    let tintHex: String
    let backgroundHex: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(chunkedTags, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color(hex: tintHex))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .background(Color(hex: backgroundHex))
                            .clipShape(Capsule())
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private var chunkedTags: [[String]] {
        stride(from: 0, to: tags.count, by: 2).map { index in
            Array(tags[index..<min(index + 2, tags.count)])
        }
    }
}

private struct SkillProfileRoute: Identifiable {
    let employeeId: String
    var id: String { employeeId }
}

private struct SkillEditorContext: Identifiable {
    let employeeId: String
    let skill: SkillRecord?

    var id: String {
        skill?.id ?? "new-\(employeeId)"
    }
}

private struct ProjectRoute: Identifiable {
    let projectId: String
    var id: String { projectId }
}

private struct ProjectEditorContext: Identifiable {
    let projectId: String?
    var id: String { projectId ?? "new-project" }
}
