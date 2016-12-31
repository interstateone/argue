//
//  Token.swift
//  Argue
//
//  Created by Brandon Evans on 2014-10-10.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

public enum Token {
    case longIdentifier(String)
    case shortIdentifier(Character)
    case parameter(Any)

    public init(input: String) {
        if input.hasPrefix("---") {
            self = .parameter(input as Any)
        }
        else if input.hasPrefix("--") {
            self = .longIdentifier(input.substring(with: input.index(input.startIndex, offsetBy: 2)..<input.endIndex))
        }
        else if input.hasPrefix("-"), let trailingCharacter = input.substring(with: input.index(input.startIndex, offsetBy: 1)..<input.endIndex).characters.first {
            self = .shortIdentifier(trailingCharacter)
        }
        else {
            self = .parameter(input)
        }
    }

    public init(input: Bool) {
        self = .parameter(input as Any)
    }

    func unwrap() -> Any {
        switch self {
        case .longIdentifier(let longName):
            return longName
        case .shortIdentifier(let shortName):
            return shortName
        case .parameter(let parameter):
            return parameter
        }
    }
}
