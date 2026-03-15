import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @State private var selectedTab = 0
    @State private var previousTab = 0

    var body: some View {
        if !appModel.isAuthenticated && !OnePeopleLaunchOptions.skipLogin {
            LoginView()
        } else if let initialFeature = OnePeopleLaunchOptions.initialFeature {
            NavigationStack {
                OnePeopleFeatureScreen(feature: initialFeature)
            }
        } else {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .tabItem {
                        Label("Beranda", systemImage: "house.fill")
                    }

                SearchView()
                    .tag(1)
                    .tabItem {
                        Label("Akun", systemImage: "person.circle.fill")
                    }

                LibraryView()
                    .tag(2)
                    .tabItem {
                        Label("Pengaturan", systemImage: "gearshape.fill")
                    }

                NowPlayingView()
                    .tag(3)
                    .tabItem {
                        Label("Pesan", systemImage: "bubble.left.and.bubble.right.fill")
                    }

                LogoutView()
                    .tag(4)
                    .tabItem {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
            }
            .tint(OnePeoplePalette.teal)
            .onAppear {
                if let initialTabIndex = OnePeopleLaunchOptions.initialTabIndex {
                    selectedTab = initialTabIndex
                    previousTab = initialTabIndex
                }
            }
            .onChange(of: selectedTab) { newValue in
                guard appModel.isAuthenticated else { return }

                if newValue == 4 {
                    selectedTab = previousTab
                    appModel.logout()
                } else {
                    previousTab = newValue
                }
            }
            .onChange(of: appModel.isAuthenticated) { isAuthenticated in
                if !isAuthenticated {
                    selectedTab = 0
                    previousTab = 0
                }
            }
        }
    }
}

private struct LogoutView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 42))
                    .foregroundStyle(OnePeoplePalette.teal)

                Text("Log Out")
                    .font(.largeTitle.bold())

                Text("Tab ini disiapkan sebagai placeholder aksi keluar, mengikuti referensi navigasi aplikasi.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                Button("Keluar Sekarang") {
                    appModel.logout()
                }
                    .buttonStyle(.borderedProminent)
                    .tint(OnePeoplePalette.teal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
        }
    }
}
