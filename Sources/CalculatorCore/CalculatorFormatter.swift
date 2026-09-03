import Foundation

/// A formatter that converts calculation tokens into their textual representations.
public struct CalculatorFormatter: Sendable {
    /// Creates a new calculator formatter.
    public init() {}

    /// Returns a string containing the calculated result of the given tokens,
    /// or a localized error description when the calculation fails.
    /// Empty tokens are formatted as "0".
    public func string(from tokens: [Token]) -> String {
        guard !tokens.isEmpty else {
            return "0"
        }
        do {
            let result = try tokens.isSettledValue ? tokens : tokens.calculated()
            return result.map(String.init(describing:)).joined()
        } catch {
            let calculationError = error as? CalculationError ?? .invalidFormula(.incompleteFormula)
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
