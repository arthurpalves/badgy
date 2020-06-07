//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import Foundation
import SwiftCLI

extension Validation where T == String {
    static func hexColorCode() -> Self {
        let message = "Specify valid hex color code in a case insensitive format '#rrbbgg' | '#rrbbggaa'"
        
        return Validation<String>.custom(message) { (input) in
            guard NSRegularExpression.hexColorCode.matches(input) else {
                Logger.shared.logError("❌ ", item: "Input color '\(input)' doesn't have a valid format")
                return false
            }
            
            return true
        }
    }
}

private extension NSRegularExpression {
    /// `^` asserts position at start of a line
    /// `#` matches the character # literally
    ///
    /// `(:?[0-9a-fA-F]{2})`
    /// - `(:?)` denotes a non-capturing group
    /// - `[0-9a-fA-F]` match a single character present in the list below
    /// - `{2}` - matches exactly 2 times
    ///
    /// `{3,4}` - matches between 3 and 4 times, as many times as possible
    ///
    /// Additional explanation at [regex101](https://regex101.com/)
    static let hexColorCode = NSRegularExpression("^#(?:[0-9a-fA-F]{2}){3,4}$")
}
