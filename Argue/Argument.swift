//
//  Argument.swift
//  Remind
//
//  Created by Brandon Evans on 2014-08-19.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import Foundation

public enum ArgumentType {
    case value
    case flag
}

public class Argument: CustomStringConvertible, Equatable, Hashable {
    public let fullName: String
    public let shortName: Character
    public let desc: String
    public let type: ArgumentType
    public private(set) var value: Any?

    public init(type: ArgumentType, fullName: String, shortName: Character, description: String) {
        self.fullName = fullName
        self.shortName = shortName
        self.desc = description
        self.type = type
    }

    public func setValue(_ value: Any?) {
        self.value = value
    }

    public func matchesToken(_ token: Token) -> Bool {
        var result: Bool = false
        switch token {
        case .longIdentifier(let longName):
            result = self.fullName == longName
        case .shortIdentifier(let shortName):
            result = self.shortName == shortName
        case .parameter:
            result = false
        }
        return result
    }

    public var description: String {
        return "--\(fullName)\t(-\(shortName))\t\(desc)"
    }

    public var hashValue: Int {
        return fullName.hashValue
    }
}

public func ==(lhs: Argument, rhs: Argument) -> Bool {
    return lhs.fullName == rhs.fullName
}
