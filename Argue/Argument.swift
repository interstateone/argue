//
//  Argument.swift
//  Remind
//
//  Created by Brandon Evans on 2014-08-19.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

public enum ArgumentType {
    case Option
    case Flag
}

public class Argument: Printable {
    let fullName: String
    let shortName: Character
    let desc: String
    let type: ArgumentType
    private var _value: AnyObject?
    public var value: AnyObject? {
        get {
            return _value
        }
        set {
            var token: dispatch_once_t = 0
            dispatch_once(&token) {
                self._value = newValue
            }
        }
    }

    public init(type: ArgumentType, fullName: String, shortName: Character, description: String) {
        self.fullName = fullName
        self.shortName = shortName
        self.desc = description
        self.type = type
    }

    public func matchesToken(token: Token) -> Bool {
        var result: Bool = false
        switch token {
        case .LongIdentifier(let longName):
            result = self.fullName == longName
        case .ShortIdentifier(let shortName):
            result = self.shortName == shortName
        case .Parameter(let parameter):
            result = false
        }
        return result
    }
    public var description: String {
        return "--\(fullName)\t(-\(shortName))\t\(desc)"
    }
}

extension Argument: Equatable {}

public func ==(lhs: Argument, rhs: Argument) -> Bool {
        return lhs.fullName == rhs.fullName
}

extension Argument: Hashable {
    public var hashValue: Int {
        get {
            return fullName.hashValue
        }
    }
}