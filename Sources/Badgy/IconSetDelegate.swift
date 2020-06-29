//
//  Badgy
//
//  Created by Arthur Alves on 01/06/2020.
//

import Foundation
import PathKit

typealias ImageInfo = (image: Path, size: ImageSize)
typealias IconSetImages = (largest: ImageInfo, remaining: [ImageInfo])

protocol IconSetDelegate {
    var iconSetImages: IconSetImages? { get set }
    func isIconSet(_ path: Path) -> Bool
    func iconSetImages(for path: Path) -> IconSetImages
}

extension IconSetDelegate {
    func isIconSet(_ path: Path) -> Bool {
        return path.isDirectory && path.lastComponent.contains(".appiconset")
    }
    
    func iconSetImages(for iconset: Path) -> IconSetImages {
        guard iconset.exists, iconset.isDirectory else {
            Logger.shared.logError("❌ ", item: "Specified .appiconset doesn't exist or isn't a directory")
            exit(1)
        }
        
        var remainingImageInfo: [ImageInfo] = []
        
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: iconset.absolute().description)
        enumerator?.allObjects.compactMap { $0 as? String }.forEach({ (item) in
            let path = Path("\(iconset.absolute())/\(item)")
            if
                [".png", ".jpg", ".jpeg"].contains(where: { path.lastComponent.contains($0) }),
                path.exists,
                let size = imageSize(from: path) {
                
                let info = (image: path, size: size)
                remainingImageInfo.append(info)
            }
        })
        
        let largest = remainingImageInfo.reduce(remainingImageInfo.first) {
            if let left = $0, left.size.width > $1.size.width {
                return $0
            } else {
                return $1
            }
        }
        
        return (
            largest: largest ?? (image: iconset, size: ImageSize(width: 0, height: 0)),
            remaining: remainingImageInfo
        )
    }
    
    private func imageSize(from imagePath: Path) -> ImageSize? {
        do {
            let result = try Bash("identify", "-format", "{\"width\":%[fx:w],\"height\":%[fx:h]}", imagePath.absolute().description).run()

            guard let data = result?.data(using: .utf8) else { return nil }
            let jsonDecoder = JSONDecoder()
            let imageSize: ImageSize = try jsonDecoder.decode(ImageSize.self, from: data)
            return imageSize
        } catch {
            Logger.shared.logDebug("Warning: ",
                                   item: "Failed to capture size for image: \(imagePath)",
                                   color: .purple)
        }
        return nil
    }
}
