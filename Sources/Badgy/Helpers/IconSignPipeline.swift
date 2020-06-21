//
//  Badgy
//


import Foundation
import PathKit

struct IconSignPipeline {
    struct Error: Swift.Error {
        var message: String
    }
    
    var icon: Icon
    var label: String
    
    var position: Position?
    var color: String?
    var tintColor: String?
    var angle: Int? = nil
    var replace: Bool = false
    
    let logger = Logger.shared
    let factory = Factory()
    let folder = Path("Badgy")

    func execute() throws {
        defer { cleanUp() }
        
        let baseIcon = try icon.base()
        try makeBadge()
        let signedIcon = try appendBadge(to: baseIcon)
        postprocess(signedIcon)
    }
    
    private func makeBadge() throws {
        _ = try factory.makeBadge(
            with: label,
            colorHexCode: color,
            tintColorHexCode: tintColor,
            angle: angle,
            inFolder: folder
        )
    }
    
    private func appendBadge(to icon: Path) throws -> Path {
        let signedIconFilename  = try factory.appendBadge(
            to: icon.absolute().description,
            folder: folder,
            label: label,
            position: position
        )
        
        let signedIcon = Path(signedIconFilename)
        guard signedIcon.exists else {
            logger.logError("❌ ", item: "Failed to create badge")
            throw IconSignPipeline.Error(message: "Failed to create badge")
        }
        
        logger.logInfo(item: "Icon with badge '\(label)' created at '\(signedIcon.absolute().description)'")
        
        return signedIcon
    }
    
    private func postprocess(_ signedIcon: Path) {
         if replace, case .set(let iconSet) = icon {
             factory.replace(iconSet, with: signedIcon)
         } else {
             factory.resize(filename: signedIcon)
         }
    }
    
    private func cleanUp() {
        try? factory.cleanUp(folder: folder)
    }
}

private extension Icon {
    func base() throws -> Path {
        switch self {
        case .plain(let path):
            return path
        case .set(let set):
            guard let path = set.largest() else {
                throw IconSignPipeline.Error(message: "Couldn't find the largest image in the set")
            }
            
            return path
        }
    }
}
