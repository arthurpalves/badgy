//
// IconSetDelegate.swift
// Badgy
//
// MIT License
//
// Copyright (c) 2020 Arthur Alves
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import PathKit
import SwiftCLI

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
        enumerator?.allObjects.compactMap { $0 as? String }.forEach { item in
            let path = Path("\(iconset.absolute())/\(item)")
            if
                [".png", ".jpg", ".jpeg"].contains(where: { path.lastComponent.contains($0) }),
                path.exists,
                let size = imageSize(from: path) {
                let info = (image: path, size: size)
                remainingImageInfo.append(info)
            }
        }

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
            let result = try Task.capture("identify", arguments: ["-format", "{\"width\":%[fx:w],\"height\":%[fx:h]}", imagePath.absolute().description])

            guard let data = result.stdout.data(using: .utf8) else { return nil }
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
