import Foundation
import Testing

@testable import CalculatorCore

// Scenarios drive the engine through its public inputs from the start,
// and check what a calculator shows: the expression, the settled value, and the editing state.
struct CalculatorEngineScenarioTests {
    @Test(arguments: [
        .init(
            inputs: "1÷3=×3=",
            expect: .init(expression: "1", value: 1, isEditingOperand: false)
        ),
        .init(
            inputs: "1+1=+3=",
            expect: .init(expression: "5", value: 5, isEditingOperand: false)
        ),
        .init(
            inputs: "1+1=+×3=",
            expect: .init(expression: "6", value: 6, isEditingOperand: false)
        ),
        .init(
            inputs: "1+1=-×3=",
            expect: .init(expression: "6", value: 6, isEditingOperand: false)
        ),
        .init(
            inputs: "1+1=×-3=",
            expect: .init(expression: "-6", value: -6, isEditingOperand: false)
        ),
        .init(
            inputs: "1+1=×-+3=",
            expect: .init(expression: "5", value: 5, isEditingOperand: false)
        ),
        .init(
            inputs: "1+2=×3=",
            expect: .init(expression: "9", value: 9, isEditingOperand: false)
        ),
        .init(
            inputs: "1+1==",
            expect: .init(expression: "2", value: 2, isEditingOperand: false)
        ),
    ] as [ScenarioCondition])
    func operator_after_result_continues_the_formula(_ condition: ScenarioCondition) {
        var sut = CalculatorEngine()
        sut.input(condition.inputs)
        #expect(sut.scenarioExpect == condition.expect)
    }

    @Test(arguments: [
        .init(
            inputs: "1÷3=±",
            expect: .init(expression: "-0.333333333333333333333333333333", value: Decimal(string: "-0.333333333333333333333333333333"), isEditingOperand: false)
        ),
        .init(
            inputs: "1÷3=±×3=",
            expect: .init(expression: "-1", value: -1, isEditingOperand: false)
        ),
        .init(
            inputs: "1÷3=±±×3=",
            expect: .init(expression: "1", value: 1, isEditingOperand: false)
        ),
        .init(
            inputs: "1+1=×3±",
            expect: .init(expression: "2×-3", value: nil, isEditingOperand: true)
        ),
        .init(
            inputs: "1+1=+3±",
            expect: .init(expression: "2-3", value: nil, isEditingOperand: true)
        ),
        .init(
            inputs: "1+1=-3±",
            expect: .init(expression: "2+3", value: nil, isEditingOperand: true)
        ),
    ] as [ScenarioCondition])
    func plus_minus_after_result(_ condition: ScenarioCondition) {
        var sut = CalculatorEngine()
        sut.input(condition.inputs)
        #expect(sut.scenarioExpect == condition.expect)
    }

    @Test(arguments: [
        .init(
            inputs: "1÷3=⌫",
            expect: .init(expression: "0.33333333333333333333333333333", value: Decimal(string: "0.33333333333333333333333333333"), isEditingOperand: true)
        ),
        .init(
            inputs: "1÷3=5",
            expect: .init(expression: "0.3333333333333333333333333333335", value: Decimal(string: "0.3333333333333333333333333333335"), isEditingOperand: true)
        ),
        .init(
            inputs: "1+1=.",
            expect: .init(expression: "2.", value: 2, isEditingOperand: true)
        ),
        .init(
            inputs: "1÷3=C",
            expect: .init(expression: "0", value: nil, isEditingOperand: false)
        ),
    ] as [ScenarioCondition])
    func editing_the_digits_of_a_result_starts_from_the_rounded_result(_ condition: ScenarioCondition) {
        var sut = CalculatorEngine()
        sut.input(condition.inputs)
        #expect(sut.scenarioExpect == condition.expect)
    }

    @Test(arguments: [
        .init(
            inputs: "1÷3=×3=",
            expectedTokens: .init("1÷3=×3=")
        ),
        .init(
            inputs: "1+1==",
            expectedTokens: .init("1+1=")
        ),
    ] as [TokensScenarioCondition])
    func equal_keeps_the_whole_formula_in_tokens(_ condition: TokensScenarioCondition) {
        var sut = CalculatorEngine()
        sut.input(condition.inputs)
        #expect(sut.tokens == condition.expectedTokens)
    }
}

struct ScenarioCondition: Sendable {
    var inputs: String
    var expect: ScenarioExpect
}

struct TokensScenarioCondition: Sendable {
    var inputs: String
    var expectedTokens: [Token]
}

struct ScenarioExpect: Equatable, Sendable {
    var expression: String
    var value: Decimal?
    var isEditingOperand: Bool
}

private extension CalculatorEngine {
    var scenarioExpect: ScenarioExpect {
        .init(
            expression: expression,
            value: tokens.isSettledValue ? try? tokens.calculatedDecimalValue() : nil,
            isEditingOperand: isEditingOperand
        )
    }
}
