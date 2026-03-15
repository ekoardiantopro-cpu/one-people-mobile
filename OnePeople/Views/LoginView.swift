import SwiftUI
import UIKit

struct LoginView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @FocusState private var focusedField: LoginField?

    @State private var username = ""
    @State private var password = ""
    @State private var serverDraft = ""
    @State private var isServerExpanded = true

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("One People")
                            .font(.system(size: 38, weight: .heavy))
                            .foregroundStyle(OnePeoplePalette.ink)

                        Text("Masuk ke akun Anda untuk mengakses attendance, approval, payroll, dan layanan HR internal.")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(OnePeoplePalette.ink.opacity(0.72))
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    loginCard

                    if appModel.hasConfiguredServer {
                        serverSummaryCard
                    }
                }
                .onePeopleContentWidth(460)
                .padding(.horizontal, 20)
                .padding(.vertical, 28)
                .frame(minHeight: geometry.size.height, alignment: .center)
            }
            .background(OnePeopleFlowingBackdrop().ignoresSafeArea())
        }
        .onAppear {
            if username.isEmpty {
                username = appModel.lastUsername
            }

            if serverDraft.isEmpty {
                serverDraft = appModel.serverURL
            }

            isServerExpanded = false
        }
    }

    private var loginCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Login")
                        .font(.system(size: 26, weight: .bold))
                    Text("Atur server dulu, lalu masuk dengan username dan password.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(OnePeoplePalette.blue)
            }

            DisclosureGroup(isExpanded: $isServerExpanded) {
                ServerSettingsForm(
                    serverDraft: $serverDraft,
                    saveAction: saveServer,
                    focusedField: $focusedField
                )
                .padding(.top, 10)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pengaturan Server")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(OnePeoplePalette.teal)

                        Text(appModel.hasConfiguredServer ? "Tap untuk ubah server aktif" : "Tap untuk set server sebelum login")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(appModel.hasConfiguredServer ? "Tersimpan" : "Belum diset")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(appModel.hasConfiguredServer ? OnePeoplePalette.teal : Color.orange)
                }
                .padding(.vertical, 2)
            }
            .tint(OnePeoplePalette.teal)

            Divider()
                .padding(.vertical, 4)

            VStack(spacing: 12) {
                AuthFieldRow(
                    title: "Username",
                    icon: "person.crop.circle",
                    text: $username,
                    prompt: "Masukkan username",
                    contentType: .username,
                    keyboardType: .default,
                    focusedField: $focusedField,
                    field: .username
                )

                AuthSecureFieldRow(
                    title: "Password",
                    icon: "key.horizontal.fill",
                    text: $password,
                    prompt: "Masukkan password",
                    focusedField: $focusedField,
                    field: .password
                )
            }
            .disabled(!appModel.hasConfiguredServer)
            .opacity(appModel.hasConfiguredServer ? 1 : 0.5)

            if let message = appModel.authErrorMessage {
                Text(message)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.red)
            } else if !appModel.hasConfiguredServer {
                Text("Simpan server URL terlebih dahulu untuk mengaktifkan login.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(OnePeoplePalette.ink.opacity(0.62))
            }

            Button {
                submitLogin()
            } label: {
                Text("Masuk")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(canSubmitLogin ? OnePeoplePalette.accentGradient : LinearGradient(colors: [Color(.systemGray4), Color(.systemGray4)], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(!canSubmitLogin)
        }
        .padding(22)
        .background(Color.white.opacity(0.94))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: OnePeoplePalette.blue.opacity(0.1), radius: 20, y: 10)
    }

    private var serverSummaryCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(OnePeoplePalette.softMint)
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(OnePeoplePalette.teal)
            }
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text("Server Aktif")
                    .font(.system(size: 15, weight: .bold))
                Text(appModel.serverURL)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }

            Spacer()
        }
        .padding(18)
        .background(Color.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: OnePeoplePalette.blue.opacity(0.08), radius: 14, y: 8)
    }

    private var canSubmitLogin: Bool {
        appModel.hasConfiguredServer &&
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func saveServer() {
        if appModel.updateServerURL(serverDraft) {
            serverDraft = appModel.serverURL
            isServerExpanded = false
            focusedField = .username
        }
    }

    private func submitLogin() {
        if appModel.login(username: username, password: password) {
            password = ""
            focusedField = nil
        }
    }
}

struct ServerSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @FocusState private var focusedField: LoginField?

    @State private var serverDraft = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pengaturan Server")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(OnePeoplePalette.ink)

                        Text("Atur alamat server One People yang akan dipakai aplikasi sebelum proses login atau sinkronisasi data.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 16) {
                        ServerSettingsForm(
                            serverDraft: $serverDraft,
                            saveAction: saveAndDismiss,
                            focusedField: $focusedField
                        )

                        if appModel.hasConfiguredServer {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 22))
                                    .foregroundStyle(OnePeoplePalette.teal)

                                Text(appModel.serverURL)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(16)
                            .background(OnePeoplePalette.softMint)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                    }
                    .padding(22)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .shadow(color: OnePeoplePalette.blue.opacity(0.08), radius: 18, y: 10)
                }
                .onePeopleContentWidth(520)
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .background(OnePeopleFlowingBackdrop().ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Tutup") {
                        dismiss()
                    }
                    .foregroundStyle(OnePeoplePalette.teal)
                }
            }
        }
        .onAppear {
            appModel.clearAuthErrorMessage()
            serverDraft = appModel.serverURL
        }
    }

    private func saveAndDismiss() {
        if appModel.updateServerURL(serverDraft) {
            dismiss()
        }
    }
}

private enum LoginField: Hashable {
    case server
    case username
    case password
}

private struct ServerSettingsForm: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel

    @Binding var serverDraft: String
    let saveAction: () -> Void
    let focusedField: FocusState<LoginField?>.Binding

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AuthFieldRow(
                title: "Server URL",
                icon: "server.rack",
                text: $serverDraft,
                prompt: "https://hcm.ekozer.com",
                contentType: .URL,
                keyboardType: .URL,
                focusedField: focusedField,
                field: .server
            )

            if let message = appModel.authErrorMessage {
                Text(message)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.red)
            }

            Button {
                saveAction()
            } label: {
                Text("Simpan Server")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(OnePeoplePalette.accentGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }
}

private struct AuthFieldRow: View {
    let title: String
    let icon: String
    @Binding var text: String
    let prompt: String
    let contentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let focusedField: FocusState<LoginField?>.Binding
    let field: LoginField

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(OnePeoplePalette.ink.opacity(0.8))

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(OnePeoplePalette.teal)
                    .frame(width: 22)

                TextField(prompt, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(contentType)
                    .keyboardType(keyboardType)
                    .submitLabel(.next)
                    .focused(focusedField, equals: field)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(OnePeoplePalette.softSurface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.9), lineWidth: 1)
            }
        }
    }
}

private struct AuthSecureFieldRow: View {
    let title: String
    let icon: String
    @Binding var text: String
    let prompt: String
    let focusedField: FocusState<LoginField?>.Binding
    let field: LoginField

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(OnePeoplePalette.ink.opacity(0.8))

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(OnePeoplePalette.teal)
                    .frame(width: 22)

                SecureField(prompt, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.password)
                    .submitLabel(.go)
                    .focused(focusedField, equals: field)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(OnePeoplePalette.softSurface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.9), lineWidth: 1)
            }
        }
    }
}
