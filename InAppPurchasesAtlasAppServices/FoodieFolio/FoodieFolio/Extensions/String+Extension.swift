////////////////////////////////////////////////////////////////////////////
//
// Copyright 2023 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

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
