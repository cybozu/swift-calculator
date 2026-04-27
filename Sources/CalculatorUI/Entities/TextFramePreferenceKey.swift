import SwiftUI

struct TextFramePreferenceKey: PreferenceKey {
    static let defaultValue = CGRect.zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        _ = nextValue()
    }
}
