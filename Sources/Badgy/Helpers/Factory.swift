//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import SwiftCLI
import AppKit
import PathKit

typealias BadgeProductionResponse = ((Result<String, Error>) throws -> Void)

struct Factory {
    let colors = ["#EE6D6D", "#A36DEE", "#4C967E", "#3B8A4B", "#CABA0E", "#E68C31", "#E11818"]
    
    func makeBadge(with label: String,
                   colorHexCode: String? = nil,
                   angle: Int? = nil,
                   inFolder folder: Path,
                   completion: @escaping BadgeProductionResponse) {
        
        let color = colorHexCode ?? colors.randomElement()!
        
        do {
            let folderBase = folder.absolute().description
            if !folder.isDirectory {
                try Task.run("mkdir", folderBase)
            }
            
            try Task.run(
                "convert", "-size", "1520x",
                "-background", color,
                "-gravity", "Center",
                "-weight","700",
                "-pointsize", "50",
                "-fill", color,
                "caption:'-'",
                "\(folderBase)/top.png"
            )
            
            try Task.run(
                "convert", "-size", "1520x",
                "-background", color,
                "-gravity", "Center",
                "-weight","700",
                "-pointsize", "180",
                "-fill", "white",
                "caption:\(label)",
                "\(folderBase)/bottom.png"
            )
            
            try Task.run(
                "convert", "\(folderBase)/top.png", "\(folderBase)/bottom.png",
                "-append", "\(folderBase)/badge.png"
            )
            
            if let angle = angle {
                try Task.run(
                    "convert", "\(folderBase)/badge.png",
                    "-background", "transparent",
                    "-rotate", "\(angle)",
                    "\(folderBase)/badge.png"
                )
            }
            try completion(.success("\(folderBase)/badge.png"))
            
        } catch let error {
            print("FAILED: \(error.localizedDescription)")
            try? completion(.failure(error))
        }
    }
    
    func appendBadge(to baseIcon: String, folder: Path, label: String,
                     position: Position, completion: @escaping BadgeProductionResponse) {
        do {
            let folderBase = folder.absolute().description
            let finalFilename = "\(folderBase)/\(label).png"
            
            try Task.run(
                "convert", baseIcon,
                "-resize", "1024x",
                finalFilename
            )
            
            try Task.run(
                "convert", "-composite",
                "-gravity", "\(position.cardinal)",
                finalFilename, "\(folderBase)/badge.png",
                finalFilename
            )
            
            try completion(.success(finalFilename))
        } catch let error {
            try? completion(.failure(error))
        }
    }
    
    func cleanUp(folder: Path) throws {
        do {
            let folderBase = folder.absolute().description
            
            try Task.run("rm", "-rf",
                         "\(folderBase)/top.png",
                         "\(folderBase)/bottom.png",
                         "\(folderBase)/badge.png")
        } catch {
            throw CLI.Error(message: "Failed to clean up temporary files")
        }
    }
}

extension String {
    // Add ability to converst a hexa string to UIcolor
    var hexColor: NSColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let alpha, red, green, blue: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return NSColor(red: CGFloat(red) / 255,
                       green: CGFloat(green) / 255,
                       blue: CGFloat(blue) / 255,
                       alpha: CGFloat(alpha) / 255)
    }
}
