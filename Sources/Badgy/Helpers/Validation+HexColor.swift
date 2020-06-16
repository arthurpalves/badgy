//
//  Badgy
//

import Foundation
import SwiftCLI

extension Validation where T == String {
    /// Checks whether the `input` matches '#rrbbgg' | '#rrbbggaa' color formats
    static func isHexColor(_ input: String) -> Bool {
        NSRegularExpression.hexColorCode.matches(input)
    }
}

private extension NSRegularExpression {
    /// Regular expression that matches '#rrbbgg' and '#rrbbggaa' formats
    ///
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
