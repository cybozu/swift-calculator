import Testing

@testable import CalculatorCore

struct CalculatorEngineTests {
    @Test(arguments: [
        .init(
            number: 0,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0")
            )
        ),
        .init(
            number: 1,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1")
            )
        ),
        .init(
            number: 2,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("2")
            )
        ),
        .init(
            number: 3,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("3")
            )
        ),
        .init(
            number: 4,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("4")
            )
        ),
        .init(
            number: 5,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("5")
            )
        ),
        .init(
            number: 6,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("6")
            )
        ),
        .init(
            number: 7,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("7")
            )
        ),
        .init(
            number: 8,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("8")
            )
        ),
        .init(
            number: 9,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("9")
            )
        ),
    ] as [NumberCondition])
    func handle_number_when_empty(_ condition: NumberCondition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(number: condition.number)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            operator: .addition,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            )
        ),
        .init(
            operator: .subtraction,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("-")
            )
        ),
        .init(
            operator: .multiplication,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            )
        ),
        .init(
            operator: .division,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            )
        ),
        .init(
            operator: .modulus,
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            )
        ),

    ] as [OperatorCondition])
    func handle_operator_when_empty(_ condition: OperatorCondition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: condition.operator)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test
    func handle_period_when_empty() {
        var sut = CalculatorEngine()
        sut.handlePeriod()
        #expect(sut.isEditingOperand)
        #expect(sut.tokens == .init("0."))
        #expect(sut.expression == "0.")
    }

    @Test(arguments: [
        .init(
            number: 1,
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1")
            )
        ),
        .init(
            number: 1,
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0.")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0.1")
            )
        ),
        .init(
            number: 2,
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0.1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0.12")
            )
        ),
    ] as [NumberCondition])
    func handle_number_after_operand(_ condition: NumberCondition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(number: condition.number)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("2")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("2.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("3")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("3.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("4")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("4.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("5")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("5.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("6")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("6.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("7")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("7.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("8")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("8.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("9")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("9.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1.1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1.1")
            )
        ),
    ] as [Condition])
    func handle_period_after_number(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handlePeriod()
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("+0.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("-0.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("×")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("×0.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("÷0.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("%")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("%0.")
            )
        ),
    ] as [Condition])
    func handle_period_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handlePeriod()
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            operator: .addition,
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1+")
            )
        ),
        .init(
            operator: .subtraction,
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1-")
            )
        ),
        .init(
            operator: .multiplication,
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1×")
            )
        ),
        .init(
            operator: .division,
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1÷")
            )
        ),
        .init(
            operator: .modulus,
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1%")
            )
        ),
    ] as [OperatorCondition])
    func handle_operator_input_operator_after_operand(_ condition: OperatorCondition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: condition.operator)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("+")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("+")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("-")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: []
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("×")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("+")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("+")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("%")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("+")
            )
        ),
    ] as [Condition])
    func handle_operator_input_addition_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: .addition)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0%-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            )
        ),
    ] as [Condition])
    func handle_operator_input_addition_after_operand_and_operators(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: .addition)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("+")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("-")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("×")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("×-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("÷-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("%")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("%-")
            )
        ),
    ] as [Condition])
    func handle_operator_input_subtraction_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: .subtraction)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0×-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0×-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0%-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%-")
            )
        ),
    ] as [Condition])
    func handle_operator_input_subtraction_after_operand_and_operators(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: .subtraction)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("+")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("×")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("-")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: []
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("×")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("×")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("×")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("%")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("×")
            )
        ),
    ] as [Condition])
    func handle_operator_input_multiplication_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: .multiplication)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0%-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            )
        ),
    ] as [Condition])
    func handle_operator_input_multiplication_after_operand_and_operators(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: .multiplication)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("+")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("-")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: []
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("×")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("%")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            )
        ),
    ] as [Condition])
    func handle_operator_input_division_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: .division)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0%-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            )
        ),
    ] as [Condition])
    func handle_operator_input_division_after_operand_and_operators(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: .division)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("+")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("%")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("-")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: []
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("×")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("%")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("%")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("%")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("%")
            )
        ),
    ] as [Condition])
    func handle_operator_input_modulus_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: .modulus)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0%-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            )
        ),
    ] as [Condition])
    func handle_operator_input_modulus_after_operand_and_operators(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(operator: .modulus)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("+0")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("-0")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("×")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("×0")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("÷")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("÷0")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("%")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("%0")
            )
        ),
    ] as [Condition])
    func handle_number_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handle(number: 0)
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: []
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("-")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("-")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("-1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("-1")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1-0")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1+0")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1+0")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1-0")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("×1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("×-1")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("×-1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("×1")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("÷1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("÷-1")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("÷-1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("÷1")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("%-1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("%1")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("%1")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("%-1")
            )
        ),
    ] as [Condition])
    func handle_plus_minus(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handlePlusMinus()
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test
    func handle_calculate_skipped() {
        var sut = CalculatorEngine()
        sut.isEditingOperand = true
        sut.tokens = .init("1×-")
        sut.handleCalculate()
        #expect(sut.isEditingOperand)
        #expect(sut.tokens == .init("1×-"))
    }

    @Test
    func handle_calculate_succeeded() {
        var sut = CalculatorEngine()
        sut.isEditingOperand = true
        sut.tokens = .init("1×-1")
        sut.handleCalculate()
        #expect(!sut.isEditingOperand)
        #expect(sut.tokens == .init("-1"))
        #expect(sut.expression == "-1")
    }

    @Test(arguments: [.division, .modulus] as [Operator])
    func handle_calculate_failed(_ o: Operator) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = true
        sut.tokens = [.operand(.init(1)), .operator(o), .operand(.init(0))]
        sut.handleCalculate()
        #expect(!sut.isEditingOperand)
        #expect(sut.tokens.isEmpty)
        #expect(sut.error == .undefined)
    }

    @Test
    func handle_operator_input_equal() {
        var sut = CalculatorEngine()
        sut.isEditingOperand = true
        sut.tokens = .init("1+1")
        sut.handle(operator: .equal)
        #expect(!sut.isEditingOperand)
        #expect(sut.tokens == .init("2"))
        #expect(sut.expression == "2")
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("5")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("5")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("-5")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("-5")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1+")
            )
        ),
    ] as [Condition])
    func handle_calculate_settles_a_lone_operand(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handleCalculate()
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test
    func handle_calculate_clears_a_stale_error() {
        var sut = CalculatorEngine()
        sut.error = .undefined
        sut.tokens = .init("2+2")
        sut.handleCalculate()
        #expect(sut.error == nil)
        #expect(sut.tokens == .init("4"))
    }

    @Test(arguments: [-1, 10, 42])
    func handle_number_ignores_out_of_range_input(_ input: Int) {
        var sut = CalculatorEngine()
        sut.handle(number: input)
        #expect(sut.tokens.isEmpty)
    }

    @Test
    func reset_with_nan_falls_back_to_zero() {
        var sut = CalculatorEngine()
        sut.reset(with: .nan)
        #expect(sut.expression == "0")
        sut.handleDelete()
        #expect(sut.tokens.isEmpty)
    }

    @Test
    func handle_number_on_an_operand_marks_editing() {
        var sut = CalculatorEngine()
        sut.tokens = .init("12")
        sut.handle(number: 5)
        #expect(sut.isEditingOperand)
        #expect(sut.tokens == .init("125"))
    }

    @Test
    func handle_delete_on_an_operand_marks_editing() {
        var sut = CalculatorEngine()
        sut.tokens = .init("12")
        sut.handleDelete()
        #expect(sut.isEditingOperand)
        #expect(sut.tokens == .init("1"))
    }

    @Test
    func handle_all_clear() {
        var sut = CalculatorEngine()
        sut.isEditingOperand = true
        sut.tokens = .init("1+1")
        sut.handleAllClear()
        #expect(!sut.isEditingOperand)
        #expect(sut.tokens.isEmpty)
        #expect(sut.expression == "0")
    }

    @Test
    func handle_all_clear_undefined() {
        var sut = CalculatorEngine()
        sut.error = .undefined
        sut.handleAllClear()
        #expect(sut.error == nil)
        #expect(sut.expression == "0")
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: []
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("-1")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: .init("-")
            )
        ),
    ] as [Condition])
    func handle_clear(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handleClear()
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: []
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: []
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: []
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("12")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1.")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1.2")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1.+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1.")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("1.2+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("1.2")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0+")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: false,
                tokens: .init("-")
            ),
            expect: .init(
                isEditingOperand: false,
                tokens: []
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0-")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0×")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0÷")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0")
            )
        ),
        .init(
            premise: .init(
                isEditingOperand: true,
                tokens: .init("0%")
            ),
            expect: .init(
                isEditingOperand: true,
                tokens: .init("0")
            )
        ),
    ] as [Condition])
    func handle_delete(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingOperand = condition.premise.isEditingOperand
        sut.tokens = condition.premise.tokens
        sut.handleDelete()
        #expect(sut.isEditingOperand == condition.expect.isEditingOperand)
        #expect(sut.tokens == condition.expect.tokens)
    }
}

struct Premise: Sendable {
    var isEditingOperand: Bool
    var tokens: [Token]
}

struct Expect: Sendable {
    var isEditingOperand: Bool
    var tokens: [Token]
}

struct Condition: Sendable {
    var premise: Premise
    var expect: Expect
}

struct NumberCondition: Sendable {
    var number: Int
    var premise: Premise
    var expect: Expect
}

struct OperatorCondition: Sendable {
    var `operator`: Operator
    var premise: Premise
    var expect: Expect
}
