import SwiftCLI

let cli = CLI(name: "sandbox")
cli.commands = [
    ExampleCommand()
]
cli.go()
