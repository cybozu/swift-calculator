import SwiftUI

/// A view that provides a calculator that supports the four basic arithmetic operations and remainder (modulo) calculations.
public struct Calculator: View {
    @Environment(\.calculatorStyle) private var _calculatorStyle
    @State private var state = CalculatorState()
    @State private var isSelfUpdate = false

    @Binding var value: Decimal?

    /// Creates new calculator view.
    /// - Parameters:
    ///   - value: The decimal value settled by the calculator.
    ///     It is nil while a formula is being edited or when the calculation failed.
    ///     Assigning a value resets the calculator to it, and assigning nil over
    ///     a settled value clears the calculator.
    public init(value: Binding<Decimal?>) {
        _value = value
        state.value = value.wrappedValue
    }

    /// The content and behavior of the calculator view.
    public var body: some View {
        AnyView(_calculatorStyle.makeBody(configuration: .init(
            value: state.expression,
            rows: state.rows,
            trigger: { state.onTap($0) }
        )))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("calculator")
        .onChange(of: value) { _, newValue in
            guard !isSelfUpdate else {
                isSelfUpdate = false
                return
            }
            // An assigned nil clears the calculator even while the unsettled
            // state already reports nil through the binding.
            guard newValue == nil || state.value != newValue else { return }
            state.value = newValue
        }
        .onChange(of: state.value, initial: true) { _, newValue in
            guard value != newValue else { return }
            isSelfUpdate = true
            value = newValue
        }
    }
}
