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
                   tintColorHexCode: String? = nil,
                   angle: Int? = nil,
                   inFolder folder: Path,
                   completion: @escaping BadgeProductionResponse) throws {
        
        let color = colorHexCode ?? colors.randomElement()!
        let tintColor = tintColorHexCode ?? "white"
        
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
                "-fill", "\(tintColor)",
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
                     position: Position?, completion: @escaping BadgeProductionResponse) throws {
        let position = position ?? .bottom
        
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
            let icons = [
                folder + Path("top.png"),
                folder + Path("bottom.png"),
                folder + Path("badge.png")
            ]
            
            for icon in icons {
                try icon.delete()
            }
        } catch {
            throw CLI.Error(message: "Failed to clean up temporary files")
        }
    }
}
