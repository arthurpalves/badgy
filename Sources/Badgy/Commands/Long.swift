//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import Foundation
import PathKit
import SwiftCLI

final class Long: DependencyManager, Command, IconSetDelegate {
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
    
    @Param(validation: Validation<String>
        .custom("Specify valid icon with format .png | .jpg | .appiconset") {
        (input) in
            
        let path = Path(input)
        let formats = [".png", ".jpg", ".jpeg", ".appiconset"]
        
        guard path.exists, formats.contains(where: { path.lastComponent.contains($0) })
        else {
            Logger.shared.logError("❌ ",
                                   item: "Input file doesn't exist or doesn't have a valid format")
            return false
        }
        return true
    })
    var icon: String
    
    @Key("-a", "--angle", description: "Rotation angle of the badge")
    var angle: String?
    var angleInt: Int = 0
    
    @Key("-p", "--position",
         description: "Position on which to place the badge",
         validation: [Validation.allowing(Position.top.rawValue, Position.left.rawValue,
                                         Position.bottom.rawValue, Position.right.rawValue,
                                         Position.center.rawValue)]
    )
    var position: String?
    
    @Key("-c", "--color",
         description: "Specify badge color with a hexadecimal color code or a named color",
         validation: [Validation.colorCode()]
    )
    var color: String?
    
    @Key("-t", "--tint-color",
         description: "Specify badge text/tint color with a hexadecimal color code or a named color",
         validation: [Validation.colorCode()]
    )
    var tintColor: String?
    
    let logger = Logger.shared
    let factory = Factory()
    
    var iconSetImages: IconSetImages?
    
    public func execute() throws {
        Logger.shared.verbose = VerboseFlag.value

        guard areDependenciesInstalled()
        else {
            throw CLI.Error(message: "Missing dependencies. Run: 'brew install imagemagick'")
        }
        
        logger.logSection("$ ", item: "badgy label \"\(labelText)\" \"\(icon)\"", color: .ios)
        if
            let stringAngle = angle,
            let angle = Int(String(stringAngle.replacingOccurrences(of: "\\", with: ""))) {
            switch angle {
            case -180...180:
                angleInt = angle
                logger.logDebug(item: "Acceptable angle")
            default:
                throw CLI.Error(message: "Angle should be within range -180 ... 180")
            }
        }
    }
    
    private func process() throws {
        var pipeline = IconSignPipeline(
            icon: try Icon(path: icon),
            label: labelText
        )
        
        pipeline.position = Position(rawValue: position ?? "bottom")
        pipeline.color = color
        pipeline.tintColor = color
        pipeline.angle = angleInt
        pipeline.replace = ReplaceFlag.value
        
        try pipeline.execute()
    }
}

