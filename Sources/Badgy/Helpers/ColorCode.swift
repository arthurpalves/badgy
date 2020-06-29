//
//  Badgy
//

import Foundation
import ArgumentParser

struct ColorCode {
    var value: String
}

extension ColorCode: ExpressibleByArgument {
    init?(argument: String) {
        switch argument {
        case let hex where ColorCode.isHexColor(argument):
            value = hex
        case let name where ColorCode.isColorName(argument):
            value = name
        default:
            return nil
        }
    }
}

extension ColorCode: CustomStringConvertible {
    var description: String {
        return value
    }
}

extension ColorCode: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self.init(argument: value)!
    }
}
