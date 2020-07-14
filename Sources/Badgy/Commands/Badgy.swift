//
// Badgy.swift
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

struct Badgy: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A command-line tool to add labels to your app icon",
        version: "0.1.4",
        subcommands: [Long.self, Small.self],
        defaultSubcommand: Long.self
    )
}

extension Badgy {
    struct Options: ParsableArguments {
        @Argument(help: "Specify badge text")
        var label: String

        @Argument(help: "Specify path to icon with format .png | .jpg | .jpeg | .appiconset", transform: Icon.init(path:))
        var icon: Icon

        @Option(help: """
        Specify a valid hex color code in a case insensitive format: '#rrggbb' | '#rrggbbaa'
            or
        Provide a named color: 'snow' | 'snow1' | ...
        Complete list of named colors: https://imagemagick.org/script/color.php#color_names
        (default: randomly selected from \(Factory.colors.joined(separator: " | ")))
        """)
        var color: ColorCode?

        @Option(default: "white", help: """
        Specify a valid hex color code in a case insensitive format: '#rrggbb' | '#rrggbbaa'
            or
        Provide a named color: 'snow' | 'snow1' | ...
        Complete list of named colors: https://imagemagick.org/script/color.php#color_names
        """)
        var tintColor: ColorCode

        @Flag(help: "Indicates Badgy should replace the input icon")
        var replace: Bool

        @Flag(help: "Log tech details for nerds")
        var verbose: Bool

        func validate() throws {
            guard DependencyManager().areDependenciesInstalled() else {
                throw ValidationError("Missing dependencies. Run: 'brew install imagemagick'")
            }

            Logger.shared.verbose = verbose
        }
    }
}

extension Badgy {
    struct Long: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Add rectangular label to app icon"
        )

        @OptionGroup()
        var options: Badgy.Options

        @Option(default: .bottom, help: "Position on which to place the badge. Supported positions:  \(Position.longLabelPositions.formatted())")
        var position: Position

        @Option(default: 0, help: "The rotation angle of the badge in degrees range of -180 ... 180")
        var angle: Int

        func validate() throws {
            guard options.label.count <= 4 else {
                throw ValidationError("Label should contain maximum 4 characters")
            }

            guard position.isValidForLongLabels else {
                throw ValidationError("Invalid provided position, supported positions are: \(Position.longLabelPositions.formatted())")
            }

            let validAngleRange = -180 ... 180
            guard validAngleRange.contains(angle) else {
                throw ValidationError("Angle should be within range: \(validAngleRange)")
            }
        }

        func run() throws {
            Logger.shared.logSection("$ ", item: "badgy long \"\(options.label)\" \"\(options.icon.path)\"", color: .ios)

            var pipeline = IconSignPipeline.make(withOptions: options)
            pipeline.position = position
            pipeline.angle = angle

            try pipeline.execute()
        }
    }
}

extension Badgy {
    struct Small: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Add small square label to app icon"
        )

        @OptionGroup()
        var options: Badgy.Options

        @Option(default: .bottomLeft, help: "Position on which to place the badge. Supported positions: \(Position.allCases.formatted())")
        var position: Position

        func validate() throws {
            guard options.label.count <= 1 else {
                throw ValidationError("Label should contain maximum 1 character")
            }
        }

        func run() throws {
            Logger.shared.logSection("$ ", item: "badgy small \"\(options.label)\" \"\(options.icon.path)\"", color: .ios)

            var pipeline = IconSignPipeline.make(withOptions: options)
            pipeline.position = position

            try pipeline.execute()
        }
    }
}

extension Position: ExpressibleByArgument {}

private extension IconSignPipeline {
    static func make(withOptions options: Badgy.Options) -> IconSignPipeline {
        var pipeline = IconSignPipeline(icon: options.icon, label: options.label)

        pipeline.color = options.color?.value
        pipeline.tintColor = options.tintColor.value
        pipeline.replace = options.replace

        return pipeline
    }
}

private extension Position {
    static let longLabelPositions: Set<Position> = Set([
        .top, .left, .bottom, .right, .center
    ])

    var isValidForLongLabels: Bool {
        Position.longLabelPositions.contains(self)
    }
}
