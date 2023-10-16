//
//  Double+Extension.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 14/08/2023.
//

import Foundation

extension Double {
    /// Rounds up the double value using the `ceil` function and returns a string representation without decimals.
    ///
    /// For example, if the value is 12.34, this method will round it up to 13 and return "13" as a string.
    ///
    /// - Returns: A string representation of the rounded-up value without decimals.
    func roundedUpToString() -> String {
        let roundedUpValue = ceil(self)

        return String(format: "%.0f", roundedUpValue)
    }
}
