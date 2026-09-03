import Foundation

enum Digit: Equatable, Sendable, CustomStringConvertible {
    case number(Int)
    case period

    var description: String {
        switch self {
        case let .number(value):
            String(value)
        case .period:
            "."
        }
    }
}

extension Digit {
    init?(_ character: Character) {
        switch character {
        case ".":
            self = .period
        case ("0"..."9"):
            self = .number(Int(String(describing: character))!)
        default:
            return nil
        }
    }
}

extension [Digit] {
    init(decimalValue: Decimal) {
        self = String(describing: decimalValue).compactMap(Digit.init)
        // A value without any digit representation, such as NaN, falls back to zero
        // so that an operand never holds an empty digit sequence.
        if isEmpty {
            self = [.number(0)]
        }
    }
}
