//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import Foundation
import SwiftCLI
import PathKit

extension Factory {
    func makeSmall(with label: String,
                    colorHexCode: String? = nil,
                    tintColorHexCode: String? = nil,
                    inFolder folder: Path,
                    completion: @escaping BadgeProductionResponse) {
        
        let color = colorHexCode ?? colors.randomElement()!
        let tintColor = tintColorHexCode ?? "white"
        
        do {
            let folderBase = folder.absolute().description
            if !folder.isDirectory {
                try Task.run("mkdir", folderBase)
            }
            
            try Task.run(
                "convert", "-size", "260x",
                "-background", color,
                "-gravity", "Center",
                "-weight","700",
                "-pointsize", "50",
                "-fill", color,
                "caption:'-'",
                "\(folderBase)/top.png"
            )
            
            try Task.run(
                "convert", "-size", "260x",
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
            try completion(.success("\(folderBase)/badge.png"))
            
        } catch let error {
            print("FAILED: \(error.localizedDescription)")
            try? completion(.failure(error))
        }
    }
}
