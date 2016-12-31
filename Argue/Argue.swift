//
//  Argue.swift
//  Remind
//
//  Created by Brandon Evans on 2014-08-19.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import Foundation

public class Argue: CustomStringConvertible {
    /// User-facing usage description
    let usage: String

    /// The arguments made available to users
    let arguments: [Argument]

    /// An automatically generated argument to show the usage guide
    public let helpArgument = Argument(type: .flag, fullName: "help", shortName: "h", description: "Show usage instructions")

    public init(usage: String, arguments: [Argument]) {
        self.usage = usage
        self.arguments = arguments + [helpArgument]
    }

    /// The usage guide for this command
    public var description: String {
        return arguments.reduce("\(usage)\n\nArguments:\n") { (usage, argument) -> String in
            return usage + "\(argument.description)\n"
        }
    }

    /**
    Parses argument input into argument values. Currently handles 0 or 1 parameters

    :param: argumentStrings Argument strings, probably from the command line

    :returns: An error if there was an issue parsing an argument
    */
    public func parseArguments(_ arguments: [String]) throws {
        parseTokens(from: arguments).forEach { tokenGroup in
            guard
                let firstToken = tokenGroup.first,
                let argument = argumentForToken(firstToken)
            else { return }

            switch argument.type {
            case .flag:
                argument.setValue(true)
            case .value:
                let parameters = tokenGroup[1..<tokenGroup.count].map { $0.unwrap() }
                argument.setValue(parameters.count == 1 ? parameters.first : parameters)
            }
        }
    }

    internal func parseTokens(from arguments: [String]) -> [[Token]] {
        return arguments.map(Token.init).reduce([[Token]]()) { groups, token in
            switch token {
            case .longIdentifier, .shortIdentifier:
                return groups + [[token]]
            case .parameter:
                var lastGroup = groups.last ?? []
                lastGroup += [token]
                return groups[0..<(groups.count - 1)] + [lastGroup]
            }
        }
    }

    /**
    Convenience function for what parseArguments will almost always be used for

    :returns: An error if there was an issue parsing an argument
    */
    public func parse() throws {
        // Ignore the application path
        var args = CommandLine.arguments
        if args.count > 0 {
            args.remove(at: 0)
        }
        try parseArguments(args)
    }

    /**
    Finds the argument, if there is one, that matches a given input string

    :param: argumentString The input string

    :returns: The matching argument
    */
    private func argumentForToken(_ token: Token) -> Argument? {
        return arguments.filter({ $0.matchesToken(token) }).first
    }
}
