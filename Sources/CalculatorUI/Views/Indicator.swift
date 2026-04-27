import SwiftUI

struct Indicator: View {
    var expression: String
    var fontSize: Double
    var width: Double
    @State private var textFrame = CGRect.zero

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
            .onChange(of: expression) { _, newValue in
                proxy.scrollTo("expression", anchor: .trailing)
            }
        }
    }
}
