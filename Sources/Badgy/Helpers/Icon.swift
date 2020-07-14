//
// Icon.swift
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

import ArgumentParser
import Foundation
import PathKit

enum Icon {
    case plain(Path)
    case set(IconSet)

    init(path: String) throws {
        let path = Path(path)

        guard path.exists else {
            let message = "Input file or directory doesn't exist"
            Logger.shared.logError("❌ ", item: message)
            throw ValidationError(message)
        }

        if let set = IconSet.makeFromFolder(at: path) {
            self = .set(set)
            return
        }

        if IconSet.imageExtensions.contains(path.extension ?? "") {
            self = .plain(path)
            return
        }

        let message = "Input file or directory doesn't have a valid format"
        Logger.shared.logError("❌ ", item: message)
        throw ValidationError(message)
    }
}

extension Icon {
    var path: Path {
        switch self {
        case let .plain(path): return path
        case let .set(set): return set.path
        }
    }
}
