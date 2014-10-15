Argue
=====

A really basic command-line argument parser in Swift.

Argue is used in [Remind](https://github.com/interstateone/Remind), a Swift CLI app to quickly deal with your reminders.

## Installation

Install as a submodule with `git add submodule
https://github.com/interstateone/Argue.git`.

Note that as of Xcode 6.1 beta 2 "Xcode does not support building static libraries
that include Swift code. (17181019)". If you're creating a command line tool
you'll need to use a static library instead of a framework, and that's not
possible yet. Instead, as a workaround, just throw the source files into your
project.

## Usage

```swift
let listArgument = Argument(type: .Option, fullName: "list", shortName: "l", description:
"Prints only the reminders in the given list or creates a new reminder there")
let newArgument = Argument(type: .Option, fullName: "new", shortName: "n", description:
"Creates a new reminder")
let usage = "A little app to quickly deal with reminders."
let argue = Argue(usage: usage, arguments: [newArgument, listArgument])

if let error = argue.parse() {
    println("Error parsing arguments: \(error.localizedDescription)")
    exit(1)
}

if argue.helpArgument.value != nil {
    println(argue.description)
    exit(0)
}

if let title = newArgument.value as? String {
    // do some magic
}
```
