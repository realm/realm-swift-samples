//
//  String+Extension.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 11/08/2023.
//

import Foundation

/// An extension on the `String` type to provide a computed property for capitalizing the first word.
extension String {

    /// Capitalizes the first letter of a string and converts the rest of the letters to lowercase.
    ///
    /// This computed property takes the first letter of the string, capitalizes it, and then combines it
    /// with the remaining letters of the string after converting them to lowercase.
    /// The result is a string with the first letter capitalized and the rest of the letters in lowercase.
    var capitalizedWord: String {

        /// Get the first letter of the string and capitalize it.
        let firstLetter = self.prefix(1).capitalized

        /// Get the remaining letters of the string after the first one and convert them to lowercase.
        let remainingLetters = self.dropFirst().lowercased()

        /// Combine the capitalized first letter with the lowercase remaining letters.
        return firstLetter + remainingLetters
    }
}
