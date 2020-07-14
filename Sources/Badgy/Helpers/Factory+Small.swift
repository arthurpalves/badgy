//
// Factory+Small.swift
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
                "-weight", "700",
                "-pointsize", "50",
                "-fill", color,
                "caption:'-'",
                "\(folderBase)/top.png"
            )

            try Task.run(
                "convert", "-size", "260x",
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
            try completion(.success("\(folderBase)/badge.png"))

        } catch {
            print("FAILED: \(error.localizedDescription)")
            try? completion(.failure(error))
        }
    }
}
