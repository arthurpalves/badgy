//
// Validation+HexColor.swift
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
import SwiftCLI

extension Validation where T == String {
    /// Checks whether the `input` matches '#rrbbgg' | '#rrbbggaa' color formats
    static func isHexColor(_ input: String) -> Bool {
        NSRegularExpression.hexColorCode.matches(input)
    }
}

private extension NSRegularExpression {
    /// Regular expression that matches '#rrbbgg' and '#rrbbggaa' formats
    ///
    /// `^` asserts position at start of a line
    /// `#` matches the character # literally
    ///
    /// `(:?[0-9a-fA-F]{2})`
    /// - `(:?)` denotes a non-capturing group
    /// - `[0-9a-fA-F]` match a single character present in the list below
    /// - `{2}` - matches exactly 2 times
    ///
    /// `{3,4}` - matches between 3 and 4 times, as many times as possible
    ///
    /// Additional explanation at [regex101](https://regex101.com/)
    static let hexColorCode = NSRegularExpression("^#(?:[0-9a-fA-F]{2}){3,4}$")
}
