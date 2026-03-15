import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject private var appModel: OnePeopleAppModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Pesan")
                    .font(.largeTitle.weight(.bold))
                    .onePeopleContentWidth()
                    .padding(.horizontal, 20)
                    .padding(.top, 18)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(appModel.messages) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(item.sender)
                                        .font(.headline)

                                    Spacer()

                                    Text(item.time)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Text(item.subject)
                                    .font(.title3.weight(.semibold))

                                Text(item.preview)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(18)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
                        }
                    }
                    .onePeopleContentWidth()
                    .padding(20)
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}
