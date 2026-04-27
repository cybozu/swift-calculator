import Foundation

enum CalculatorError: LocalizedError {
    case invalidFormula
    case undefined

    var errorDescription: String? {
        let localizationValue: String.LocalizationValue = switch self {
        case .invalidFormula:
            "invalidFormula"
        case .undefined:
            "undefined"
        }
        return String(localized: localizationValue, bundle: .module)
    }
}
