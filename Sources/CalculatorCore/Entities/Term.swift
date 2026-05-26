import Foundation

// TODO: Operandにリネーム
public struct Term: Equatable, CustomStringConvertible {
    var digits: [Digit]

    public var description: String {
        digits.map(String.init(describing:)).joined()
    }

    var decimalValue: Decimal? {
        guard digits.filter({ $0 == .period }).count <= 1 else {
            return nil
        }
        guard digits != [.period] else {
            return nil
        }
        return Decimal(string: description)
    }
}
