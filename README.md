Argue
=====

A really basic command-line argument parser in Swift

## Usage

```swift
let listArgument = Argument(fullName: "list", shortName: "l", description:
"Prints only the reminders in the given list or creates a new reminder there",
isFlag: false)
let newArgument = Argument(fullName: "new", shortName: "n", description:
"Creates a new reminder", isFlag: false)
let usage = "A little app to quickly deal with reminders."
let argue = Argue(usage: usage, arguments: [newArgument, listArgument])

let error = argue.parse()
if error != nil {
    println("Error parsing arguments: \(error?.localizedDescription)")
    exit(1)
}

if argue.helpArgument.value != nil {
    exit(0)
}

if let title = newArgument.value as? String {
    // do some magic
}
```

