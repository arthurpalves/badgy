//
// IconSet.swift
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
        guard path.isDirectory, path.extension == setExtension else {
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
