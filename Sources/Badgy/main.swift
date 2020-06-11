import SwiftCLI

let ReplaceFlag = Flag("-r", "--replace", description: "Indicates Badgy should replace the input icon")

let cli = CLI(
    name: "badgy",
    version: "0.1.4",
    description: "A command-line tool to add labels to your app icon"
)

cli.commands = [
    Small(),
    Long()
]

cli.globalOptions.append(ReplaceFlag)
cli.globalOptions.append(VerboseFlag)

_ = cli.go()
