import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @State private var isShowingServerSheet = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(currentTime())
                        .font(.title3.weight(.semibold))
                        .padding(.top, 18)

                    Text("Pengaturan")
                        .font(.largeTitle.weight(.bold))
                        .padding(.top, 14)

                    Divider()
                        .padding(.top, 20)
                }
                .onePeopleContentWidth()
                .padding(.horizontal, 20)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(appModel.settingsItems) { item in
                            settingsRow(item)
                            Divider()
                                .padding(.leading, 20)
                        }
                    }
                    .onePeopleContentWidth()
                    .padding(.top, 18)
                    .padding(.horizontal, 20)
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .sheet(isPresented: $isShowingServerSheet) {
                ServerSettingsSheet()
                    .environmentObject(appModel)
            }
            .onAppear {
                if OnePeopleLaunchOptions.presentsServerSettingsSheet {
                    isShowingServerSheet = true
                }
            }
        }
    }

    @ViewBuilder
    private func settingsRow(_ item: SettingsItem) -> some View {
        if item.id == "set2" {
            Button {
                appModel.clearAuthErrorMessage()
                isShowingServerSheet = true
            } label: {
                settingsRowContent(item)
            }
            .buttonStyle(.plain)
        } else {
            settingsRowContent(item)
        }
    }

    private func settingsRowContent(_ item: SettingsItem) -> some View {
        HStack(spacing: 18) {
            Image(systemName: item.icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(OnePeoplePalette.teal)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.title3.weight(.medium))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                if item.id == "set2", appModel.hasConfiguredServer {
                    Text(appModel.serverURL)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }

            Spacer()

            if item.showsToggle {
                Toggle("", isOn: $appModel.biometricEnabled)
                    .labelsHidden()
                    .toggleStyle(.plainSquare)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }

    private func currentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return formatter.string(from: Date())
    }
}

private struct PlainSwitchToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
    }
}

private extension ToggleStyle where Self == PlainSwitchToggleStyle {
    static var plainSquare: PlainSwitchToggleStyle { PlainSwitchToggleStyle() }
}
