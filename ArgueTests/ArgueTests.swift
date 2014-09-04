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
    var argue: Argue?
    var argument1: Argument?
    var argument2: Argument?

    override func setUp() {
        argument1 = Argument(fullName: "test1", shortName: "t1", description: "A string", isFlag: false)
        argument2 = Argument(fullName: "test2", shortName: "t2", description: "A test flag", isFlag: true)

        let usage = "How to use this program..."
        argue = Argue(usage: usage, arguments:[argument1!, argument2!])
    }

    func testParseArguments() {
        argue!.parseArguments(["--test1", "TEST", "--test2"])
        XCTAssert(argument1!.value as String == "TEST", "Error parsing value")
        XCTAssert(argument2!.value as Bool == true, "Error accessing value with subscript")
    }

    func testParseArgumentsEmpty() {
        argue!.parseArguments([])
        XCTAssert(argument1!.value == nil, "Error parsing value")
        XCTAssert(argument2!.value == nil, "Error accessing value with subscript")
    }

    func testParseArgumentsError() {
        let error = argue!.parseArguments(["--wrongName"])
        XCTAssert(error? != nil, "Failed to report error")
        XCTAssert(countElements(error!.localizedDescription) > 0, "Failed to provide localized error description")
    }

    func testParse() {
        argue!.parse()
        XCTAssert(argument1!.value == nil, "Error parsing value")
        XCTAssert(argument2!.value == nil, "Error accessing value with subscript")
    }

    func testHelpArgument() {
        argue!.exitOnHelp = false
        argue!.parseArguments(["--help"])
        XCTAssert(argue!.helpArgument.value != nil, "Failed to parse help argument")
    }

    func testUsageString() {
        let lineBreaks = argue!.usageString().componentsSeparatedByString("\n").count - 1
        XCTAssertEqual(lineBreaks, 6, "Failed to print the correct number of lines for usage instructions")
    }
}
