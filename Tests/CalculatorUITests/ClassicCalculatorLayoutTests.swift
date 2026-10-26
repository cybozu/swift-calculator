#if canImport(AppKit)
import AppKit
import SwiftUI
import Testing
@testable import CalculatorUI

struct ClassicCalculatorLayoutTests {
    @MainActor
    private func width(proposedWidth: CGFloat) -> CGFloat {
        let view = Calculator(value: .constant("0"))
            .calculatorStyle(.classic(buttonFontSize: 32, buttonBorderShape: .roundedRectangle))
        return NSHostingController(rootView: view).sizeThatFits(in: CGSize(width: proposedWidth, height: 1000)).width
    }

    @Test("提案された幅が本来の幅より狭いときはその幅まで縮む") @MainActor
    func shrinksToNarrowerProposedWidth() {
        let natural = width(proposedWidth: 2000)
        let narrow = natural - 40
        #expect(width(proposedWidth: narrow) == narrow)
    }

    @Test("提案された幅が本来の幅より広くても本来の幅のまま広がらない") @MainActor
    func keepsNaturalWidthForWiderProposal() {
        #expect(width(proposedWidth: 2000) == width(proposedWidth: 4000))
    }
}
#endif
