//
//  StockButton.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 16/11/25.
//

import SwiftUI

struct StockButton<Label: View>: View {
    let action: () -> Void
    var background: Color = ColorToken.greenColor.toColor()
    var foregroundColor: Color = ColorToken.whiteBlackColor.toColor()
    var cornerRadius: CGFloat = 10
    var padding: CGFloat = 8
    
    let label: () -> Label
    
    var body: some View {
        Button(action: action) {
            label()
                .padding(padding)
                .background(background)
                .foregroundStyle(foregroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}
