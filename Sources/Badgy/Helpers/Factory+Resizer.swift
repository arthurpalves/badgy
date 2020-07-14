//
// Factory+Resizer.swift
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

struct ImageSize: Codable {
    let width: Int
    let height: Int

    func description() -> String {
        return "\(width)x\(height)"
    }
}

extension Factory {
    func resize(filename: Path) {
        let sizes = [20, 29, 40, 50, 57, 58, 60, 72, 76, 80, 87, 100, 114, 120, 144, 152, 180, 167, 180]
        let bareFilename = Path("\(filename.parent())/\(filename.lastComponentWithoutExtension)")
        sizes.forEach {
            let size = "\($0)x\($0)"
            Logger.shared.logInfo("Resizing to: ", item: size, color: .purple)
            do {
                try Task.run(
                    "convert", filename.absolute().description,
                    "-resize", size,
                    "\(bareFilename)_\($0).png"
                )
            } catch {
                Logger.shared.logError("❌ ", item: "Failed to resize icon to \(size)", color: .red)
            }
        }
    }

    func replace(_ iconSet: IconSetImages, with newBadgeFile: Path) {
        iconSet.remaining
            .forEach { info in
                Logger.shared.logInfo("Replacing: ", item: info.image, color: .purple)
                do {
                    try Task.run(
                        "convert", newBadgeFile.absolute().description,
                        "-resize", info.size.description(),
                        info.image.absolute().description
                    )
                } catch {
                    Logger.shared.logError("❌ ",
                                           item: "Failed to replace \(info.image)")
                }
            }
    }
}
