//
//  Token.swift
//  Argue
//
//  Created by Brandon Evans on 2014-10-10.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

public enum Token: Equatable {
    /// Must have exactly two preceding hyphens followed by at least one character
    case longIdentifier(String)
    /// Must have exactly one preceding hyphen followed by exactly one character
    case shortIdentifier(Character)
    /// All other cases
    case parameter(String)

    public init(_ input: String) {
        if input.hasPrefix("---") {
            self = .parameter(input)
        }
        else if input.hasPrefix("--"), input.characters.count > 2 {
            self = .longIdentifier(input.substring(with: input.index(input.startIndex, offsetBy: 2)..<input.endIndex))
        }
        else if input.hasPrefix("-"), input.characters.count == 2, let identifierCharacter = input.characters.last, identifierCharacter != Character("-") {
            self = .shortIdentifier(identifierCharacter)
        }
        else {
            self = .parameter(input)
        }
    }

    func unwrap() -> String {
        switch self {
        case .longIdentifier(let longName):
            return longName
        case .shortIdentifier(let shortName):
            return String(shortName)
        case .parameter(let parameter):
            return parameter
        }
    }
}

public func ==(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case let (.longIdentifier(l), .longIdentifier(r)): return l == r
    case let (.shortIdentifier(l), .shortIdentifier(r)): return l == r
    case let (.parameter(l), .parameter(r)): return l == r
    default: return false
    }
}
