//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import Foundation

/// Thanks to [How to use regular expressions in swift | Paul Hudson   ](https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift)
internal extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
