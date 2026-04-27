<picture>
  <source srcset="https://github.com/user-attachments/assets/0ee71d7c-3f28-4e4f-b703-7495b7e4f2c8" height="70" media="(prefers-color-scheme: dark)" alt="WebUI by Cybozu">
  <img src="https://github.com/user-attachments/assets/983fd7f4-7f17-42b2-8eee-f3f3fd0205e2" height="70" alt="Calculator by Cybozu">
</picture>

Calculator is a Swift package that provides an inline calculator with SwiftUI API.

[![Github forks](https://img.shields.io/github/forks/cybozu/swift-calculator)](https://github.com/cybozu/swift-calculator/network/members)
[![Github stars](https://img.shields.io/github/stars/cybozu/swift-calculator)](https://github.com/cybozu/swift-calculator/stargazers)
[![Github issues](https://img.shields.io/github/issues/cybozu/swift-calculator)](https://github.com/cybozu/swift-calculator/issues)
[![Github release](https://img.shields.io/github/v/release/cybozu/swift-calculator)](https://github.com/cybozu/swift-calculator/releases)
[![Github license](https://img.shields.io/github/license/cybozu/swift-calculator)](https://github.com/cybozu/swift-calculator/blob/main/LICENSE)

<img width="352" height="352" src="https://github.com/user-attachments/assets/2fd08868-84b2-4ff0-82a3-ef46be32986e" />

## Requirements

- Development with Xcode 26.0+
- Written in Swift 6.2
- Compatible with iOS 26.0+, macOS 15.0+

## Documentation

[Latest (Swift-DocC)](https://cybozu.github.io/swift-calculator/documentation/calculatorui/)

## Usage

If you want to use the classic preset calculator:

```swift
import CalculatorUI
import SwiftUI

struct ContentView: View {
    @State var value: String = ""

    var body: some View {
        Calculator(value: $value)
            .calculatorStyle(.classic(
                buttonFontSize: 32,
                buttonBorderShape: .roundedRectangle
            ))
    }
}
```

If you want to create your own preferred calculator interface:

```swift
import CalculatorUI
import SwiftUI

struct CustomCalculatorStyle: CalculatorStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Text(configuration.value)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(4)
                .background(Color(.separator), in: .rect(cornerRadius: 8))
            ForEach(configuration.rows) { row in
                HStack {
                    ForEach(row.cells) { cell in
                        Button {
                            configuration.trigger(cell.role)
                        } label: {
                            cell.role.text
                                .frame(width: 40, height: 32)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .fixedSize()
    }
}

extension CalculatorStyle where Self == CustomCalculatorStyle {
    static var custom: CustomCalculatorStyle { .init() }
}

struct ContentView: View {
    @State var value: String = ""

    var body: some View {
        Calculator(value: $value)
            .calculatorStyle(.custom)
    }
}
```

## Privacy Manifest

This library does not collect or track user information, so it does not include a PrivacyInfo.xcprivacy file.

## Demo

This repository includes demonstration app for iOS & macOS.

Open [Example/Example.xcodeproj](/Example/Example.xcodeproj) and Run it.
