import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ParsingTests.allTests),
        testCase(ArgumentTests.allTests),
        testCase(TokenTests.allTests)
    ]
}
#endif
