//
//  ArgueTests.swift
//  ArgueTests
//
//  Created by Brandon Evans on 2014-08-19.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import XCTest
@testable import Argue

class ParsingTests: XCTestCase {
    let argument1 = Argument(type: .value, fullName: "test1", shortName: "1", description: "A string")
    let argument2 = Argument(type: .flag, fullName: "test2", shortName: "2", description: "A test flag")
    let argument3 = Argument(type: .value, fullName: "test3", shortName: "3", description: "Another string")
    var argue: Argue!

    override func setUp() {
        argue = Argue(usage: "How to use this program...", arguments: [argument1, argument2, argument3])
    }

    func testParseArguments() {
        try? argue.parseArguments(["--test1", "TEST", "-2"])
        XCTAssert(argument1.value as! String == "TEST", "Error parsing value")
        XCTAssert(argument2.value as! Bool == true, "Error accessing value with subscript")
    }

    func testParseArgumentsEmpty() {
        try? argue.parseArguments([])
        XCTAssert(argument1.value == nil, "Error parsing value")
        XCTAssert(argument2.value == nil, "Error accessing value with subscript")
    }

    func testParseArgumentsError() {
        XCTAssertThrowsError(try argue.parseArguments(["--wrongName"]), "Failed to report error") { error in
            XCTAssert(error.localizedDescription.characters.count > 0, "Failed to provide localized error description")
        }
    }

    func testParseArgumentsArray() {
        try! argue.parseArguments(["--test1", "TEST", "TESTING", "-2"])
        XCTAssert(argument1.value as! [String] == ["TEST", "TESTING"], "Error parsing value")
        XCTAssert(argument2.value as! Bool == true, "Error accessing value with subscript")
    }

    func testParseArgumentsMultipleParameters() {
        try! argue.parseArguments(["--test1", "TEST", "-3", "TESTING"])
        XCTAssert(argument1.value as! String == "TEST", "Error parsing value")
        XCTAssert(argument3.value as! String == "TESTING", "Error accessing value with subscript")
    }

    func testParseTokens() {
        XCTAssertTrue(equals(argue.parseTokens(from: [""]), [[Token.parameter("")]]))

        XCTAssertTrue(equals(argue.parseTokens(from: ["--add"]), [[Token.longIdentifier("add")]]))
        XCTAssertTrue(equals(argue.parseTokens(from: ["--add", "path/file"]), [[Token.longIdentifier("add"), Token.parameter("path/file")]]))
        XCTAssertTrue(equals(argue.parseTokens(from: ["--add", "path/file", "path/file2"]), [[Token.longIdentifier("add"), Token.parameter("path/file"), Token.parameter("path/file2")]]))

        XCTAssertTrue(equals(argue.parseTokens(from: ["--add", "path/file", "-v"]), [
            [Token.longIdentifier("add"), Token.parameter("path/file")],
            [Token.shortIdentifier("v")]
        ]))
        XCTAssertTrue(equals(argue.parseTokens(from: ["--add", "path/file", "--remove", "path/file2"]), [
            [Token.longIdentifier("add"), Token.parameter("path/file")],
            [Token.longIdentifier("remove"), Token.parameter("path/file2")]
        ]))
    }

    func testHelpArgument() {
        try! argue.parseArguments(["--help"])
        XCTAssert(argue!.helpArgument.value != nil, "Failed to parse help argument")
    }

    func testUsageString() {
        let lineBreaks = argue.description.components(separatedBy: "\n").count - 1
        XCTAssertEqual(lineBreaks, 7, "Failed to print the correct number of lines for usage instructions")
    }

    static var allTests: [(String, (ParsingTests) -> () throws -> Void)] {
        return [
            ("testParseArguments", testParseArguments),
            ("testParseArgumentsEmpty", testParseArgumentsEmpty),
            ("testParseArgumentsError", testParseArgumentsError),
            ("testParseArgumentsArray", testParseArgumentsArray),
            ("testParseArgumentsMultipleParameters", testParseArgumentsMultipleParameters),
            ("testParseTokens", testParseTokens),
            ("testHelpArgument", testHelpArgument),
            ("testUsageString", testUsageString)
        ]
    }
}

func equals(_ lhs: [[Token]], _ rhs: [[Token]]) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (leftGroup, rightGroup) in zip(lhs, rhs) {
        guard leftGroup.count == rightGroup.count else { return false }
        for (left, right) in zip(leftGroup, rightGroup) {
            if left != right { return false }
        }
    }
    return true
}
