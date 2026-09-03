import Foundation
import Testing

@testable import CalculatorCore

struct TokenTests {
    @Test(arguments: [
        .init(
            decimalValue: 0,
            expectedTokens: [.operand(.init(0))]
        ),
        .init(
            decimalValue: -1,
            expectedTokens: [.operator(.subtraction), .operand(.init(1))]
        ),
        .init(
            decimalValue: 1.2,
            expectedTokens: [.operand(.init(1.2))]
        ),
        .init(
            decimalValue: -1.2,
            expectedTokens: [.operator(.subtraction), .operand(.init(1.2))]
        ),
    ] as [TokensCondition])
    func init_from_decimal(_ condition: TokensCondition) {
        let actual = [Token](decimalValue: condition.decimalValue)
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        .init(
            tokens: [.operand(.init(1)), .operator(.multiplication), .operator(.subtraction), .operand(.init(2))],
            at: 1,
            count: 3,
            expectedTokens: [.operand(.init(1))]
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.multiplication), .operator(.subtraction), .operand(.init(2))],
            at: 2,
            count: 1,
            expectedTokens: [.operand(.init(1)), .operator(.multiplication), .operand(.init(2))]
        ),
    ] as [RemoveCondition])
    func remove(_ condition: RemoveCondition) {
        var actual = condition.tokens
        actual.remove(at: condition.at, count: condition.count)
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        .init(
            tokens: [],
            index: 0,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: [],
            index: 1,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: [],
            index: -1,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: [.operand(.init(1))],
            index: 0,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: [.operator(.subtraction), .operand(.init(1))],
            index: 1,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.addition), .operand(.init(2))],
            index: 1,
            expectedSignedOperand: .init(value: 1, cost: 1)
        ),
        .init(
            tokens: [.operator(.subtraction), .operand(.init(1)), .operator(.addition), .operand(.init(2))],
            index: 2,
            expectedSignedOperand: .init(value: -1, cost: 2)
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.addition), .operand(.init(2)), .operator(.addition), .operand(.init(3))],
            index: 3,
            expectedSignedOperand: .init(value: 2, cost: 1)
        ),
        // The subtraction is a binary operator here, not the sign of 2.
        .init(
            tokens: [.operand(.init(1)), .operator(.subtraction), .operand(.init(2)), .operator(.addition), .operand(.init(3))],
            index: 3,
            expectedSignedOperand: .init(value: 2, cost: 1)
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.multiplication), .operator(.subtraction), .operand(.init(2))],
            index: 2,
            expectedSignedOperand: nil
        ),
    ] as [SignedOperandCondition])
    func signedOperand_before(_ condition: SignedOperandCondition) {
        let actual = condition.tokens.signedOperand(before: condition.index)
        #expect(actual == condition.expectedSignedOperand)
    }

    @Test(arguments: [
        .init(
            tokens: [],
            index: 0,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: [],
            index: 1,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: [],
            index: -1,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: [.operand(.init(1))],
            index: 0,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.subtraction)],
            index: 0,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.addition), .operand(.init(2))],
            index: 1,
            expectedSignedOperand: .init(value: 2, cost: 1)
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.multiplication), .operator(.subtraction), .operand(.init(2))],
            index: 1,
            expectedSignedOperand: .init(value: -2, cost: 2)
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.addition), .operand(.init(2)), .operator(.addition), .operand(.init(3))],
            index: 1,
            expectedSignedOperand: .init(value: 2, cost: 1)
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.multiplication), .operator(.subtraction), .operand(.init(2))],
            index: 0,
            expectedSignedOperand: nil
        ),
    ] as [SignedOperandCondition])
    func signedOperand_after(_ condition: SignedOperandCondition) {
        let actual = condition.tokens.signedOperand(after: condition.index)
        #expect(actual == condition.expectedSignedOperand)
    }

    @Test(arguments: [
        .init(
            tokens: [.operand(.init(1)), .operator(.addition), .operand(.init(1))],
            expectedTokens: [.operand(.init(2))]
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.subtraction), .operand(.init(1))],
            expectedTokens: [.operand(.init(0))]
        ),
        .init(
            tokens: [.operand(.init(2)), .operator(.multiplication), .operand(.init(3))],
            expectedTokens: [.operand(.init(6))]
        ),
        .init(
            tokens: [.operand(.init(6)), .operator(.division), .operand(.init(3))],
            expectedTokens: [.operand(.init(2))]
        ),
        .init(
            tokens: [.operand(.init(3)), .operator(.modulus), .operand(.init(2))],
            expectedTokens: [.operand(.init(1))]
        ),
        .init(
            tokens: [.operand(.init(3.5)), .operator(.modulus), .operand(.init(2))],
            expectedTokens: [.operand(.init(1.5))]
        ),
        .init(
            tokens: [.operator(.subtraction), .operand(.init(3.5)), .operator(.modulus), .operand(.init(2))],
            expectedTokens: [.operand(.init(0.5))]
        ),
        .init(
            tokens: [.operand(.init(3.5)), .operator(.modulus), .operator(.subtraction), .operand(.init(2))],
            expectedTokens: [.operator(.subtraction), .operand(.init(0.5))]
        ),
        .init(
            tokens: [.operator(.subtraction), .operand(.init(3.5)), .operator(.modulus), .operator(.subtraction), .operand(.init(2))],
            expectedTokens: [.operator(.subtraction), .operand(.init(1.5))]
        ),
    ] as [CalculatedCondition])
    func calculated_simple_expression(_ condition: CalculatedCondition) throws {
        let actual = try condition.tokens.calculated()
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        .init(
            tokens: [],
            expectedError: .invalidFormula
        ),
        .init(
            tokens: [.operand(.init(1))],
            expectedError: .invalidFormula
        ),
        .init(
            tokens: [.operator(.subtraction)],
            expectedError: .invalidFormula
        ),
        .init(
            tokens: [.operator(.subtraction), .operand(.init(1))],
            expectedError: .invalidFormula
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.addition)],
            expectedError: .invalidFormula
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.multiplication), .operator(.division)],
            expectedError: .invalidFormula
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.division), .operand(.init(0))],
            expectedError: .undefined
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.modulus), .operand(.init(0))],
            expectedError: .undefined
        ),
    ] as [ErrorCondition])
    func calculated_error(_ condition: ErrorCondition) throws {
        #expect(throws: condition.expectedError) {
            try condition.tokens.calculated()
        }
    }

    @Test(arguments: [
        .init(
            tokens: [.operand(.init(1)), .operator(.addition), .operand(.init(1)), .operator(.addition), .operand(.init(1)), .operator(.addition), .operand(.init(1))],
            expectedTokens: [.operand(.init(4))]
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.subtraction), .operand(.init(1)), .operator(.subtraction), .operand(.init(1)), .operator(.subtraction), .operand(.init(1))],
            expectedTokens: [.operator(.subtraction), .operand(.init(2))]
        ),
        .init(
            tokens: [.operand(.init(2)), .operator(.multiplication), .operand(.init(3)), .operator(.multiplication), .operand(.init(4)), .operator(.multiplication), .operand(.init(5))],
            expectedTokens: [.operand(.init(120))]
        ),
        .init(
            tokens: [.operand(.init(300)), .operator(.division), .operand(.init(10)), .operator(.division), .operand(.init(5)), .operator(.division), .operand(.init(2))],
            expectedTokens: [.operand(.init(3))]
        ),
        .init(
            tokens: [.operand(.init(80)), .operator(.modulus), .operand(.init(50)), .operator(.modulus), .operand(.init(20)), .operator(.modulus), .operand(.init(3))],
            expectedTokens: [.operand(.init(1))]
        ),
    ] as [CalculatedCondition])
    func calculated_easy_expression(_ condition: CalculatedCondition) throws {
        let actual = try condition.tokens.calculated()
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        .init(
            tokens: [
                .operand(.init(10)),
                .operator(.addition),
                .operand(.init(5)),
                .operator(.multiplication),
                .operator(.subtraction),
                .operand(.init(6)),
                .operator(.division),
                .operator(.subtraction),
                .operand(.init(3)),
                .operator(.addition),
                .operand(.init(2))
            ],
            expectedTokens: [.operand(.init(22))]
        ),
        .init(
            tokens: [
                .operand(.init(123.45)),
                .operator(.modulus),
                .operand(.init(3)),
                .operator(.multiplication),
                .operand(.init(100)),
                .operator(.division),
                .operand(.init(9)),
                .operator(.subtraction),
                .operand(.init(7)),
                .operator(.addition),
                .operand(.init(2))
            ],
            expectedTokens: [.operand(.init(0))]
        ),
    ] as [CalculatedCondition])
    func calculated_complicated_expression(_ condition: CalculatedCondition) throws {
        let actual = try condition.tokens.calculated()
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        // 5-3×-2 -> 5-(-6) -> 11
        .init(
            tokens: [
                .operand(.init(5)),
                .operator(.subtraction),
                .operand(.init(3)),
                .operator(.multiplication),
                .operator(.subtraction),
                .operand(.init(2))
            ],
            expectedTokens: [.operand(.init(11))]
        ),
        // 5+3×-2 -> 5+(-6) -> -1
        .init(
            tokens: [
                .operand(.init(5)),
                .operator(.addition),
                .operand(.init(3)),
                .operator(.multiplication),
                .operator(.subtraction),
                .operand(.init(2))
            ],
            expectedTokens: [.operator(.subtraction), .operand(.init(1))]
        ),
        // 2×-3-1 -> (-6)-1 -> -7
        .init(
            tokens: [
                .operand(.init(2)),
                .operator(.multiplication),
                .operator(.subtraction),
                .operand(.init(3)),
                .operator(.subtraction),
                .operand(.init(1))
            ],
            expectedTokens: [.operator(.subtraction), .operand(.init(7))]
        ),
        // 6÷-3-1 -> (-2)-1 -> -3
        .init(
            tokens: [
                .operand(.init(6)),
                .operator(.division),
                .operator(.subtraction),
                .operand(.init(3)),
                .operator(.subtraction),
                .operand(.init(1))
            ],
            expectedTokens: [.operator(.subtraction), .operand(.init(3))]
        ),
    ] as [CalculatedCondition])
    func calculated_binary_minus_expression(_ condition: CalculatedCondition) throws {
        let actual = try condition.tokens.calculated()
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        // 1+1= -> 2
        .init(
            tokens: [.operand(.init(1)), .operator(.addition), .operand(.init(1)), .operator(.equal)],
            expectedTokens: [.operand(.init(2))]
        ),
        // 1+1=+1=+1= -> ((1+1)+1)+1 -> 4
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal)
            ],
            expectedTokens: [.operand(.init(4))]
        ),
        // 1+1=-1= -> (1+1)-1 -> 1
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operator(.subtraction),
                .operand(.init(1)),
                .operator(.equal)
            ],
            expectedTokens: [.operand(.init(1))]
        ),
        // 1-3=+1= -> (1-3)+1 -> -1
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.subtraction),
                .operand(.init(3)),
                .operator(.equal),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal)
            ],
            expectedTokens: [.operator(.subtraction), .operand(.init(1))]
        ),
        // 2×3=%4= -> (2×3)%4 -> 2
        .init(
            tokens: [
                .operand(.init(2)),
                .operator(.multiplication),
                .operand(.init(3)),
                .operator(.equal),
                .operator(.modulus),
                .operand(.init(4)),
                .operator(.equal)
            ],
            expectedTokens: [.operand(.init(2))]
        ),
        // 1+1=+5= -> (1+1)+5 -> 7
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operator(.addition),
                .operand(.init(5)),
                .operator(.equal)
            ],
            expectedTokens: [.operand(.init(7))]
        ),
        // 1+1== -> an empty segment keeps the previous result -> 2
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operator(.equal)
            ],
            expectedTokens: [.operand(.init(2))]
        ),
        // 1+1=+1 (without trailing equal) -> 3
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operator(.addition),
                .operand(.init(1))
            ],
            expectedTokens: [.operand(.init(3))]
        ),
    ] as [CalculatedCondition])
    func calculated_chained_expression(_ condition: CalculatedCondition) throws {
        let actual = try condition.tokens.calculated()
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        .init(
            tokens: [.operator(.equal)],
            expectedError: .invalidFormula
        ),
        // +1= -> a segment starting with an operator requires a previous result
        .init(
            tokens: [.operator(.addition), .operand(.init(1)), .operator(.equal)],
            expectedError: .invalidFormula
        ),
        // 1+1=5= -> an operand must not follow a calculated result
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operand(.init(5)),
                .operator(.equal)
            ],
            expectedError: .invalidFormula
        ),
        // 1+1=5+3= -> an operand must not follow a calculated result
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operand(.init(5)),
                .operator(.addition),
                .operand(.init(3)),
                .operator(.equal)
            ],
            expectedError: .invalidFormula
        ),
        // 6÷2=÷0= -> undefined
        .init(
            tokens: [
                .operand(.init(6)),
                .operator(.division),
                .operand(.init(2)),
                .operator(.equal),
                .operator(.division),
                .operand(.init(0)),
                .operator(.equal)
            ],
            expectedError: .undefined
        ),
    ] as [ErrorCondition])
    func calculated_chained_expression_error(_ condition: ErrorCondition) throws {
        #expect(throws: condition.expectedError) {
            try condition.tokens.calculated()
        }
    }
}

struct TokensCondition {
    var decimalValue: Decimal
    var expectedTokens: [Token]
}

struct RemoveCondition {
    var tokens: [Token]
    var at: Int
    var count: Int
    var expectedTokens: [Token]
}

struct SignedOperandCondition {
    var tokens: [Token]
    var index: Int
    var expectedSignedOperand: SignedOperand?
}

struct CalculatedCondition {
    var tokens: [Token]
    var expectedTokens: [Token]?
}

struct ErrorCondition {
    var tokens: [Token]
    var expectedError: CalculationError
}
