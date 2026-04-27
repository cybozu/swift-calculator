import SwiftUI

/// The properties of a calculator view.
public struct CalculatorStyleConfiguration {
    /// The string value representing an expression or calculation result.
    public var value: String
    /// An array of row information.
    public var rows: [Row]
    /// The closure to send the role of each calculator button to the calculation engine.
    public var trigger: (Role) -> Void
}

/// A type that applies standard interaction behavior and a custom appearance to all calculator views within a view hierarchy.
///
/// To configure the current calculator view style for a view hierarchy, use the ``SwiftUI/View/calculatorStyle(_:)`` modifier.
/// Specify a style that conforms to CalculatorStyle when creating a calculator view that uses the standard its interaction behavior defined for each platform.
public protocol CalculatorStyle: Sendable {
    /// A view that represents the body of a calculator view.
    associatedtype Body: View

    /// Creates a view that represents the body of a calculator view.
    /// - Parameters:
    ///   - configuration: The properties of the calculator view.
    ///
    /// The system calls this method for each ``Calculator`` instance in a view hierarchy where this style is the current calculator view style.
    @MainActor func makeBody(configuration: Configuration) -> Body

    /// The properties of a calculator view.
    typealias Configuration = CalculatorStyleConfiguration
}

/// A calculator view style that displays the classic calculator interface.
///
/// This style provides a standard calculator interface that supports the four basic arithmetic operations and remainder (modulo) calculations.
/// You can also use ``CalculatorStyle/classic`` to construct this style.
public struct ClassicCalculatorStyle: CalculatorStyle {
    private var buttonFontSize: Double
    private var buttonBorderShape: ButtonBorderShape

    /// Creates a classic calculator view style.
    /// - Parameters:
    ///   - buttonFontSize: The font size for the buttons.
    ///   - buttonBorderShape: The border shape for buttons.
    public init(buttonFontSize: Double = 20, buttonBorderShape: ButtonBorderShape = .capsule) {
        self.buttonFontSize = buttonFontSize
        self.buttonBorderShape = buttonBorderShape
    }

    public func makeBody(configuration: ClassicCalculatorStyle.Configuration) -> some View {
        ClassicCalculatorView(
            configuration: configuration,
            buttonFontSize: buttonFontSize,
            buttonBorderShape: buttonBorderShape
        )
    }
}

public extension CalculatorStyle where Self == ClassicCalculatorStyle {
    /// A calculator view style that displays the classic calculator interface.
    /// - Parameters:
    ///   - buttonFontSize: The font size for the buttons.
    ///   - buttonBorderShape: The border shape for buttons.
    ///
    /// This style provides a standard calculator interface that supports the four basic arithmetic operations and remainder (modulo) calculations.
    /// To apply this style to a calculator view, use the ``SwiftUI/View/calculatorStyle(_:)`` modifier.
    static func classic(
        buttonFontSize: Double = 20,
        buttonBorderShape: ButtonBorderShape = .capsule
    ) -> Self {
        ClassicCalculatorStyle(
            buttonFontSize: buttonFontSize,
            buttonBorderShape: buttonBorderShape
        )
    }
}

/// The default calculator view style.
///
/// You can also use ``CalculatorStyle/automatic`` to construct this style.
public struct DefaultCalculatorStyle: CalculatorStyle {
    /// Creates a default calculator view style.
    public init() {}

    public func makeBody(configuration: DefaultCalculatorStyle.Configuration) -> some View {
        ClassicCalculatorStyle().makeBody(configuration: configuration)
    }
}

public extension CalculatorStyle where Self == DefaultCalculatorStyle {
    /// The default calculator style.
    ///
    /// You can override a calculator view's style.
    /// To apply the default style to a calculator view, use the ``SwiftUI/View/calculatorStyle(_:)`` modifier.
    static var automatic: Self { Self() }
}
