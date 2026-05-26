import Foundation

public enum CalculationError: LocalizedError {
    case invalidFormula
    case undefined

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
