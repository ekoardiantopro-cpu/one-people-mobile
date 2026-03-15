import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var isShowingAllMenus = false
    @State private var navigationPath: [OnePeopleFeature] = []
    @State private var selfieMode: AttendanceActionMode?

    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                let metrics = layoutMetrics(for: geometry.size.width)

                ScrollView {
                    VStack(spacing: 0) {
                        topHero(metrics: metrics)

                        VStack(alignment: .leading, spacing: 22) {
                            attendancePanel
                            shortcutSection
                            bannerCard
                            announcementsSection
                        }
                        .onePeopleContentWidth(metrics.contentWidth)
                        .padding(.horizontal, 20)
                        .padding(.top, -18)
                        .padding(.bottom, 28)
                    }
                }
                .background(Color(.systemBackground).ignoresSafeArea())
            }
            .navigationDestination(for: OnePeopleFeature.self) { feature in
                OnePeopleFeatureScreen(feature: feature)
            }
            .sheet(isPresented: $isShowingAllMenus) {
                allMenusSheet
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(item: $selfieMode) { mode in
                SelfieCaptureSheet(mode: mode) {
                    appModel.completeAttendanceAction(mode: mode)
                }
            }
            .onAppear {
                guard navigationPath.isEmpty, let launchFeature = OnePeopleLaunchOptions.initialFeature else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    navigationPath = [launchFeature]
                }
            }
        }
    }

    private func topHero(metrics: HomeLayoutMetrics) -> some View {
        ZStack(alignment: .topLeading) {
            OnePeopleFlowingBackdrop()
                .frame(height: metrics.heroHeight)

            HStack(alignment: .top, spacing: metrics.heroSpacing) {
                VStack(alignment: .leading, spacing: 14) {
                    Text(greetingTime())
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(OnePeoplePalette.ink)
                        .padding(.top, metrics.heroTopPadding)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Selamat Pagi !")
                            .font(.title3)
                            .foregroundStyle(OnePeoplePalette.ink.opacity(0.7))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)

                        Text(appModel.profile.fullName)
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(OnePeoplePalette.ink)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)

                        Text("\(appModel.profile.role) - \(appModel.profile.employeeID)")
                            .font(.subheadline)
                            .foregroundStyle(OnePeoplePalette.ink.opacity(0.76))
                            .lineLimit(2)
                            .minimumScaleFactor(0.85)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                avatarBadge(metrics: metrics)
                    .padding(.top, metrics.avatarTopInset)
            }
            .padding(.horizontal, 20)
        }
    }

    private func avatarBadge(metrics: HomeLayoutMetrics) -> some View {
        ZStack {
            Circle()
                .fill(Color.white)

            Circle()
                .fill(Color.gray.opacity(0.3))
                .padding(6)

            Image(systemName: "person.fill")
                .font(.system(size: metrics.avatarIconSize))
                .foregroundStyle(.gray.opacity(0.6))
        }
        .frame(width: metrics.avatarSize, height: metrics.avatarSize)
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
    }

    private var attendancePanel: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Label("Check In", systemImage: "arrow.down.left")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text(attendanceMessage())
                    .font(.title3.weight(.medium))
                    .foregroundStyle(isCheckedInToday ? Color.primary : Color.red)

                if let today = appModel.todayAttendance {
                    Text("Masuk \(today.checkIn) • Keluar \(today.checkOut)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()
                .frame(height: 80)

            Button {
                selfieMode = appModel.nextAttendanceAction
            } label: {
                Text(appModel.nextAttendanceAction.buttonTitle)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(minWidth: 128, idealWidth: 150, maxWidth: 170)
                    .frame(height: 60)
                    .background(OnePeoplePalette.accentGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
    }

    private var shortcutSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Akses Cepat")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(OnePeoplePalette.ink)

                    Text("Layanan utama dan bantuan HR instan")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(OnePeoplePalette.ink.opacity(0.6))
                }

                Spacer(minLength: 12)

                Button {
                    isShowingAllMenus = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "square.grid.2x2.fill")
                            .font(.system(size: 13, weight: .bold))
                        Text("Semua Menu")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundStyle(OnePeoplePalette.ink)
                    .padding(.horizontal, 14)
                    .frame(height: 38)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Capsule())
                    .overlay {
                        Capsule()
                            .stroke(OnePeoplePalette.ink.opacity(0.08), lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 14) {
                ForEach(mainShortcutItems) { item in
                    Button {
                        if let feature = item.feature {
                            navigationPath.append(feature)
                        }
                    } label: {
                        VStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color(hex: item.backgroundHex))

                                Image(systemName: item.icon)
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(Color(hex: item.tintHex))
                            }
                            .frame(width: 74, height: 74)

                            Text(item.title)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.primary.opacity(0.75))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }

            if let aiShortcutItem {
                aiShortcutCard(aiShortcutItem)
            }
        }
        .frame(maxWidth: 520, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var mainShortcutItems: [HomeShortcut] {
        Array(appModel.homeShortcuts.prefix(3))
    }

    private var aiShortcutItem: HomeShortcut? {
        appModel.homeShortcuts.first(where: { $0.feature == .aiAssistant })
    }

    private func aiShortcutCard(_ item: HomeShortcut) -> some View {
        Button {
            if let feature = item.feature {
                navigationPath.append(feature)
            }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(hex: item.backgroundHex))

                    Image(systemName: item.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(hex: item.tintHex))
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text("AI HR Assistant")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(OnePeoplePalette.ink)
                        .lineLimit(1)

                    Text("Tanya HR dengan cepat")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(OnePeoplePalette.ink.opacity(0.58))
                        .lineLimit(1)
                }

                Spacer(minLength: 8)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(OnePeoplePalette.ink.opacity(0.42))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.94))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(OnePeoplePalette.ink.opacity(0.06), lineWidth: 1)
            }
            .shadow(color: OnePeoplePalette.blue.opacity(0.06), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
    }

    private var bannerCard: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color(red: 0.27, green: 0.83, blue: 0.92), Color(red: 0.14, green: 0.56, blue: 0.78)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 160)
            .overlay(alignment: .leading) {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 16) {
                        Image(systemName: "megaphone.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.white)
                            .rotationEffect(.degrees(-18))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("IMPORTANT")
                                .font(.system(size: 26, weight: .heavy))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Text("ANNOUNCEMENT!")
                                .font(.system(size: 22, weight: .heavy))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 24)

                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "megaphone.fill")
                            .font(.system(size: 42))
                            .foregroundStyle(.white)
                            .rotationEffect(.degrees(-18))
                        Text("IMPORTANT")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundStyle(.white)
                        Text("ANNOUNCEMENT!")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
    }

    private var announcementsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Pengumuman")
                .font(.system(size: 24, weight: .bold))

            if appModel.announcements.isEmpty {
                Text("Pengumuman Kosong")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 12)
            } else {
                ForEach(appModel.announcements) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.title)
                            .font(.headline)
                        Text(item.message)
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Text(item.dateText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)

                    Divider()
                }
            }
        }
    }

    private var allMenusSheet: some View {
        VStack(alignment: .leading, spacing: 22) {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color.gray.opacity(0.35))
                .frame(width: 120, height: 8)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)

            Text("Semua Menu")
                .font(.system(size: 26, weight: .bold))
                .padding(.horizontal, 22)

            ScrollView {
                VStack(spacing: 18) {
                    ForEach(appModel.allMenus) { item in
                        Button {
                            guard let feature = item.feature else { return }
                            isShowingAllMenus = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                navigationPath.append(feature)
                            }
                        } label: {
                            HStack(spacing: 18) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(Color(hex: item.backgroundHex))
                                    Image(systemName: item.icon)
                                        .font(.system(size: 26, weight: .medium))
                                        .foregroundStyle(Color(hex: item.tintHex))
                                }
                                .frame(width: 78, height: 78)

                                Text(item.title)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(.primary.opacity(0.7))

                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .onePeopleContentWidth(640)
                .padding(.horizontal, 22)
                .padding(.top, 6)
            }

            Button("TUTUP") {
                isShowingAllMenus = false
            }
            .font(.system(size: 18, weight: .heavy))
            .foregroundStyle(OnePeoplePalette.teal)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .background(Color.white)
    }

    private var isCheckedInToday: Bool {
        guard let today = appModel.todayAttendance else { return false }
        return today.checkIn != "-"
    }

    private func greetingTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return formatter.string(from: Date())
    }

    private func attendanceMessage() -> String {
        isCheckedInToday ? "Sudah Check In Hari ini" : "Belum Check In Hari ini"
    }
}

private struct HomeLayoutMetrics {
    let heroHeight: CGFloat
    let avatarSize: CGFloat
    let avatarIconSize: CGFloat
    let avatarTopInset: CGFloat
    let contentWidth: CGFloat
    let heroTopPadding: CGFloat
    let heroSpacing: CGFloat
}

private extension HomeView {
    func layoutMetrics(for width: CGFloat) -> HomeLayoutMetrics {
        let isRegular = horizontalSizeClass == .regular || width >= 700
        let isCompact = width < 360

        return HomeLayoutMetrics(
            heroHeight: isRegular ? 332 : (isCompact ? 282 : 300),
            avatarSize: isRegular ? 112 : (isCompact ? 88 : 100),
            avatarIconSize: isRegular ? 48 : (isCompact ? 38 : 44),
            avatarTopInset: isRegular ? 28 : 38,
            contentWidth: isRegular ? 760 : 680,
            heroTopPadding: isCompact ? 12 : 18,
            heroSpacing: isCompact ? 12 : 16
        )
    }
}

extension Color {
    init(hex: String) {
        let raw = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: raw).scanHexInt64(&value)
        self.init(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: 1
        )
    }
}
