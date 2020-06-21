//
//  Badgy
//

import Foundation
import SwiftCLI

extension Validation where T == String {
    /// Check whether the `input` is a known color name
    static func isColorName(_ input: String) -> Bool {
        return ColorCode.isColorName(input)
    }
}
