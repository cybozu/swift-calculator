import Foundation

/// An error that occurs during the calculation.
public enum CalculationError: LocalizedError, Equatable {
    /// The tokens do not form a calculable formula.
    case invalidFormula(InvalidFormulaReason)
    /// The calculation result is not defined, such as a division by zero.
    case undefined

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        let localizationValue: String.LocalizationValue = switch self {
        case .invalidFormula:
            "invalidFormula"
        case .undefined:
            "undefined"
        }
        return String(localized: localizationValue, bundle: .module)
    }
}

/// The grammar rule that made the formula invalid.
public enum InvalidFormulaReason: Equatable, Sendable {
    /// The tokens are empty or do not form a foldable formula.
    case incompleteFormula
    /// An operand follows a calculated result.
    case operandAfterResult
    /// An equal sign has no formula before it.
    case equalWithoutFormula
}
