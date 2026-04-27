import SwiftUI

extension Color {
    static let background: Color = {
#if os(iOS)
        Color(.secondarySystemBackground)
#elseif os(macOS)
        Color(.controlBackgroundColor)
#endif
    }()
}
