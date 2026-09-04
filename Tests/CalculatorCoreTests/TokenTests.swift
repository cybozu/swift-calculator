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
            tokens: .init("1×-2"),
            at: 1,
            count: 3,
            expectedTokens: [.operand(.init(1))]
        ),
        .init(
            tokens: .init("1×-2"),
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
            tokens: .init("1"),
            index: 0,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: .init("-1"),
            index: 1,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: .init("1+2"),
            index: 1,
            expectedSignedOperand: .init(value: 1, cost: 1)
        ),
        .init(
            tokens: .init("-1+2"),
            index: 2,
            expectedSignedOperand: .init(value: -1, cost: 2)
        ),
        .init(
            tokens: .init("1+2+3"),
            index: 3,
            expectedSignedOperand: .init(value: 2, cost: 1)
        ),
        .init(
            tokens: .init("1-2+3"),
            index: 3,
            expectedSignedOperand: .init(value: 2, cost: 1)
        ),
        .init(
            tokens: .init("1×-2"),
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
            tokens: .init("1"),
            index: 0,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: .init("1-"),
            index: 0,
            expectedSignedOperand: nil
        ),
        .init(
            tokens: .init("1+2"),
            index: 1,
            expectedSignedOperand: .init(value: 2, cost: 1)
        ),
        .init(
            tokens: .init("1×-2"),
            index: 1,
            expectedSignedOperand: .init(value: -2, cost: 2)
        ),
        .init(
            tokens: .init("1+2+3"),
            index: 1,
            expectedSignedOperand: .init(value: 2, cost: 1)
        ),
        .init(
            tokens: .init("1×-2"),
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
            tokens: .init("1+1"),
            expectedTokens: [.operand(.init(2))]
        ),
        .init(
            tokens: .init("1-1"),
            expectedTokens: [.operand(.init(0))]
        ),
        .init(
            tokens: .init("2×3"),
            expectedTokens: [.operand(.init(6))]
        ),
        .init(
            tokens: .init("6÷3"),
            expectedTokens: [.operand(.init(2))]
        ),
        .init(
            tokens: .init("3%2"),
            expectedTokens: [.operand(.init(1))]
        ),
        .init(
            tokens: .init("3.5%2"),
            expectedTokens: [.operand(.init(1.5))]
        ),
        .init(
            tokens: .init("-3.5%2"),
            expectedTokens: [.operator(.subtraction), .operand(.init(1.5))]
        ),
        .init(
            tokens: .init("3.5%-2"),
            expectedTokens: [.operand(.init(1.5))]
        ),
        .init(
            tokens: .init("-3.5%-2"),
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
            expectedError: .invalidFormula(.incompleteFormula)
        ),
        .init(
            tokens: .init("1"),
            expectedError: .invalidFormula(.incompleteFormula)
        ),
        .init(
            tokens: .init("-"),
            expectedError: .invalidFormula(.incompleteFormula)
        ),
        .init(
            tokens: .init("-1"),
            expectedError: .invalidFormula(.incompleteFormula)
        ),
        .init(
            tokens: .init("1+"),
            expectedError: .invalidFormula(.incompleteFormula)
        ),
        .init(
            tokens: .init("1×÷"),
            expectedError: .invalidFormula(.incompleteFormula)
        ),
        .init(
            tokens: .init("1÷0"),
            expectedError: .undefined
        ),
        .init(
            tokens: .init("1%0"),
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
            tokens: .init("1+1+1+1"),
            expectedTokens: [.operand(.init(4))]
        ),
        .init(
            tokens: .init("1-1-1-1"),
            expectedTokens: [.operator(.subtraction), .operand(.init(2))]
        ),
        .init(
            tokens: .init("2×3×4×5"),
            expectedTokens: [.operand(.init(120))]
        ),
        .init(
            tokens: .init("300÷10÷5÷2"),
            expectedTokens: [.operand(.init(3))]
        ),
        .init(
            tokens: .init("80%50%20%3"),
            expectedTokens: [.operand(.init(1))]
        ),
    ] as [CalculatedCondition])
    func calculated_easy_expression(_ condition: CalculatedCondition) throws {
        let actual = try condition.tokens.calculated()
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        .init(
            tokens: .init("10+5×-6÷-3+2"),
            expectedTokens: [.operand(.init(22))]
        ),
        .init(
            tokens: .init("123.45%3×100÷9-7+2"),
            expectedTokens: [.operand(.init(0))]
        ),
    ] as [CalculatedCondition])
    func calculated_complicated_expression(_ condition: CalculatedCondition) throws {
        let actual = try condition.tokens.calculated()
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        .init(
            tokens: .init("5-3×-2"),
            expectedTokens: [.operand(.init(11))]
        ),
        .init(
            tokens: .init("5+3×-2"),
            expectedTokens: [.operator(.subtraction), .operand(.init(1))]
        ),
        .init(
            tokens: .init("2×-3-1"),
            expectedTokens: [.operator(.subtraction), .operand(.init(7))]
        ),
        .init(
            tokens: .init("6÷-3-1"),
            expectedTokens: [.operator(.subtraction), .operand(.init(3))]
        ),
    ] as [CalculatedCondition])
    func calculated_binary_minus_expression(_ condition: CalculatedCondition) throws {
        let actual = try condition.tokens.calculated()
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        .init(
            tokens: .init("10000000000000001+1"),
            expectedTokens: [.operand(.init(decimalValue: Decimal(string: "10000000000000002")!))]
        ),
        .init(
            tokens: .init("0.1+0.2"),
            expectedTokens: [.operand(.init(0.3))]
        ),
        .init(
            tokens: .init("1÷3"),
            expectedTokens: [.operand(.init(0.3333333))]
        ),
        .init(
            tokens: .init("0.3%0.1"),
            expectedTokens: [.operand(.init(0))]
        ),
    ] as [CalculatedCondition])
    func calculated_precise_expression(_ condition: CalculatedCondition) throws {
        let actual = try condition.tokens.calculated()
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        .init(
            tokens: .init("1+1="),
            expectedTokens: [.operand(.init(2))]
        ),
        .init(
            tokens: .init("1+1=+1=+1="),
            expectedTokens: [.operand(.init(4))]
        ),
        .init(
            tokens: .init("1+1=-1="),
            expectedTokens: [.operand(.init(1))]
        ),
        .init(
            tokens: .init("1-3=+1="),
            expectedTokens: [.operator(.subtraction), .operand(.init(1))]
        ),
        .init(
            tokens: .init("2×3=%4="),
            expectedTokens: [.operand(.init(2))]
        ),
        .init(
            tokens: .init("1+1=+5="),
            expectedTokens: [.operand(.init(7))]
        ),
        .init(
            tokens: .init("1+1=="),
            expectedTokens: [.operand(.init(2))]
        ),
        .init(
            tokens: .init("1+1=+1"),
            expectedTokens: [.operand(.init(3))]
        ),
    ] as [CalculatedCondition])
    func calculated_chained_expression(_ condition: CalculatedCondition) throws {
        let actual = try condition.tokens.calculated()
        #expect(actual == condition.expectedTokens)
    }

    @Test(arguments: [
        .init(
            tokens: .init("="),
            expectedError: .invalidFormula(.equalWithoutFormula)
        ),
        .init(
            tokens: .init("+1="),
            expectedError: .invalidFormula(.incompleteFormula)
        ),
        .init(
            tokens: .init("=1+1"),
            expectedError: .invalidFormula(.equalWithoutFormula)
        ),
        .init(
            tokens: .init("1+1=5="),
            expectedError: .invalidFormula(.operandAfterResult)
        ),
        .init(
            tokens: .init("1+1=5+3="),
            expectedError: .invalidFormula(.operandAfterResult)
        ),
        .init(
            tokens: .init("6÷2=÷0="),
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
