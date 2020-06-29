//
//  Badgy
//

import Foundation
import PathKit

struct IconSet {
    typealias ImageInfo = (image: Path, size: ImageSize)
    
    let path: Path
    let images: [ImageInfo]
    
    func largest() -> Path? {
        images.max { lhs, rhs in lhs.size.width < rhs.size.width }.flatMap { $0.image }
    }
}

extension IconSet {
    static let setExtension = "appiconset"
    static let imageExtensions = Set(["png", "jpg", "jpeg"])

    static func makeFromFolder(at path: Path) -> IconSet? {
        guard path.isDirectory && path.extension == setExtension else {
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
        
        return IconSet(path: path, images: images)
    }
}

private extension ImageSize {
    static func makeFromImage(at imagePath: Path) -> ImageSize? {
        guard IconSet.imageExtensions.contains(imagePath.extension ?? "") else {
            return nil
        }
        
        do {
            let result = try Bash(
                "identify",
                "-format", "{\"width\":%[fx:w],\"height\":%[fx:h]}",
                imagePath.absolute().description
            ).run()
        
            guard let data = result?.data(using: .utf8) else {
                throw RuntimeError("Failed to get image size")
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
