//
//  Argument.swift
//  Remind
//
//  Created by Brandon Evans on 2014-08-19.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

public class Argument {
    let fullName: String
    let shortName: String
    let description: String
    let isFlag: Bool
    public private(set) var value: AnyObject?
    private var hasRealized: Bool = false

    public init(fullName: String, shortName: String, description: String, isFlag: Bool) {
        self.fullName = fullName
        self.shortName = shortName
        self.description = description
        self.isFlag = isFlag
    }

    public func matchesArgumentName(argumentName: String) -> Bool {
        if argumentName.hasPrefix("---") {
            return false
        }
        else if argumentName.hasPrefix("--") {
            return fullName == argumentName[2..<countElements(argumentName)]
        }
        else if argumentName.hasPrefix("-") {
            let start = argumentName.startIndex
            return shortName == argumentName[1..<countElements(argumentName)]
        }
        return false
    }

    public func usageString() -> String {
        return "--\(fullName)\t(-\(shortName))\t\(description)"
    }

    func realize(argumentValue: AnyObject?) {
        if hasRealized {
            return
        }
        hasRealized = true
        value = argumentValue
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