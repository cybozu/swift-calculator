import SwiftUI

struct WidthPreferenceKey: PreferenceKey {
    static let defaultValue = Double.zero

    static func reduce(value: inout Double, nextValue: () -> Double) {
        _ = nextValue()
    }
}
