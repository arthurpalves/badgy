//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import Foundation
import PathKit

extension Factory {
    func makeSmall(with label: String,
                    colorHexCode: String? = nil,
                    tintColorHexCode: String? = nil,
                    inFolder folder: Path) throws -> String {
        
        let color = colorHexCode ?? Factory.colors.randomElement()!
        let tintColor = tintColorHexCode ?? "white"
        
        do {
            let folderBase = folder.absolute().description
            if !folder.isDirectory {
                try Bash("mkdir", folderBase).run()
            }
            
            try Bash(
                "convert", "-size", "260x",
                "-background", color,
                "-gravity", "Center",
                "-weight","700",
                "-pointsize", "50",
                "-fill", color,
                "caption:'-'",
                "\(folderBase)/top.png"
            ).run()
            
            try Bash(
                "convert", "-size", "260x",
                "-background", color,
                "-gravity", "Center",
                "-weight","700",
                "-pointsize", "180",
                "-fill", "\(tintColor)",
                "caption:\(label)",
                "\(folderBase)/bottom.png"
            ).run()
            
            try Bash(
                "convert", "\(folderBase)/top.png", "\(folderBase)/bottom.png",
                "-append", "\(folderBase)/badge.png"
            ).run()
            
            return "\(folderBase)/badge.png"
        } catch {
            print("FAILED: \(error.localizedDescription)")
            throw error
        }
    }
}
