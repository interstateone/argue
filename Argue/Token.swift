//
//  Token.swift
//  Argue
//
//  Created by Brandon Evans on 2014-10-10.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

public enum Token {
    case LongIdentifier(String)
    case ShortIdentifier(Character)
    case Parameter(AnyObject)

    public init(input: String) {
        let inputLength = countElements(input)

        if input.hasPrefix("---") {
            self = .Parameter(input)
        }
        else if input.hasPrefix("--") {
            self = .LongIdentifier(input[2..<inputLength])
        }
        else if input.hasPrefix("-") {
            self = .ShortIdentifier(input[1])
        }
        else {
            self = .Parameter(input)
        }
    }

    public init(input: Bool) {
        self = .Parameter(input)
    }

    func unwrap() -> [AnyObject] {
        switch self {
        case .LongIdentifier(let longName):
            return [longName]
        case .ShortIdentifier(let shortName):
            return [String(shortName)]
        case .Parameter(let parameter):
            return [parameter]
        }
    }
}