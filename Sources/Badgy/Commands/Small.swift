//
// Small.swift
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

final class Small: DependencyManager, Command, IconSetDelegate {
    // --------------

    // MARK: Command information

    let name: String = "small"
    let shortDescription: String = "Add small square label to app icon"

    // --------------

    // MARK: Configuration Properties

    @Param(validation: Validation<String>.custom("This parameter should be 1 char only.") {
        input in input.count == 1
    })
    var char: String

    @Param(validation: Validation<String>
        .custom("Specify valid icon with format .png | .jpg | .appiconset") {
            input in

            let path = Path(input)
            let formats = [".png", ".jpg", ".jpeg", ".appiconset"]

            guard path.exists, formats.contains(where: { path.lastComponent.contains($0) })
                else {
                    Logger.shared.logError("❌ ",
                                           item: "Input file doesn't exist or doesn't have a valid format")
                    return false
            }
            return true
        })
    var icon: String

    @Key("-p", "--position",
         description: "Position on which to place the badge",
         validation: [Validation.allowing(Position.top.rawValue, Position.left.rawValue,
                                          Position.bottom.rawValue, Position.right.rawValue,
                                          Position.topLeft.rawValue, Position.topRight.rawValue,
                                          Position.bottomLeft.rawValue, Position.bottomRight.rawValue,
                                          Position.center.rawValue)])
    var position: String?

    @Key("-c", "--color",
         description: "Specify badge color with a hexadecimal color code or a named color",
         validation: [Validation.colorCode()])
    var color: String?

    @Key("-t", "--tint-color",
         description: "Specify badge text/tint color with a hexadecimal color code or a named color",
         validation: [Validation.colorCode()])
    var tintColor: String?

    let logger = Logger.shared
    let factory = Factory()

    var iconSetImages: IconSetImages?

    public func execute() throws {
        guard areDependenciesInstalled()
            else {
                throw CLI.Error(message: "Missing dependencies. Run: 'brew install imagemagick'")
        }
        logger.logSection("$ ", item: "badgy small \"\(char)\" \"\(icon)\"", color: .ios)

        var baseIcon = icon
        if isIconSet(Path(icon)) {
            logger.logDebug("", item: "Finding the largest image in the .appiconset", color: .purple)

            iconSetImages = iconSetImages(for: Path(icon))

            guard
                let largest = iconSetImages?.largest,
                largest.size.width > 0
                else {
                    logger.logError("❌ ", item: "Couldn't find the largest image in the set")
                    exit(1)
            }
            baseIcon = largest.image.absolute().description
            logger.logDebug("Found: ", item: baseIcon, color: .purple)
        }

        try process(baseIcon: baseIcon)
    }

    private func process(baseIcon: String) throws {
        let folder = Path("Badgy")
        factory.makeSmall(with: char, colorHexCode: color, tintColorHexCode: tintColor, inFolder: folder, completion: { result in
            switch result {
            case .success:
                try self.factory.appendBadge(to: baseIcon,
                                             folder: folder,
                                             label: self.char,
                                             position: Position(rawValue: self.position ?? "bottomLeft")) {
                    result in
                    switch result {
                    case let .success(filename):
                        let filePath = Path(filename)
                        guard filePath.exists
                            else {
                                self.logger.logError("❌ ", item: "Failed to create badge")
                                return
                        }
                        self.logger.logInfo(item: "Icon with badge '\(self.char)' created at '\(filePath.absolute().description)'")
                        try self.factory.cleanUp(folder: folder)

                        if ReplaceFlag.value, let iconSet = self.iconSetImages {
                            self.replace(iconSet: iconSet, with: filePath)
                        } else {
                            self.resize(filePath: filePath)
                        }
                    case let .failure(error):
                        try self.factory.cleanUp(folder: folder)
                        throw CLI.Error(message: error.localizedDescription)
                    }
                }
            case let .failure(error):
                try self.factory.cleanUp(folder: folder)
                throw CLI.Error(message: error.localizedDescription)
            }
        })
    }

    private func resize(filePath: Path) {
        factory.resize(filename: filePath)
    }

    private func replace(iconSet: IconSetImages, with newBadgeFile: Path) {
        factory.replace(iconSet, with: newBadgeFile)
    }
}
