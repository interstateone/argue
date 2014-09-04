//
//  ArgumentTests.swift
//  Remind
//
//  Created by Brandon Evans on 2014-08-19.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import Cocoa
import XCTest
import Argue

class ArgumentTests: XCTestCase {
    override func setUp() {
        let argument1 = Argument(fullName: "test1", shortName: "t1", description: "A string", isFlag: false)
        let argument2 = Argument(fullName: "test2", shortName: "t2", description: "A test flag", isFlag: true)
    }

    func testMatchesArgumentName() {
        let argument = Argument(fullName: "test", shortName: "t", description: "A test flag", isFlag: true)
        XCTAssert(argument.matchesArgumentName("") == false)
        XCTAssert(argument.matchesArgumentName("a") == false)
        XCTAssert(argument.matchesArgumentName("apple") == false)
        XCTAssert(argument.matchesArgumentName("-t") == true)
        XCTAssert(argument.matchesArgumentName("--test") == true)
    }
}