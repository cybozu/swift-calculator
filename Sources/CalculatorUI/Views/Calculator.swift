import SwiftUI

/// A view that provides a calculator that supports the four basic arithmetic operations and remainder (modulo) calculations.
public struct Calculator: View {
    @Environment(\.calculatorStyle) private var _calculatorStyle
    @State private var engine = CalculatorEngine()

    @Binding var value: String

    /// Creates new calculator view.
    /// - Parameters:
    ///   - value: The string value representing an expression or calculation result.
    public init(value: Binding<String>) {
        _value = value
        engine.setValue(value.wrappedValue)
    }

    /// The content and behavior of the calculator view.
    public var body: some View {
        AnyView(_calculatorStyle.makeBody(configuration: .init(
            value: engine.expression,
            rows: engine.rows,
            trigger: { engine.onTap($0) }
        )))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("calculator")
        .onChange(of: value) { _, newValue in
            guard engine.expression != newValue else { return }
            engine.setValue(newValue)
        }
        .onChange(of: engine.modifiedDate, initial: true) { _, _ in
            let expression = engine.expression
            guard value != expression else { return }
            value = expression
        }
    }
}
