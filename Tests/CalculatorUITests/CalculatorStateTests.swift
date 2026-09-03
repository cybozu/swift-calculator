import CalculatorCore
import Testing

@testable import CalculatorUI

@MainActor
struct CalculatorStateTests {
    @Test
    func onTap_equal() {
        let sut = CalculatorState()
        sut.onTap(.number(1))
        sut.onTap(.operator(.addition))
        sut.onTap(.number(2))
        sut.onTap(.operator(.equal))
        #expect(sut.expression == "3")
        #expect(!sut.isEditingOperand)
    }

    @Test
    func onTap_period_and_plus_minus() {
        let sut = CalculatorState()
        sut.onTap(.number(1))
        sut.onTap(.period)
        sut.onTap(.number(5))
        sut.onTap(.command(.plusMinus))
        #expect(sut.expression == "-1.5")
    }

    @Test
    func onTap_delete() {
        let sut = CalculatorState()
        sut.onTap(.number(1))
        sut.onTap(.number(2))
        sut.onTap(.command(.delete))
        #expect(sut.expression == "1")
    }

    @Test
    func onTap_clear_removes_only_editing_operand() {
        let sut = CalculatorState()
        sut.onTap(.number(1))
        sut.onTap(.operator(.addition))
        sut.onTap(.number(2))
        sut.onTap(.command(.clear))
        #expect(sut.expression == "1+")
    }

    @Test
    func onTap_all_clear() {
        let sut = CalculatorState()
        sut.onTap(.number(1))
        sut.onTap(.operator(.addition))
        sut.onTap(.command(.allClear))
        #expect(sut.expression == "0")
    }

    @Test
    func expression_shows_error_description() {
        let sut = CalculatorState()
        sut.onTap(.number(1))
        sut.onTap(.operator(.division))
        sut.onTap(.number(0))
        sut.onTap(.operator(.equal))
        #expect(sut.expression == CalculationError.undefined.localizedDescription)
    }

    @Test
    func setValue_with_decimal_string() {
        let sut = CalculatorState()
        sut.setValue("-1.5")
        #expect(sut.expression == "-1.5")
    }

    @Test
    func setValue_with_invalid_string() {
        let sut = CalculatorState()
        sut.setValue("abc")
        #expect(sut.expression == "0")
    }

    @Test
    func clear_role_is_derived_from_editing_state() {
        let sut = CalculatorState()
        #expect(clearCommand(of: sut) == .allClear)
        sut.onTap(.number(1))
        #expect(clearCommand(of: sut) == .clear)
        sut.onTap(.operator(.addition))
        sut.onTap(.number(2))
        sut.onTap(.operator(.equal))
        #expect(clearCommand(of: sut) == .allClear)
    }

    @Test
    func number_after_settled_result_starts_a_new_calculation() {
        let sut = CalculatorState()
        sut.onTap(.number(1))
        sut.onTap(.operator(.addition))
        sut.onTap(.number(2))
        sut.onTap(.operator(.equal))
        sut.onTap(.number(5))
        #expect(sut.expression == "5")
    }

    @Test
    func number_after_error_starts_a_new_calculation() {
        let sut = CalculatorState()
        sut.onTap(.number(1))
        sut.onTap(.operator(.division))
        sut.onTap(.number(0))
        sut.onTap(.operator(.equal))
        sut.onTap(.number(7))
        #expect(sut.expression == "7")
    }

    @Test
    func number_while_editing_operand_keeps_appending() {
        let sut = CalculatorState()
        sut.onTap(.number(2))
        sut.onTap(.number(5))
        sut.onTap(.command(.delete))
        sut.onTap(.number(3))
        #expect(sut.expression == "23")
    }

    @Test
    func operator_after_settled_result_continues_the_calculation() {
        let sut = CalculatorState()
        sut.onTap(.number(1))
        sut.onTap(.operator(.addition))
        sut.onTap(.number(2))
        sut.onTap(.operator(.equal))
        sut.onTap(.operator(.addition))
        sut.onTap(.number(1))
        sut.onTap(.operator(.equal))
        #expect(sut.expression == "4")
    }

    @Test
    func plus_minus_after_settled_result_negates_it() {
        let sut = CalculatorState()
        sut.onTap(.number(1))
        sut.onTap(.operator(.addition))
        sut.onTap(.number(2))
        sut.onTap(.operator(.equal))
        sut.onTap(.command(.plusMinus))
        #expect(sut.expression == "-3")
    }

    @Test
    func rows_keep_stable_identifiers() {
        let sut = CalculatorState()
        let before = sut.rows.flatMap { [$0.id] + $0.cells.map(\.id) }
        sut.onTap(.number(1))
        let after = sut.rows.flatMap { [$0.id] + $0.cells.map(\.id) }
        #expect(before == after)
    }

    private func clearCommand(of state: CalculatorState) -> Command? {
        for row in state.rows {
            for cell in row.cells {
                if case let .command(value) = cell.role, [.allClear, .clear].contains(value) {
                    return value
                }
            }
        }
        return nil
    }
}
