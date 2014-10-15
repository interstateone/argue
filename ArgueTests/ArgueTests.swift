//
//  ArgueTests.swift
//  ArgueTests
//
//  Created by Brandon Evans on 2014-08-19.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import Cocoa
import XCTest
import Argue

class ArgueTests: XCTestCase {
    let argument1 = Argument(type: .Option, fullName: "test1", shortName: "1", description: "A string")
    let argument2 = Argument(type: .Flag, fullName: "test2", shortName: "2", description: "A test flag")
    let argument3 = Argument(type: .Option, fullName: "test3", shortName: "3", description: "Another string")
    var argue: Argue?

    override func setUp() {
        argue = Argue(usage: "How to use this program...", arguments: [argument1, argument2, argument3])
    }

    func testParseArguments() {
        argue!.parseArguments(["--test1", "TEST", "-2"])
        XCTAssert(argument1.value as String == "TEST", "Error parsing value")
        XCTAssert(argument2.value as Bool == true, "Error accessing value with subscript")
    }

    func testParseArgumentsEmpty() {
        argue!.parseArguments([])
        XCTAssert(argument1.value == nil, "Error parsing value")
        XCTAssert(argument2.value == nil, "Error accessing value with subscript")
    }

    func testParseArgumentsError() {
        let error = argue!.parseArguments(["--wrongName"])
        XCTAssert(error? != nil, "Failed to report error")
        XCTAssert(countElements(error!.localizedDescription) > 0, "Failed to provide localized error description")
    }

    func testParseArgumentsArray() {
        argue!.parseArguments(["--test1", "TEST", "TESTING", "-2"])
        XCTAssert(argument1.value as [String] == ["TEST", "TESTING"], "Error parsing value")
        XCTAssert(argument2.value as Bool == true, "Error accessing value with subscript")
    }

    func testParseArgumentsMultipleParameters() {
        argue!.parseArguments(["--test1", "TEST", "-3", "TESTING"])
        XCTAssert(argument1.value as String == "TEST", "Error parsing value")
        XCTAssert(argument3.value as String == "TESTING", "Error accessing value with subscript")
    }

    func testParse() {
        argue!.parse()
        XCTAssert(argument1.value == nil, "Error parsing value")
        XCTAssert(argument2.value == nil, "Error accessing value with subscript")
    }

    func testHelpArgument() {
        argue!.parseArguments(["--help"])
        XCTAssert(argue!.helpArgument.value != nil, "Failed to parse help argument")
    }

    func testUsageString() {
        let lineBreaks = argue!.description.componentsSeparatedByString("\n").count - 1
        XCTAssertEqual(lineBreaks, 7, "Failed to print the correct number of lines for usage instructions")
    }
}
