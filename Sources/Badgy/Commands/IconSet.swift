//
//  Badgy
//

import Foundation
import PathKit
import SwiftCLI

struct IconSet {
    typealias ImageInfo = (image: Path, size: ImageSize)
    
    var images: [ImageInfo]
    
    func largest() -> Path? {
        images.max { lhs, rhs in lhs.size.width < rhs.size.width }.flatMap { $0.image }
    }
}

extension IconSet {
    static let setExtension = ".appiconset"
    static let imageExtensions = Set([".png", ".jpg", ".jpeg"])

    static func makeFromFolder(at path: Path) -> IconSet? {
        guard path.isDirectory && path.lastComponent.contains(setExtension) else {
            return nil
        }
        
        guard let content = try? path.children() else {
            return nil
        }
        
        let images = content.compactMap { path in
            ImageSize.makeFromImage(at: path).flatMap { size in
                (path, size)
            }
        }
        
        return IconSet(images: images)
    }
}

private extension ImageSize {
    static func makeFromImage(at imagePath: Path) -> ImageSize? {
        guard IconSet.imageExtensions.contains(imagePath.lastComponent) else {
            return nil
        }
        
        do {
            let result = try Task.capture(
                "identify", arguments: [
                    "-format", "{\"width\":%[fx:w],\"height\":%[fx:h]}",
                    imagePath.absolute().description
                ]
            )
        
            guard let data = result.stdout.data(using: .utf8) else {
                throw CLI.Error(message: "Failed to get image size")
            }
            
            return try JSONDecoder().decode(ImageSize.self, from: data)
        } catch {
            Logger.shared.logDebug("Warning: ",
                                   item: "Failed to capture size for image: \(imagePath)",
                                   color: .purple)
            return nil
        }
    }
}
