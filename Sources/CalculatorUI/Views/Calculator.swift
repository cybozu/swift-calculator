import SwiftUI

/// A view that provides a calculator that supports the four basic arithmetic operations and remainder (modulo) calculations.
public struct Calculator: View {
    @Environment(\.calculatorStyle) private var _calculatorStyle
    @State private var state = CalculatorState()

    @Binding var value: String

    /// Creates new calculator view.
    /// - Parameters:
    ///   - value: The string value representing an expression or calculation result.
    public init(value: Binding<String>) {
        _value = value
        state.setValue(value.wrappedValue)
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
            guard state.expression != newValue else { return }
            state.setValue(newValue)
        }
        .onChange(of: state.expression, initial: true) { _, newValue in
            guard value != newValue else { return }
            value = newValue
        }
        .onChange(of: state.isEditingOperand, initial: true) { _, _ in
            state.toggleClearRole()
        }
    }
}
