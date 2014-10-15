//
//  Argue.swift
//  Remind
//
//  Created by Brandon Evans on 2014-08-19.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import Cocoa

extension String {
    /// Returns the substring in the given range
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)

            return self[Range(start: startIndex, end: endIndex)]
        }
    }

    /// Returns the character at the given index
    subscript (i: Int) -> Character {
        get {
            let index = advance(self.startIndex, i)
            return self[index]
        }
    }
}

/**
Append an element to an array without mutating the lhs

:param: lhs Array
:param: rhs New element

:returns: New array
*/
func +<T>(lhs: [T], rhs: T) -> [T] {
    var a = lhs
    a.append(rhs)
    return a
}

public class Argue: NSObject, Printable {
    /// User-facing usage description
    let usage: String

    /// The arguments made available to users
    let arguments: [Argument]

    /// An automatically generated argument to show the usage guide
    public let helpArgument = Argument(type: .Flag, fullName: "help", shortName: "h", description: "Show usage instructions")

    public init(usage: String, arguments: [Argument]) {
        self.usage = usage
        self.arguments = arguments + helpArgument
        super.init()
    }

    /// The usage guide for this command
    public override var description: String {
        return arguments.reduce("\(usage)\n\nArguments:\n") { (usage, argument) -> String in
            return usage + "\(argument.description)\n"
        }
    }

    /**
    Parses argument input into argument values. Currently handles 0 or 1 parameters

    :param: argumentStrings Argument strings, probably from the command line

    :returns: An error if there was an issue parsing an argument
    */
    public func parseArguments(argumentStrings: [String]) -> NSError? {
        let tokens = argumentStrings.map { Token(input: $0) }
        var tokenGenerator = tokens.generate()
        var currentArgument: Argument?
        var currentParameters: [AnyObject] = []

        func parseArgument(input: Streamable, token: Token) -> NSError? {
            if let argument = argumentForToken(token) {
                if let currentArgument = currentArgument {
                    switch currentArgument.type {
                    case .Flag:
                        currentArgument.value = true
                    case .Option:
                        currentArgument.value = currentParameters.count == 1 ? currentParameters.first : currentParameters
                    }
                    currentParameters = []
                }

                currentArgument = argument
            }
            else {
                return NSError(domain: "ca.brandonevans.Argue", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error parsing argument \"\(input)\""])
            }

            return nil
        }

        while let token = tokenGenerator.next() {
            switch token {
            case .LongIdentifier(let longInput):
                if let error = parseArgument(longInput, token) {
                    return error
                }
            case .ShortIdentifier(let shortInput):
                if let error = parseArgument(shortInput, token) {
                    return error
                }
            case .Parameter(let parameter):
                currentParameters.append(parameter)
            }
        }

        if let currentArgument = currentArgument {
            switch currentArgument.type {
            case .Flag:
                currentArgument.value = true
            case .Option:
                currentArgument.value = currentParameters.count == 1 ? currentParameters.first : currentParameters
            }
            currentParameters = []
        }

        return nil
    }

    /**
    Convenience function for what parseArguments will almost always be used for

    :returns: An error if there was an issue parsing an argument
    */
    public func parse() -> NSError? {
        // Ignore the application path
        var args = Process.arguments
        if countElements(args) > 0 {
            args.removeAtIndex(0)
        }
        return parseArguments(args)
    }

    /**
    Finds the argument, if there is one, that matches a given input string

    :param: argumentString The input string

    :returns: The matching argument
    */
    private func argumentForToken(token: Token) -> Argument? {
        let argument = arguments.filter({ $0.matchesToken(token) }).first
        return argument
    }
}