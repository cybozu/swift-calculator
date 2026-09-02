import Foundation

/// A formatter that converts calculation tokens into their textual representations.
public struct CalculatorFormatter: Sendable {
    public init() {}

    /// Returns a string containing the calculated result of the given tokens,
    /// or a localized error description when the calculation fails.
    public func string(from tokens: [Token]) -> String {
        do {
            return try tokens.calculated().map(String.init(describing:)).joined()
        } catch {
            let calculationError = error as? CalculationError ?? .invalidFormula
            return calculationError.localizedDescription
        }
    }

    /// Returns a string that represents the given tokens as a formula.
    public func expression(from tokens: [Token]) -> String {
        if tokens.isEmpty {
            "0"
        } else {
            tokens.map(String.init(describing:)).joined()
        }
    }
}
