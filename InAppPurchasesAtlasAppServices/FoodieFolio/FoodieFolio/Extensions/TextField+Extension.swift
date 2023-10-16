//
//  TextField+Extension.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 14/09/2023.
//

import SwiftUI

extension TextField {
    func textFieldStyle() -> some View {
        self
            .padding(.all)
            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(.white, style: StrokeStyle(lineWidth: 1.0)))
            .foregroundColor(.white)
    }
}
