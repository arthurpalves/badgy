//
//  Badgy
//


import Foundation
import SwiftCLI

extension Validation {
    static func any<T>(_ message: String, validations: Validation<T>.ValidatorBlock...) -> Validation<T> {
        return Validation<T>.custom(message) { (input) in
            let isInputValid = validations.contains { validation in validation(input) }
            if !isInputValid {
                Logger.shared.logError("❌ ", item: message)
            }
            return isInputValid
        }
    }
}
