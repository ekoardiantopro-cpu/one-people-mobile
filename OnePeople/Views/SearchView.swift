import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                OnePeopleFlowingBackdrop()
                .frame(height: horizontalSizeClass == .regular ? 280 : 250)
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 26) {
                        profileHeader
                            .padding(.horizontal, 20)
                            .padding(.top, 44)
                            .padding(.bottom, 6)

                        VStack(alignment: .leading, spacing: 0) {
                            Text("Profil Akun")
                                .font(.system(size: 22, weight: .bold))
                                .padding(.horizontal, 20)
                                .padding(.top, 18)
                                .padding(.bottom, 12)

                            Divider()
                                .padding(.horizontal, 20)

                            ForEach(appModel.profileMenus) { item in
                                profileMenuRow(item)
                            }
                        }
                        .onePeopleContentWidth()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    }
                    .onePeopleContentWidth()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 18) {
            avatar
            profileIdentity
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func profileMenuRow(_ item: ProfileMenuItem) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Image(systemName: item.icon)
                    .font(.system(size: 26))
                    .foregroundStyle(OnePeoplePalette.teal)
                    .frame(width: 32)

                Text(item.title)
                    .font(.title3.weight(.medium))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.black)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 22)

            Divider()
                .padding(.leading, 20)
        }
    }

    private var avatar: some View {
        ZStack {
            Circle()
                .fill(.white)
            Circle()
                .fill(Color.gray.opacity(0.3))
                .padding(6)
            Image(systemName: "person.fill")
                .font(.system(size: horizontalSizeClass == .regular ? 46 : 40))
                .foregroundStyle(.gray.opacity(0.6))
        }
        .frame(width: horizontalSizeClass == .regular ? 124 : 112, height: horizontalSizeClass == .regular ? 124 : 112)
    }

    private var profileIdentity: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(appModel.profile.fullName)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(OnePeoplePalette.ink)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text("\(appModel.profile.role) - \(appModel.profile.employeeID)")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(OnePeoplePalette.ink.opacity(0.76))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
    }
}
