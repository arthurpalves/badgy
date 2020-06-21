//
//  Badgy
//

import Foundation
import ArgumentParser
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
        @Argument(help :"Specify badge text")
        var label: String
        
        @Argument(help :"Specify path to icon with format .png | .jpg | .appiconset", transform: IconPath.init(path:))
        var icon: IconPath
        
        @Option(help: "Position on which to place the badge")
        var position: Position?
        
        @Option(help: "Specify badge color with a hexadecimal color code format '#rrbbgg' | '#rrbbggaa' or a named color format ('red', 'white', etc.)")
        var color: ColorCode?
        
        @Option(help: "Specify badge text/tint color with a hexadecimal color code format ('#rrbbgg' | '#rrbbggaa') or a named color format ('red', 'white', etc.)")
        var tintColor: ColorCode?
        
        @Flag(help: "Indicates Badgy should replace the input icon")
        var replace: Bool
        
        @Flag(help: "Log tech details for nerds")
        var verbose: Bool
        
        func validate() throws {
            guard DependencyManager().areDependenciesInstalled() else {
                throw ValidationError("Missing dependencies. Run: 'brew install imagemagick'")
            }
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
        
        @Option(help: "Rotation angle of the badge")
        var angle: Int?
        
        func validate() throws {
            guard options.label.count <= 4 else {
                throw ValidationError("Label should contain maximum 4 characters")
            }
            
            if let position = options.position {
                let supportedPositions: [Position] = [
                    .top, .left, .bottom, .right, .center
                ]
                guard supportedPositions.contains(position) else {
                    let formatted = supportedPositions
                        .map { $0.rawValue }
                        .joined(separator: " | ")
                    
                    throw ValidationError("Invalid provided position, supported positions are: \(formatted)")
                }
            }
            
            let validAngleRange = -180...180
            if let angle = angle {
                guard validAngleRange.contains(angle) else {
                    throw ValidationError("Angle should be within range: \(validAngleRange)")
                }
            }
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
        
        func validate() throws {
            guard options.label.count <= 1 else {
                throw ValidationError("Label should contain maximum 1 characters")
            }
        }
    }
}

extension Position: ExpressibleByArgument { }

struct IconPath {
    static let supportedFormats = Set([
        ".png", ".jpg", ".jpeg", ".appiconset"
    ])
    
    let path: Path
    
    init(path: String) throws {
        let path = Path(path)
        
        guard path.exists else {
            throw ValidationError("Input file doesn't exist")
        }
        
        let isSupportedFormat = IconPath.supportedFormats.contains {
            path.lastComponent.contains($0)
        }
        guard isSupportedFormat else {
            throw ValidationError("Input file doesn't have a valid format")
        }
        
        self.path = path
    }
}
