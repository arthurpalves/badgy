//
//  File.swift
//  
//
//  Created by yahor mikhnevich on 6/21/20.
//

import Foundation

extension ColorCode {
    /// Checks whether the `input` matches the valid color formats
    ///
    /// Valid colors formats are `#rrggbb` | `#rrggbbaa`
    static func isHexColor(_ hex: String) -> Bool {
        NSRegularExpression.hexColorCode.matches(hex)
    }
}

private extension NSRegularExpression {
    /// Regular expression that matches '#rrggbb' and '#rrggbbaa' formats
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
