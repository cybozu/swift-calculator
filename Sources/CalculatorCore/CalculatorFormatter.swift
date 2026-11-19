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
            let result = try tokens.loneValue != nil ? tokens : tokens.calculated()
            return result.map(String.init(describing:)).joined()
        } catch {
            let calculationError = error as? CalculationError ?? .invalidFormula(.incompleteFormula)
            return calculationError.localizedDescription
        }
    }

    /// Returns a string that represents the given tokens as a formula.
    /// A formula closed by an equal sign is represented by its result,
    /// so `1÷3=×3` is formatted as `0.333…×3`.
    public func expression(from tokens: [Token]) -> String {
        guard !tokens.isEmpty else {
            return "0"
        }
        var displayed = tokens[...]
        var prefix = [Token]()
        if let index = tokens.lastIndex(of: .operator(.equal)),
           let result = try? Array(tokens[...index]).calculated() {
            prefix = result
            displayed = tokens[(index + 1)...]
        }
        return (prefix + displayed).map(String.init(describing:)).joined()
    }
}
