//
//  File.swift
//  
//
//  Created by yahor mikhnevich on 6/21/20.
//

import Foundation
import ArgumentParser
import PathKit

enum Icon {
    case plain(Path)
    case set(IconSet)
    
    init(path: String) throws {
        let path = Path(path)
        
        guard path.exists else {
            let message = "Input file or directory doesn't exist"
            Logger.shared.logError("❌ ", item: message)
            throw ValidationError(message)
        }
        
        if let set = IconSet.makeFromFolder(at: path) {
            self = .set(set)
            return
        }
                
        if IconSet.imageExtensions.contains(path.extension ?? "") {
            self = .plain(path)
            return
        }

        let message = "Input file or directory doesn't have a valid format"
        Logger.shared.logError("❌ ", item: message)
        throw ValidationError(message)
    }
}

extension Icon {
    var path: Path {
        switch self {
        case .plain(let path): return path
        case .set(let set): return set.path
        }
    }
}
