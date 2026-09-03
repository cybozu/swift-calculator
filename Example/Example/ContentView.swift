//
//  ContentView.swift
//  Example
//
//  Created by ky0me22 on 2025/10/21.
//

import CalculatorUI
import SwiftUI

struct ContentView: View {
    @State var value: Decimal?

    var body: some View {
        Calculator(value: $value)
    }
}

#Preview {
    ContentView()
}
