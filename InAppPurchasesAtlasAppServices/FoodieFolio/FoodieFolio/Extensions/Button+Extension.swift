//
//  Button+Extension.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 14/09/2023.
//

import SwiftUI

extension Button {
    func buttonStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(ColorPalette.violet)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
