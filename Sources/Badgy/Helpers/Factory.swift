//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import AppKit
import PathKit

typealias BadgeProductionResponse = ((Result<String, Error>) throws -> Void)

struct Factory {
    static let colors = ["#EE6D6D", "#A36DEE", "#4C967E", "#3B8A4B", "#CABA0E", "#E68C31", "#E11818"]
    
    func makeBadge(with label: String,
                   colorHexCode: String? = nil,
                   tintColorHexCode: String? = nil,
                   angle: Int? = nil,
                   inFolder folder: Path) throws -> String {
        
        do {
            let color = colorHexCode ?? Factory.colors.randomElement()!
            let tintColor = tintColorHexCode ?? "white"
            
            let folderBase = folder.absolute().description
            if !folder.isDirectory {
                try Bash("mkdir", folderBase).run()
            }
            
            try Bash(
                "convert",
                "-size", "1520x",
                "-background", color,
                "-gravity", "Center",
                "-weight", "700",
                "-pointsize", "50",
                "-fill", color,
                "caption:'-'",
                "\(folderBase)/top.png"
            ).run()
            
            try Bash(
                "convert",
                "-size", "1520x",
                "-background", color,
                "-gravity", "Center",
                "-weight","700",
                "-pointsize", "180",
                "-fill", "\(tintColor)",
                "caption:\(label)",
                "\(folderBase)/bottom.png"
            ).run()
            
            try Bash("convert", "\(folderBase)/top.png", "\(folderBase)/bottom.png",
                     "-append", "\(folderBase)/badge.png"
            ).run()
            
            if let angle = angle {
                try Bash("convert", "\(folderBase)/badge.png",
                         "-background", "transparent",
                         "-rotate", "\(angle)",
                         "\(folderBase)/badge.png"
                ).run()
            }
            
            return "\(folderBase)/badge.png"
        } catch {
            print("FAILED: \(error.localizedDescription)")
            throw error
        }
    }
    
    func appendBadge(to baseIcon: String,
                     folder: Path,
                     label: String,
                     position: Position?) throws -> String {
        let position = position ?? .bottom
        
        let folderBase = folder.absolute().description
        let finalFilename = "\(folderBase)/\(label).png"
        
        try Bash("convert", baseIcon,
                 "-resize", "1024x",
                 finalFilename
        ).run()
        
        try Bash("convert", "-composite",
                 "-gravity", "\(position.cardinal)",
                 finalFilename, "\(folderBase)/badge.png",
                 finalFilename
        ).run()
        
        return finalFilename
    }
    
    func cleanUp(folder: Path) throws {
        do {
            let folderBase = folder.absolute().description
            
            try Bash("rm", "-rf",
                     "\(folderBase)/top.png",
                     "\(folderBase)/bottom.png",
                     "\(folderBase)/badge.png").run()
        } catch {
            throw RuntimeError("Failed to clean up temporary files")
        }
    }
}
