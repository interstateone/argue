//
//  ArgumentTests.swift
//  ArgueTests
//
//  Created by Brandon Evans on 2014-08-19.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import XCTest
@testable import Argue

class ArgumentTests: XCTestCase {
    func testMatchesArgumentName() {
        let argument = Argument(type: .flag, fullName: "test", shortName: "t", description: "A test flag")
        XCTAssert(argument.matchesToken(Token("")) == false)
        XCTAssert(argument.matchesToken(Token("a")) == false)
        XCTAssert(argument.matchesToken(Token("apple")) == false)
        XCTAssert(argument.matchesToken(Token("-t")) == true)
        XCTAssert(argument.matchesToken(Token("--test")) == true)
    }

    static var allTests: [(String, (ArgumentTests) -> () throws -> Void)] {
        return [
            ("testMatchesArgumentName", testMatchesArgumentName)
        ]
    }
}
