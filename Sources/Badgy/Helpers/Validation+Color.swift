//
//  Badgy
//

import Foundation
import SwiftCLI

extension Validation where T == String {
    static func colorCode() -> Self {
        let message = """

            Specify a valid hex color code in a case insensitive format: '#rrbbgg' | '#rrbbggaa'
                or
            Provide a named color: 'snow' | 'snow1' | ...
            Complete list of named colors: https://imagemagick.org/script/color.php#color_names
        """
        
        return Validation.any(message, validations: isHexColor, isColorName)
    }
}
