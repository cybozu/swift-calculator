import SwiftUI

extension View {
    /// Sets the style for calculator view within this view.
    ///
    /// Use this modifier to set a specific style for calculator view instances within a view:
    ///
    /// ```swift
    /// Calculator()
    ///     .calculatorStyle(.classic())
    /// ```
    public func calculatorStyle(_ style: some CalculatorStyle) -> some View {
        environment(\.calculatorStyle, style)
    }
}
