import SwiftUI

struct Indicator: View {
    var expression: String
    var isEditingFormula: Bool
    var fontSize: Double
    var width: Double
    @State private var textFrame = CGRect.zero

    // A formula being edited shows its end, and a settled result or an error message its beginning.
    private var scrollAnchor: UnitPoint {
        isEditingFormula ? .trailing : .leading
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                Text(expression)
                    .font(.system(size: fontSize, weight: .semibold, design: .monospaced))
                    .lineLimit(1)
                    .foregroundStyle(Color.primary)
                    .frame(minWidth: width, alignment: .trailing)
                    .id("expression")
                    .background {
                        GeometryReader { proxy in
                            Color.clear.preference(
                                key: TextFramePreferenceKey.self,
                                value: proxy.frame(in: .named("scroll"))
                            )
                        }
                    }
                    .onPreferenceChange(TextFramePreferenceKey.self) { value in
                        MainActor.assumeIsolated {
                            textFrame = value
                        }
                    }
            }
            .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
            .frame(width: width)
            .mask(ScrollPlace(width: width, frame: textFrame).mask)
            .coordinateSpace(name: "scroll")
            .onChange(of: expression) {
                proxy.scrollTo("expression", anchor: scrollAnchor)
            }
            .onChange(of: isEditingFormula) {
                proxy.scrollTo("expression", anchor: scrollAnchor)
            }
        }
    }
}
