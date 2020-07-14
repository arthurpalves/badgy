//
// IconSignPipeline.swift
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

struct IconSignPipeline {
    struct Error: Swift.Error {
        var message: String
    }

    var icon: Icon
    var label: String

    var position: Position?
    var color: String?
    var tintColor: String?
    var angle: Int? = nil
    var replace: Bool = false

    let logger = Logger.shared
    let factory = Factory()
    let folder = Path("Badgy")

    func execute() throws {
        defer { cleanUp() }

        let baseIcon = try icon.base()
        try makeBadge()
        let signedIcon = try appendBadge(to: baseIcon)
        postprocess(signedIcon)
    }

    private func makeBadge() throws {
        _ = try factory.makeBadge(
            with: label,
            colorHexCode: color,
            tintColorHexCode: tintColor,
            angle: angle,
            inFolder: folder
        )
    }

    private func appendBadge(to icon: Path) throws -> Path {
        let signedIconFilename = try factory.appendBadge(
            to: icon.absolute().description,
            folder: folder,
            label: label,
            position: position
        )

        let signedIcon = Path(signedIconFilename)
        guard signedIcon.exists else {
            logger.logError("❌ ", item: "Failed to create badge")
            throw IconSignPipeline.Error(message: "Failed to create badge")
        }

        logger.logInfo(item: "Icon with badge '\(label)' created at '\(signedIcon.absolute().description)'")

        return signedIcon
    }

    private func postprocess(_ signedIcon: Path) {
        if replace, case let .set(iconSet) = icon {
            factory.replace(iconSet, with: signedIcon)
        } else {
            factory.resize(filename: signedIcon)
        }
    }

    private func cleanUp() {
        try? factory.cleanUp(folder: folder)
    }
}

private extension Icon {
    func base() throws -> Path {
        switch self {
        case let .plain(path):
            return path
        case let .set(set):
            Logger.shared.logDebug("", item: "Finding the largest image in the .appiconset", color: .purple)

            guard let path = set.largest() else {
                Logger.shared.logError("❌ ", item: "Couldn't find the largest image in the set")
                throw IconSignPipeline.Error(message: "Couldn't find the largest image in the set")
            }

            Logger.shared.logDebug("Found: ", item: path, color: .purple)
            return path
        }
    }
}
