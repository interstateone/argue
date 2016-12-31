Argue
=====

[![CircleCI](https://circleci.com/gh/interstateone/argue.svg?style=svg)](https://circleci.com/gh/interstateone/argue)

A really basic command-line argument parser in Swift. It currently supports values (takes single parameters or arrays of them) and flags (booleans).

Argue is used in [remind](https://github.com/interstateone/remind), a Swift CLI app to quickly deal with your reminders.

## Installation

### Swift Package Manager

Add argue to the dependencies array in your Package.swift.

```
dependencies: [
    .Package(url: "https://github.com/interstateone/argue.git", majorVersion: 2)
]
```

### Git Submodules

`git add submodule https://github.com/interstateone/argue.git`

Note that as of Xcode 8 "Xcode does not support building static libraries that include Swift code. (17181019)". If you're creating a command line tool you'll need to use a static library instead of a framework, and that's not possible yet. Instead, as a workaround, just throw the source files into your project.

## Usage

```swift
let listArgument = Argument(type: .value, fullName: "list", shortName: "l", description: "Prints only the reminders in the given list or creates a new reminder there")
let newArgument = Argument(type: .value, fullName: "new", shortName: "n", description: "Creates a new reminder")
let usage = "A little app to quickly deal with reminders."
let argue = Argue(usage: usage, arguments: [newArgument, listArgument])

do {
    try argue.parse()
}
catch {
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
