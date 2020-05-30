import SwiftCLI

let cli = CLI(
    name: "badgy",
    version: "0.1.0",
    description: "A command-line tool to add labels to your app icon"
)

cli.commands = [
    Small(),
    Long()
]

cli.globalOptions.append(VerboseFlag)

_ = cli.go()
