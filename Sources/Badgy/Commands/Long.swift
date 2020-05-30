//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import Foundation
import PathKit
import SwiftCLI

final class Long: Command {
    // --------------
    // MARK: Command information
    
    let name: String = "long"
    let shortDescription: String = "Add rectangular label to app icon"
    
    // --------------
    // MARK: Configuration Properties
    @Param(validation: Validation<String>.custom("Label should contain maximum 4 characters") {
     (input) in return input.count <= 4
    })
    var labelText: String
    
    @Param var icon: String
    
    @Key("-a", "--angle", description: "Rotation angle of the badge")
    var angle: Int?
    
    @Key("-p", "--position",
         description: "Position on which to place the badge",
         validation: [Validation.allowing(Position.top.rawValue, Position.left.rawValue,
                                         Position.bottom.rawValue, Position.right.rawValue,
                                         Position.topLeft.rawValue, Position.topRight.rawValue,
                                         Position.bottomLeft.rawValue, Position.bottomRight.rawValue,
                                         Position.center.rawValue)]
    )
    var position: String?
    
    let logger = Logger.shared
    let factory = Factory()
    
    public func execute() throws {
        logger.logSection("$ ", item: "badgy label \"\(labelText)\" \"\(icon)\"", color: .ios)
        if let angle = angle {
            switch angle {
            case -180...180:
                logger.logDebug(item: "Acceptable angle")
            default:
                throw CLI.Error(message: "Angle should be within range -180 ... 180")
            }
        }
        
        process()
    }
    
    private func process() {
        let folder = Path("Badgy")
        
        try factory.makeBadge(with: labelText, angle: angle, inFolder: folder, completion: { (result) in
            switch result {
            case .success(_):
                try self.factory.appendBadge(to: self.icon,
                                         folder: folder,
                                         label: self.labelText,
                                         position: Position(rawValue: self.position ?? "bottom")) {
                                            (result) in
                    switch result {
                    case .success(let filename):
                        let filePath = Path(filename)
                        guard filePath.exists
                        else {
                            self.logger.logError("Error: ", item: "Failed to create badge")
                            return
                        }
                        self.logger.logInfo(item: "New Icon with badge '\(self.labelText)' created at '\(filePath.absolute().description)'")
                        try self.factory.cleanUp(folder: folder)
                        
                        self.resize(filePath: filePath)
                    case .failure(let error):
                        try self.factory.cleanUp(folder: folder)
                        throw CLI.Error(message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                try self.factory.cleanUp(folder: folder)
                throw CLI.Error(message: error.localizedDescription)
            }
        })
    }
    
    private func resize(filePath: Path) {
        factory.resize(filename: filePath)
    }
}

