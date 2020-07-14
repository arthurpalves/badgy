//
// Factory.swift
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

import AppKit
import PathKit
import SwiftCLI

typealias BadgeProductionResponse = ((Result<String, Error>) throws -> Void)

struct Factory {
    static let colors = ["#EE6D6D", "#A36DEE", "#4C967E", "#3B8A4B", "#CABA0E", "#E68C31", "#E11818"]

    func makeBadge(with label: String,
                   colorHexCode: String? = nil,
                   tintColorHexCode: String? = nil,
                   angle: Int? = nil,
                   inFolder folder: Path) throws -> String {
        do {
            let color = colorHexCode ?? Factory.colors.randomElement()!
            let tintColor = tintColorHexCode ?? "white"

            let folderBase = folder.absolute().description
            if !folder.isDirectory {
                try Task.run("mkdir", folderBase)
            }

            try Task.run(
                "convert", "-size", "1520x",
                "-background", color,
                "-gravity", "Center",
                "-weight", "700",
                "-pointsize", "50",
                "-fill", color,
                "caption:'-'",
                "\(folderBase)/top.png"
            )

            try Task.run(
                "convert", "-size", "1520x",
                "-background", color,
                "-gravity", "Center",
                "-weight", "700",
                "-pointsize", "180",
                "-fill", "\(tintColor)",
                "caption:\(label)",
                "\(folderBase)/bottom.png"
            )

            try Task.run(
                "convert", "\(folderBase)/top.png", "\(folderBase)/bottom.png",
                "-append", "\(folderBase)/badge.png"
            )

            if let angle = angle {
                try Task.run(
                    "convert", "\(folderBase)/badge.png",
                    "-background", "transparent",
                    "-rotate", "\(angle)",
                    "\(folderBase)/badge.png"
                )
            }

            return "\(folderBase)/badge.png"
        } catch {
            print("FAILED: \(error.localizedDescription)")
            throw error
        }
    }

    func appendBadge(to baseIcon: String,
                     folder: Path,
                     label: String,
                     position: Position?) throws -> String {
        let position = position ?? .bottom

        let folderBase = folder.absolute().description
        let finalFilename = "\(folderBase)/\(label).png"

        try Task.run(
            "convert", baseIcon,
            "-resize", "1024x",
            finalFilename
        )

        try Task.run(
            "convert", "-composite",
            "-gravity", "\(position.cardinal)",
            finalFilename, "\(folderBase)/badge.png",
            finalFilename
        )

        return finalFilename
    }

    func cleanUp(folder: Path) throws {
        do {
            let icons = [
                folder + Path("top.png"),
                folder + Path("bottom.png"),
                folder + Path("badge.png")
            ]

            for icon in icons {
                try icon.delete()
            }
        } catch {
            throw CLI.Error(message: "Failed to clean up temporary files")
        }
    }
}
