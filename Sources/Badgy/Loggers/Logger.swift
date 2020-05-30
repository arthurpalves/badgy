//
//  Badgy
//
//  Created by Arthur Alves on 06/05/2020.
//

import Foundation
import SwiftCLI

public class Logger: VerboseLogger {
    static let shared = Logger()
    
    func logError(_ prefix: Any = "", item: Any, color: ShellColor = .red) {
        log(item: "--------------------------------------------------------------------------------------", logLevel: .error)
        log(prefix, item: item, color: color, logLevel: .error)
        log(item: "--------------------------------------------------------------------------------------", logLevel: .error)
    }
    
    func logInfo(_ prefix: Any = "", item: Any, indentationLevel: Int = 0, color: ShellColor = .neutral) {
        log(prefix, item: item, indentationLevel: indentationLevel, color: color, logLevel: .info)
    }
    
    func logDebug(_ prefix: Any = "", item: Any, indentationLevel: Int = 0, color: ShellColor = .neutral) {
        log(prefix, item: item, indentationLevel: indentationLevel, color: color, logLevel: .verbose)
    }
    
    func logSection(_ prefix: Any = "", item: Any, color: ShellColor = .neutral) {
        log(item: "--------------------------------------------------------------------------------------", logLevel: .info)
        log(prefix, item: item, color: color, logLevel: .info)
        log(item: "--------------------------------------------------------------------------------------", logLevel: .info)
    }
}
