import Foundation

enum Token: Equatable, Sendable, CustomStringConvertible {
    case operand(Operand)
    case `operator`(Operator)

    var description: String {
        switch self {
        case let .operand(value):
            String(describing: value)
        case let .operator(value):
            String(describing: value)
        }
    }

    var isOperand: Bool {
        if case .operand = self {
            true
        } else {
            false
        }
    }
}

extension [Token] {
    init(decimalValue: Decimal) {
        self = if decimalValue.isSignMinus {
            [.operator(.subtraction)]
        } else {
            []
        }
        append(.operand(.init(digits: [Digit](decimalValue: decimalValue.magnitude))))
    }

    mutating func remove(at: Int, count: Int) {
        guard at + count <= self.count else {
            fatalError("Error: out of range")
        }
        for _ in 0 ..< count {
            remove(at: at)
        }
    }

    func signedOperand(before index: Int) -> SignedOperand? {
        guard (0 ..< count).contains(index) else {
            return nil
        }
        guard 0 < index,
              case let .operand(beforeOperand) = self[index - 1],
              let value = beforeOperand.decimalValue else {
            return nil
        }
        guard 1 < index,
              case .operator(.subtraction) = self[index - 2] else {
            return SignedOperand(value: value, cost: 1)
        }
        return SignedOperand(value: -value, cost: 2)
    }

    func signedOperand(after index: Int) -> SignedOperand? {
        guard (0 ..< count).contains(index) else {
            return nil
        }
        if index < count - 1,
           case let .operand(afterOperand) = self[index + 1],
           let value = afterOperand.decimalValue {
            return SignedOperand(value: value, cost: 1)
        }
        guard index < count - 2,
              case .operator(.subtraction) = self[index + 1],
              case let .operand(afterOperand) = self[index + 2],
              let value = afterOperand.decimalValue else {
            return nil
        }
        return SignedOperand(value: -value, cost: 2)
    }

    func calculated() throws -> [Token] {
        guard count >= 3 else {
            throw CalculationError.invalidFormula
        }
        var copy = self

        let operations: [Operation] = [
            .init(
                operator: .modulus,
                needsZeroValidation: true,
                perform: { $0.remainderValue(by: $1) }
            ),
            .init(
                operator: .division,
                needsZeroValidation: true,
                perform: { $0.dividingValue(by: $1) }
            ),
            .init(
                operator: .multiplication,
                needsZeroValidation: false,
                perform: { $0.multiplyingValue(by: $1) }
            ),
            .init(
                operator: .subtraction,
                needsZeroValidation: false,
                perform: { $0.subtractingValue(with: $1) }
            ),
            .init(
                operator: .addition,
                needsZeroValidation: false,
                perform: { $0.addingValue(with: $1) }
            ),
        ]

        for operation in operations {
            while copy.count > 2, let index = copy.firstOperatorIndex(where: { $0 == .operator(operation.operator) }) {
                guard let beforeSignedOperand = copy.signedOperand(before: index),
                      let afterSignedOperand = copy.signedOperand(after: index) else {
                    throw CalculationError.invalidFormula
                }
                if operation.needsZeroValidation {
                    guard !afterSignedOperand.value.isZero else {
                        throw CalculationError.undefined
                    }
                }
                copy.remove(at: index - beforeSignedOperand.cost, count: beforeSignedOperand.cost + 1 + afterSignedOperand.cost)
                copy.insert(
                    contentsOf: [Token](decimalValue: operation.perform(beforeSignedOperand, afterSignedOperand)),
                    at: index - beforeSignedOperand.cost
                )
            }
        }

        if copy.count == 1, case let .operand(value) = copy.first {
            return [.operand(.init(digits: value.digits))]
        } else if copy.count == 2, case .operator(.subtraction) = copy.first, case let .operand(value) = copy.last {
            return [.operator(.subtraction), .operand(.init(digits: value.digits))]
        } else {
            throw CalculationError.undefined
        }
    }
}

extension Array {
    func firstOperatorIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        try dropFirst().map(\.self).firstIndex(where: predicate).map({ $0 + 1 })
    }
}
