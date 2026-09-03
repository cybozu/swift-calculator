import Foundation

/// An error that occurs during the calculation.
public enum CalculationError: LocalizedError {
    /// The tokens do not form a calculable formula.
    case invalidFormula
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
