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
            throw ValidationError("Input file or directory doesn't exist")
        }
        
        if let set = IconSet.makeFromFolder(at: path) {
            self = .set(set)
            return
        }
                
        if IconSet.imageExtensions.contains(path.lastComponent) {
            self = .plain(path)
            return
        }
        
        throw ValidationError("Input file or directory doesn't have a valid format")
    }
}
