import SwiftUI

struct ClassicCalculatorView: View {
    @State private var width = Double.zero
    @ScaledMetric private var buttonFontSize: Double
    @ScaledMetric private var spacing: Double
    @ScaledMetric private var cornerRadius: Double
    private var configuration: CalculatorStyleConfiguration
    private var buttonBorderShape: ButtonBorderShape

    init(
        configuration: CalculatorStyleConfiguration,
        buttonFontSize: Double,
        buttonBorderShape: ButtonBorderShape
    ) {
        self.configuration = configuration
        _buttonFontSize = .init(wrappedValue: buttonFontSize, relativeTo: .title)
        _spacing = .init(wrappedValue: 0.4 * buttonFontSize, relativeTo: .title)
        _cornerRadius = .init(wrappedValue: 0.8 * buttonFontSize, relativeTo: .title)
        self.buttonBorderShape = buttonBorderShape
    }

    var body: some View {
        VStack(spacing: spacing) {
            Indicator(
                expression: configuration.value,
                fontSize: 1.5 * buttonFontSize,
                width: width
            )
            Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                ForEach(Array(configuration.rows.enumerated()), id: \.element.id) { offset, row in
                    GridRow {
                        ForEach(row.cells) { cell in
                            Button {
                                configuration.trigger(cell.role)
                            } label: {
                                ZStack {
                                    Text(verbatim: "AC").hidden()
                                    cell.role.text
                                }
                                .font(.system(size: buttonFontSize, weight: .bold))
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .foregroundStyle(Color.white)
                            }
                            .tint(Area(rowIndex: offset, rowLast: row.cells.last?.id == cell.id).color)
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(buttonBorderShape)
                            .accessibilityIdentifier(cell.role.accessibilityIdentifier)
                        }
                    }
                }
            }
            .fixedSize()
            .background {
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: WidthPreferenceKey.self,
                        value: proxy.size.width
                    )
                }
            }
            .onPreferenceChange(WidthPreferenceKey.self) { value in
                MainActor.assumeIsolated {
                    width = value
                }
            }
        }
        .padding(2 * spacing)
        .background(Color.background, in: .rect(cornerRadius: cornerRadius))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("calculator")
    }
}
