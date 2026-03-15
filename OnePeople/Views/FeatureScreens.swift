import SwiftUI
import UIKit

struct OnePeopleContentWidthModifier: ViewModifier {
    let maxWidth: CGFloat

    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            content.frame(maxWidth: maxWidth, alignment: .leading)
            Spacer(minLength: 0)
        }
    }
}

extension View {
    func onePeopleContentWidth(_ maxWidth: CGFloat = 760) -> some View {
        modifier(OnePeopleContentWidthModifier(maxWidth: maxWidth))
    }
}

enum OnePeoplePalette {
    static let ink = Color(hex: "#16324F")
    static let tealLight = Color(hex: "#6FD7D7")
    static let teal = Color(hex: "#2AA6BA")
    static let blue = Color(hex: "#4F80E1")
    static let deepBlue = Color(hex: "#2854AE")
    static let softSurface = Color(hex: "#F4FAFF")
    static let softMint = Color(hex: "#E7F7FA")
    static let warmOrange = Color(hex: "#FFB67A")
    static let warmYellow = Color(hex: "#FFE39D")

    static let accentGradient = LinearGradient(
        colors: [teal, blue],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct OnePeopleFlowingBackdrop: View {
    var cornerRadius: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let width = max(proxy.size.width, 1)
            let height = max(proxy.size.height, 1)

            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: "#F7FBFF"),
                        Color(hex: "#EEF8FB"),
                        Color(hex: "#FFF9F1")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [OnePeoplePalette.tealLight.opacity(0.96), OnePeoplePalette.blue.opacity(0.92)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: width * 0.9, height: height * 1.1)
                    .offset(x: width * 0.28, y: -height * 0.36)
                    .shadow(color: OnePeoplePalette.blue.opacity(0.12), radius: 28, y: 10)

                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [OnePeoplePalette.deepBlue.opacity(0.8), OnePeoplePalette.teal.opacity(0.7)],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                    .frame(width: width * 0.7, height: height * 0.82)
                    .offset(x: width * 0.32, y: -height * 0.14)

                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [OnePeoplePalette.warmOrange.opacity(0.92), OnePeoplePalette.warmYellow.opacity(0.86)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: width * 0.5, height: height * 0.64)
                    .offset(x: -width * 0.28, y: height * 0.38)
                    .shadow(color: OnePeoplePalette.warmOrange.opacity(0.18), radius: 18, y: 10)

                Ellipse()
                    .fill(Color.white.opacity(0.28))
                    .frame(width: width * 0.64, height: height * 0.36)
                    .blur(radius: 14)
                    .offset(x: -width * 0.12, y: height * 0.48)

                Circle()
                    .stroke(Color.white.opacity(0.35), lineWidth: 2)
                    .frame(width: min(width, height) * 0.72, height: min(width, height) * 0.72)
                    .offset(x: width * 0.28, y: -height * 0.24)
            }
            .frame(width: width, height: height)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

enum OnePeopleLaunchOptions {
    private static let environment = ProcessInfo.processInfo.environment

    static var initialFeature: OnePeopleFeature? {
        guard let rawValue = environment["ONE_PEOPLE_INITIAL_FEATURE"]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !rawValue.isEmpty else {
            return nil
        }

        let normalized = rawValue.lowercased()
        return OnePeopleFeature.allCases.first { feature in
            feature.rawValue.lowercased() == normalized ||
            String(describing: feature).lowercased() == normalized
        }
    }

    static var attendanceTab: String? {
        tabValue(
            key: "ONE_PEOPLE_ATTENDANCE_TAB",
            mapping: [
                "summary": "Summary",
                "checkin": "Check In",
                "check-in": "Check In"
            ]
        )
    }

    static var approvalTab: String? {
        tabValue(
            key: "ONE_PEOPLE_APPROVAL_TAB",
            mapping: [
                "waiting": "Waiting Approval",
                "history": "Approval History"
            ]
        )
    }

    static var attendanceReportMode: String? {
        tabValue(
            key: "ONE_PEOPLE_REPORT_MODE",
            mapping: [
                "summary": "Ringkasan Kehadiran",
                "calendar": "Tampilan Kalender",
                "table": "Tampilan Tabel"
            ]
        )
    }

    static var initialTabIndex: Int? {
        guard let rawValue = environment["ONE_PEOPLE_INITIAL_TAB"]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !rawValue.isEmpty else {
            return nil
        }

        switch rawValue.lowercased() {
        case "home", "beranda":
            return 0
        case "account", "akun", "profile":
            return 1
        case "settings", "pengaturan":
            return 2
        case "messages", "pesan":
            return 3
        case "logout", "log out":
            return 4
        default:
            return nil
        }
    }

    static var skipLogin: Bool {
        guard let rawValue = environment["ONE_PEOPLE_SKIP_LOGIN"]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !rawValue.isEmpty else {
            return false
        }

        switch rawValue.lowercased() {
        case "1", "true", "yes":
            return true
        default:
            return false
        }
    }

    static var presentsServerSettingsSheet: Bool {
        guard let rawValue = environment["ONE_PEOPLE_SHOW_SERVER_SETTINGS"]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !rawValue.isEmpty else {
            return false
        }

        switch rawValue.lowercased() {
        case "1", "true", "yes":
            return true
        default:
            return false
        }
    }

    static var presentsSelfieSheet: Bool {
        selfieMode != nil
    }

    static var selfieMode: AttendanceActionMode? {
        guard let rawValue = environment["ONE_PEOPLE_SELFIE_MODE"]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !rawValue.isEmpty else {
            return nil
        }

        let normalized = rawValue.lowercased()
        switch normalized {
        case "checkin", "check-in":
            return .checkIn
        case "checkout", "check-out":
            return .checkOut
        default:
            return nil
        }
    }

    private static func tabValue(key: String, mapping: [String: String]) -> String? {
        guard let rawValue = environment[key]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !rawValue.isEmpty else {
            return nil
        }
        return mapping[rawValue.lowercased()]
    }
}

struct OnePeopleFeatureScreen: View {
    let feature: OnePeopleFeature

    @ViewBuilder
    var body: some View {
        switch feature {
        case .attendance:
            AttendanceFeatureView()
        case .approval:
            ApprovalFeatureView()
        case .asset:
            AssetFeatureView()
        case .leave:
            LeaveFeatureView()
        case .attendanceReport:
            AttendanceReportFeatureView()
        case .roster:
            RosterFeatureView()
        case .payslip:
            PayslipFeatureView()
        case .skillInventory:
            SkillInventoryFeatureView()
        case .projectMarketplace:
            ProjectMarketplaceFeatureView()
        case .aiAssistant:
            AIHRAssistantFeatureView()
        }
    }
}

private struct AttendanceFeatureView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @State private var selectedTab = "Summary"
    @State private var selfieMode: AttendanceActionMode?

    private let tabs = ["Summary", "Check In"]

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Absensi")
            TopSegmentTabs(options: tabs, selection: $selectedTab)
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.top, 12)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    if selectedTab == "Summary" {
                        summaryContent
                    } else {
                        timelineContent
                    }
                }
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .background(Color(.systemBackground))
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                if let audit = appModel.latestAttendanceSelfie {
                    SelfieAuditBanner(audit: audit)
                }

                Button {
                    selfieMode = appModel.nextAttendanceAction
                } label: {
                    Text(appModel.nextAttendanceAction.buttonTitle)
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(
                            OnePeoplePalette.accentGradient
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(.ultraThinMaterial)
        }
        .sheet(item: $selfieMode) { mode in
            SelfieCaptureSheet(mode: mode) {
                appModel.completeAttendanceAction(mode: mode)
            }
        }
        .onAppear {
            if let launchTab = OnePeopleLaunchOptions.attendanceTab {
                selectedTab = launchTab
            }

            guard selfieMode == nil, let launchMode = OnePeopleLaunchOptions.selfieMode else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                selfieMode = launchMode
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var summaryContent: some View {
        VStack(spacing: 18) {
            FilterField(label: "PERIODE", value: "26 Feb 2026 - 15 Mar 2026")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                StatSquareCard(value: "10", unit: "Hari", title: "Kehadiran")
                StatSquareCard(value: "1", unit: "Hari", title: "Izin")
                StatSquareCard(value: "0", unit: "Hari", title: "Absen")
            }

            if let audit = appModel.latestAttendanceSelfie {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Status Selfie Terakhir")
                        .font(.system(size: 17, weight: .semibold))
                    SelfieAuditBanner(audit: audit)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var timelineContent: some View {
        VStack(spacing: 18) {
            FilterField(label: "PERIODE", value: "2026-02-26 ~ 2026-03-15", trailingIcon: "calendar")

            VStack(spacing: 0) {
                ForEach(appModel.attendanceTimeline) { entry in
                    AttendanceTimelineCard(entry: entry)

                    if entry.id != appModel.attendanceTimeline.last?.id {
                        Divider()
                            .padding(.leading, 24)
                    }
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 14, y: 8)
        }
    }
}

private struct ApprovalFeatureView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @State private var selectedTab = "Waiting Approval"
    @State private var keyword = ""
    private let tabs = ["Waiting Approval", "Approval History"]

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Approval")

            TopSegmentTabs(options: tabs, selection: $selectedTab)
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.top, 12)

            VStack(spacing: 16) {
                SearchField(text: $keyword, placeholder: "Cari ..")
                AccentOutlinedFilter(title: "Semua Tanggal")
            }
            .onePeopleContentWidth()
            .padding(.horizontal, 20)
            .padding(.top, 22)

            Divider()
                .padding(.top, 18)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    if filteredApprovals.isEmpty {
                        EmptyStateBlock(
                            icon: "folder.badge.questionmark",
                            title: "Sorry, Data Not Available",
                            subtitle: "Belum ada data approval untuk filter yang dipilih."
                        )
                        .padding(.top, 72)
                    } else {
                        ForEach(filteredApprovals) { item in
                            ApprovalHistoryCard(item: item)
                        }
                        .padding(.top, 18)
                    }
                }
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            if let launchTab = OnePeopleLaunchOptions.approvalTab {
                selectedTab = launchTab
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var filteredApprovals: [ApprovalItem] {
        let source: [ApprovalItem]
        if selectedTab == "Waiting Approval" {
            source = appModel.approvals.filter { $0.status == .pending }
        } else {
            source = appModel.approvals.filter { $0.status != .pending }
        }

        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return source }
        return source.filter {
            $0.requester.localizedCaseInsensitiveContains(trimmed) ||
            $0.title.localizedCaseInsensitiveContains(trimmed)
        }
    }
}

private struct AssetFeatureView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @State private var selectedTab = "Aset Saya"
    @State private var keyword = ""
    private let tabs = ["Aset Saya", "Riwayat Transfer"]

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Aset")

            OnePeopleFlowingBackdrop()
            .frame(height: 158)
            .overlay {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "shippingbox")
                            .font(.system(size: 34))
                            .foregroundStyle(OnePeoplePalette.ink)
                        Text("1 Aset")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(OnePeoplePalette.ink)
                        Text("Dari 1 Kategori")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(OnePeoplePalette.ink.opacity(0.72))
                    }

                    Spacer()

                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.white)
                            .frame(width: 74, height: 74)
                            .overlay {
                                Image(systemName: "arrow.down.doc")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(OnePeoplePalette.teal)
                            }

                        Text("Terima Aset")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(OnePeoplePalette.ink)
                    }
                }
                .padding(.horizontal, 24)
            }

            TopSegmentTabs(options: tabs, selection: $selectedTab)
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.top, -18)

            VStack(spacing: 16) {
                SearchField(text: $keyword, placeholder: "Cari nama atau kategori aset")

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if selectedTab == "Aset Saya" {
                            ForEach(filteredAssets) { asset in
                                AssetCard(item: asset)
                            }
                        } else {
                            ForEach(filteredTransfers) { item in
                                TransferCard(item: item)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .onePeopleContentWidth()
            .padding(.horizontal, 20)
            .padding(.top, 18)
        }
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
    }

    private var filteredAssets: [AssetRecord] {
        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return appModel.assets }
        return appModel.assets.filter {
            $0.title.localizedCaseInsensitiveContains(trimmed) ||
            $0.subtitle.localizedCaseInsensitiveContains(trimmed)
        }
    }

    private var filteredTransfers: [AssetTransferRecord] {
        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return appModel.assetTransfers }
        return appModel.assetTransfers.filter {
            $0.title.localizedCaseInsensitiveContains(trimmed) ||
            $0.detail.localizedCaseInsensitiveContains(trimmed)
        }
    }
}

private struct LeaveFeatureView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @State private var selectedTab = "Pengajuan"
    private let tabs = ["Pengajuan", "Riwayat"]

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Izin")

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    LinearGradient(
                        colors: [Color(hex: "#FFF0F7"), Color(hex: "#FDF7FF")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(height: 150)
                    .overlay {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Saldo Izin")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(.secondary)
                                Text("\(appModel.profile.annualLeaveBalance) Hari")
                                    .font(.system(size: 32, weight: .heavy))
                                Text("Cuti tahunan tersedia")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button("Ajukan Izin") {
                                appModel.submitLeaveRequest()
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(OnePeoplePalette.accentGradient)
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal, 22)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

                    TopSegmentTabs(options: tabs, selection: $selectedTab)

                    VStack(spacing: 14) {
                        ForEach(filteredLeaves) { item in
                            LeaveRequestCard(item: item)
                        }
                    }
                }
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 30)
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar(.hidden, for: .navigationBar)
    }

    private var filteredLeaves: [LeaveRequest] {
        if selectedTab == "Pengajuan" {
            return appModel.leaveRequests.filter { $0.status == .pending }
        }
        return appModel.leaveRequests.filter { $0.status != .pending }
    }
}

private struct AttendanceReportFeatureView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @State private var selectedMode = "Ringkasan Kehadiran"
    private let modes = ["Ringkasan Kehadiran", "Tampilan Kalender", "Tampilan Tabel"]

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Laporan Kehadiran")

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    MenuSelector(value: selectedMode, items: modes) { selectedMode = $0 }
                    MonthSelector(title: selectedMode == "Ringkasan Kehadiran" ? "March 2026" : "March 2026")

                    if selectedMode == "Ringkasan Kehadiran" {
                        summaryReport
                    } else if selectedMode == "Tampilan Kalender" {
                        MonthGridCard(markers: appModel.attendanceCalendarMarkers)
                        LegendSection(items: [
                            ("Belum ada keterangan", Color.white, true),
                            ("Hadir", OnePeoplePalette.teal, false),
                            ("Libur / Cuti Roster", Color(hex: "#8F8F8F"), false),
                            ("Tidak Ada In / Tidak Ada Out", Color.red, false)
                        ])
                    } else {
                        AttendanceTableCard(rows: appModel.attendanceReportRows)
                    }
                }
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            if let launchMode = OnePeopleLaunchOptions.attendanceReportMode {
                selectedMode = launchMode
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var summaryReport: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
            StatSquareCard(value: "10", unit: "Hari", title: "Kehadiran")
            StatSquareCard(value: "1", unit: "Hari", title: "Izin")
            StatSquareCard(value: "0", unit: "Hari", title: "Absen")
        }
    }
}

private struct RosterFeatureView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Roster")

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    MonthSelector(title: "March 2026")
                    MonthGridCard(markers: appModel.rosterMarkers)
                    LegendSection(items: [
                        ("Belum ada keterangan", Color.white, true),
                        ("Hadir", OnePeoplePalette.teal, false),
                        ("Off", Color(hex: "#8F8F8F"), false)
                    ])
                }
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct PayslipFeatureView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @State private var selectedPeriod = "Februari 2026"
    private let periods = ["Februari 2026", "Januari 2026", "Desember 2025"]

    var body: some View {
        VStack(spacing: 0) {
            FeatureHeader(title: "Slip Gaji")

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(OnePeoplePalette.accentGradient)
                        .frame(height: 154)
                        .overlay {
                            VStack(spacing: 10) {
                                Text("Gaji Bersih")
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.95))
                                Text("Rp. 10,000,000.00")
                                    .font(.system(size: 30, weight: .light))
                                    .foregroundStyle(.white)
                            }
                        }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("PERIODE")
                            .font(.system(size: 16, weight: .heavy))
                        MenuSelector(value: selectedPeriod, items: periods) { selectedPeriod = $0 }
                    }

                    ForEach(appModel.payrollSections) { section in
                        PayrollSectionCard(section: section)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 10) {
                            Image(systemName: "doc")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundStyle(OnePeoplePalette.teal)
                            Text("Lampiran")
                                .font(.system(size: 22, weight: .bold))
                        }

                        Divider()

                        HStack {
                            Text("Bukti Slip Gaji.pdf")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Image(systemName: "document.fill")
                                .font(.system(size: 34))
                                .foregroundStyle(Color(.systemGray4))
                        }
                        .padding(18)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
                .onePeopleContentWidth()
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 34)
            }
        }
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct FeatureHeader: View {
    @Environment(\.dismiss) private var dismiss

    let title: String

    var body: some View {
        HStack(spacing: 16) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.black)
            }

            Text(title)
                .font(.largeTitle.weight(.heavy))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer()
        }
        .onePeopleContentWidth()
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 18)
    }
}

struct TopSegmentTabs: View {
    let options: [String]
    @Binding var selection: String

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { item in
                Button {
                    selection = item
                } label: {
                    VStack(spacing: 14) {
                        Text(item)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(selection == item ? OnePeoplePalette.teal : .black)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 16)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Rectangle()
                            .fill(selection == item ? OnePeoplePalette.blue : .clear)
                            .frame(height: 4)
                    }
                    .background(.white)
                }
                .buttonStyle(.plain)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(.systemGray5), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct SearchField: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "magnifyingglass")
                .font(.title3.weight(.semibold))
            TextField(placeholder, text: $text)
                .font(.body.weight(.medium))
        }
        .padding(.horizontal, 18)
        .frame(height: 60)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 14, y: 8)
    }
}

private struct AccentOutlinedFilter: View {
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(OnePeoplePalette.teal)
            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(OnePeoplePalette.teal)
        }
        .padding(.horizontal, 20)
        .frame(height: 52)
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(OnePeoplePalette.teal, lineWidth: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct EmptyStateBlock: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 72))
                .foregroundStyle(Color(.systemGray3))

            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.gray)

            Text(subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity)
        .onePeopleContentWidth(500)
    }
}

private struct FilterField: View {
    let label: String
    let value: String
    var trailingIcon: String = "checkmark"

    var body: some View {
        HStack {
            Text(label)
                .font(.headline.weight(.heavy))
                .foregroundStyle(Color(.systemGray))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer()

            if value != label {
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            Image(systemName: trailingIcon)
                .font(.headline.weight(.semibold))
                .foregroundStyle(OnePeoplePalette.teal)
        }
        .padding(.horizontal, 18)
        .frame(height: 64)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 14, y: 8)
    }
}

private struct StatSquareCard: View {
    let value: String
    let unit: String
    let title: String

    var body: some View {
        VStack(spacing: 10) {
            Text(value)
                .font(.system(size: 44, weight: .bold))
                .minimumScaleFactor(0.8)
            Text(unit)
                .font(.headline.weight(.medium))
                .foregroundStyle(Color(.systemGray3))
            Text(title)
                .font(.title3.weight(.medium))
                .foregroundStyle(.primary.opacity(0.75))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, minHeight: 188)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 14, y: 8)
    }
}

private struct SelfieAuditBanner: View {
    let audit: AttendanceSelfieAudit

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(OnePeoplePalette.softMint)
                Image(systemName: "person.crop.square.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(OnePeoplePalette.teal)
            }
            .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 4) {
                Text(audit.mode.selfieTitle)
                    .font(.system(size: 15, weight: .bold))
                Text(audit.capturedAtText)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }
}

private struct AttendanceTimelineCard: View {
    let entry: AttendanceTimelineEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(width: 32)

                Text("Check In")
                    .font(.system(size: 22, weight: .semibold))

                Spacer()

                Text(entry.checkInText)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 22) {
                TimelineStep(title: entry.location, subtitle: "")
                TimelineStep(title: "Check Out", subtitle: entry.location, trailing: entry.checkOutText)
            }
            .padding(.leading, 6)
        }
        .padding(20)
    }
}

private struct TimelineStep: View {
    let title: String
    let subtitle: String
    var trailing: String = ""

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                Circle()
                    .fill(OnePeoplePalette.teal)
                    .frame(width: 34, height: 34)
                    .overlay {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundStyle(.white)
                    }

                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 2, height: 50)
                    .opacity(trailing.isEmpty ? 1 : 0)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.primary.opacity(0.8))
                }
            }

            Spacer()

            if !trailing.isEmpty {
                Text(trailing)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct ApprovalHistoryCard: View {
    let item: ApprovalItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(item.title)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Text(item.status.rawValue)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(item.status == .approved ? OnePeoplePalette.teal : Color.red)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background((item.status == .approved ? OnePeoplePalette.softMint : Color.red.opacity(0.1)))
                    .clipShape(Capsule())
            }

            Text(item.requester)
                .font(.system(size: 16, weight: .semibold))
            Text(item.detail)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
            Text(item.submittedAt)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

private struct AssetCard: View {
    let item: AssetRecord

    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#FFF1EB"))
                Image(systemName: item.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(Color(hex: item.tintHex))
            }
            .frame(width: 76, height: 76)

            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.system(size: 19, weight: .bold))
                Text(item.subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(OnePeoplePalette.teal)
            }

            Spacer()

            Image(systemName: "chevron.down.circle.fill")
                .font(.system(size: 30))
                .foregroundStyle(OnePeoplePalette.blue)
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

private struct TransferCard: View {
    let item: AssetTransferRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.title)
                .font(.system(size: 18, weight: .bold))
            Text(item.detail)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
            Text(item.dateText)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(OnePeoplePalette.teal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

private struct LeaveRequestCard: View {
    let item: LeaveRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.title)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Text(item.status.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            Text(item.reason)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)

            HStack {
                Label(item.startDateText, systemImage: "calendar")
                Spacer()
                Text(item.durationText)
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 5)
    }

    private var statusColor: Color {
        switch item.status {
        case .approved:
            return OnePeoplePalette.teal
        case .pending:
            return Color(hex: "#D97706")
        case .rejected:
            return .red
        }
    }
}

struct MenuSelector: View {
    let value: String
    let items: [String]
    let onSelect: (String) -> Void

    var body: some View {
        Menu {
            ForEach(items, id: \.self) { item in
                Button(item) {
                    onSelect(item)
                }
            }
        } label: {
            HStack {
                Text(value)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.black)
            }
            .padding(.horizontal, 20)
            .frame(height: 62)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.systemGray4), lineWidth: 1.5)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct MonthSelector: View {
    let title: String

    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color(.systemGray))

            Spacer()

            Text(title)
                .font(.title2.weight(.medium))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color(.systemGray))
        }
        .padding(.horizontal, 20)
        .frame(height: 72)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 1.5)
        }
    }
}

private struct MonthGridCard: View {
    let markers: [CalendarDayMarker]

    private let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color(hex: "#4D92E6"))
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .overlay {
                            Rectangle().stroke(Color(.systemGray5), lineWidth: 0.5)
                        }
                }

                ForEach(monthCells) { cell in
                    calendarCell(cell)
                }
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 1)
        }
    }

    private var markerMap: [Int: CalendarDayState] {
        Dictionary(uniqueKeysWithValues: markers.map { ($0.day, $0.state) })
    }

    private var monthCells: [MonthCell] {
        var items = (0..<6).map { MonthCell(id: "empty-\($0)", day: nil, state: nil) }
        items += (1...31).map { day in
            MonthCell(id: "day-\(day)", day: day, state: markerMap[day])
        }
        return items
    }

    @ViewBuilder
    private func calendarCell(_ cell: MonthCell) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .overlay {
                    Rectangle().stroke(Color(.systemGray5), lineWidth: 0.5)
                }

            if let day = cell.day {
                if let state = cell.state {
                    Text("\(day)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(fillColor(for: state))
                } else {
                    Text("\(day)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.black)
                }
            }
        }
        .frame(height: 64)
    }

    private func fillColor(for state: CalendarDayState) -> Color {
        switch state {
        case .present:
            return Color(hex: "#39AD6F")
        case .off:
            return Color(hex: "#8492A6")
        case .missing:
            return .red
        }
    }

    private struct MonthCell: Identifiable {
        let id: String
        let day: Int?
        let state: CalendarDayState?
    }
}

private struct LegendSection: View {
    let items: [(String, Color, Bool)]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Keterangan")
                .font(.system(size: 22, weight: .bold))
            Divider()
            ForEach(Array(items.enumerated()), id: \.offset) { element in
                let item = element.element
                HStack(spacing: 14) {
                    Rectangle()
                        .fill(item.1)
                        .frame(width: 36, height: 36)
                        .overlay {
                            Rectangle()
                                .stroke(Color.black.opacity(item.2 ? 1 : 0), lineWidth: 1.5)
                        }
                    Text(item.0)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct AttendanceTableCard: View {
    let rows: [AttendanceReportRow]

    private let dayWidth: CGFloat = 28
    private let timeWidth: CGFloat = 76
    private let metricWidth: CGFloat = 28
    private let rowSpacing: CGFloat = 8

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: rowSpacing) {
                Text("Tgl")
                    .frame(width: dayWidth, alignment: .leading)
                Text("In")
                    .frame(width: timeWidth)
                Text("Out")
                    .frame(width: timeWidth)
                Text("OT")
                    .frame(width: metricWidth)
                Text("DT")
                    .frame(width: metricWidth)
                Text("PC")
                    .frame(width: metricWidth)
            }
            .font(.system(size: 17, weight: .bold))
            .padding(.horizontal, 18)
            .frame(height: 68)
            .background(Color(.systemGray6))

            VStack(spacing: 14) {
                ForEach(rows) { row in
                    HStack(spacing: rowSpacing) {
                        Text(row.dayLabel)
                            .frame(width: dayWidth, alignment: .leading)

                        if row.isRosterOff {
                            Text(row.checkIn)
                                .frame(width: timeWidth * 2 + rowSpacing, alignment: .leading)
                            Text(row.overtime)
                                .frame(width: metricWidth)
                            Text(row.dt)
                                .frame(width: metricWidth)
                            Text(row.pc)
                                .frame(width: metricWidth)
                        } else {
                            Text(row.checkIn)
                                .frame(width: timeWidth)
                            Text(row.checkOut)
                                .frame(width: timeWidth)
                            Text(row.overtime)
                                .frame(width: metricWidth)
                            Text(row.dt)
                                .frame(width: metricWidth)
                            Text(row.pc)
                                .frame(width: metricWidth)
                        }
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(row.isRosterOff ? Color.primary : Color.white)
                    .padding(.horizontal, 18)
                    .frame(height: 76)
                    .background(row.isRosterOff ? Color(.systemGray6) : OnePeoplePalette.teal)
                }
            }
            .padding(12)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct PayrollSectionCard: View {
    let section: PayrollSection

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: section.icon)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Color(hex: section.tintHex))
                Text(section.title)
                    .font(.system(size: 22, weight: .bold))
            }

            Divider()

            VStack(spacing: 10) {
                ForEach(section.lines) { line in
                    HStack(alignment: .top) {
                        Text(line.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(line.amount)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            HStack(alignment: .top) {
                Text(section.totalLabel)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(hex: section.totalTintHex))
                Spacer()
                Text(section.totalAmount)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(hex: section.totalTintHex))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SelfieCaptureSheet: View {
    @Environment(\.dismiss) private var dismiss

    let mode: AttendanceActionMode
    let onConfirm: () -> Void

    @State private var previewImage: UIImage?
    @State private var isShowingCamera = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 22) {
                Text(mode.selfieTitle)
                    .font(.system(size: 26, weight: .heavy))
                    .multilineTextAlignment(.center)

                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color(.systemGray6))

                    if let previewImage {
                        Image(uiImage: previewImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    } else {
                        VStack(spacing: 14) {
                            Image(systemName: "person.crop.square.fill")
                                .font(.system(size: 92))
                                .foregroundStyle(OnePeoplePalette.teal)
                            Text("Selfie wajah diperlukan untuk validasi absensi.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .frame(height: 320)
                .clipped()

                VStack(spacing: 12) {
                    Button {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            isShowingCamera = true
                        } else {
                            previewImage = UIImage(systemName: "person.crop.square.fill")
                        }
                    } label: {
                        Text(UIImagePickerController.isSourceTypeAvailable(.camera) ? "Buka Kamera Depan" : "Ambil Selfie Simulasi")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color(hex: "#15A236"))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }

                    if previewImage != nil {
                        Button {
                            onConfirm()
                            dismiss()
                        } label: {
                            Text("Gunakan Selfie Ini")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(Color(hex: "#15A236"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color(hex: "#15A236"), lineWidth: 2)
                                }
                        }
                    }
                }

                Spacer()
            }
            .padding(20)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Tutup") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $isShowingCamera) {
                FrontCameraPicker(image: $previewImage)
            }
        }
    }
}

private struct FrontCameraPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: FrontCameraPicker

        init(parent: FrontCameraPicker) {
            self.parent = parent
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            parent.dismiss()
        }
    }
}
