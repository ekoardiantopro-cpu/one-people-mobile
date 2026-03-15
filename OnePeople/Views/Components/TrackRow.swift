import SwiftUI

struct InfoRow: View {
    let title: String
    let subtitle: String
    let detail: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(tint.opacity(0.16))

                Image(systemName: icon)
                    .foregroundStyle(tint)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary.opacity(0.85))
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
