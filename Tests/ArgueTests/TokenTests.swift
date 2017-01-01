//
//  ArgumentTests.swift
//  ArgueTests
//
//  Created by Brandon Evans on 2014-08-19.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import XCTest
@testable import Argue

class TokenTests: XCTestCase {
    func testTokenInitialization() {
        XCTAssert(Token("---") == Token.parameter("---"))
        XCTAssert(Token("--") == Token.parameter("--"))
        XCTAssert(Token("-") == Token.parameter("-"))
        XCTAssert(Token("--a") == Token.longIdentifier("a"))
        XCTAssert(Token("--ab") == Token.longIdentifier("ab"))
        XCTAssert(Token("-a") == Token.shortIdentifier("a"))
        XCTAssert(Token("-ab") == Token.parameter("-ab"))
        XCTAssert(Token("") == Token.parameter(""))
    }

    static var allTests: [(String, (TokenTests) -> () throws -> Void)] {
        return [
            ("testTokenInitialization", testTokenInitialization),
        ]
    }
}
