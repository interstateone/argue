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
    func testMatchesArgumentName() {
        let argument = Argument(type: .flag, fullName: "test", shortName: "t", description: "A test flag")
        XCTAssert(argument.matchesToken(Token(input: "")) == false)
        XCTAssert(argument.matchesToken(Token(input: "a")) == false)
        XCTAssert(argument.matchesToken(Token(input: "apple")) == false)
        XCTAssert(argument.matchesToken(Token(input: "-t")) == true)
        XCTAssert(argument.matchesToken(Token(input: "--test")) == true)
    }
}
