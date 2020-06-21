//
//  Badgy
//

import Foundation
import SwiftCLI

extension Validation where T == String {
    /// Checks whether the `input` matches '#rrbbgg' | '#rrbbggaa' color formats
    static func isHexColor(_ input: String) -> Bool {
        ColorCode.isHexColor(input)
    }
}
