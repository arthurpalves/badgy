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
    /// Additional explanation at [regex101](https://regex101.com/r/j0MDnb/1/tests)
    static let hexColorCode = NSRegularExpression("^#(?:[0-9a-fA-F]{2}){3,4}$")
}
