// Copyright (c) 2021 Timofey Solomko
// Licensed under MIT License
//
// See LICENSE for license information

import XCTest
import SWCompression

class LZ4Tests: XCTestCase {

    private static let testType: String = "lz4"

    // These tests test frames with independent blocks (since they all have only one block). The frames also have
    // additional features enabled, such as content size and block checksums. They also test legacy frame format.

    func perform(test testName: String) throws {
        let testData = try Constants.data(forTest: testName, withType: LZ4Tests.testType)
        let decompressedData = try LZ4.decompress(data: testData)

        let answerData = try Constants.data(forAnswer: testName)
        XCTAssertEqual(decompressedData, answerData)
    }

    private static func perform(legacyTest testName: String) throws {
        let testData = try Constants.data(forTest: testName + "_legacy", withType: LZ4Tests.testType)
        let decompressedData = try LZ4.decompress(data: testData)

        let answerData = try Constants.data(forAnswer: testName)
        XCTAssertEqual(decompressedData, answerData)
    }

    func test1LZ4() throws {
        try self.perform(test: "test1")
        try LZ4Tests.perform(legacyTest: "test1")
    }

    func test2LZ4() throws {
        try self.perform(test: "test2")
        try LZ4Tests.perform(legacyTest: "test2")
    }

    func test3LZ4() throws {
        try self.perform(test: "test3")
        try LZ4Tests.perform(legacyTest: "test3")
    }

    func test4LZ4() throws {
        try self.perform(test: "test4")
        try LZ4Tests.perform(legacyTest: "test4")
    }

    func test5LZ4() throws {
        try self.perform(test: "test5")
        try LZ4Tests.perform(legacyTest: "test5")
    }

    func test6LZ4() throws {
        try self.perform(test: "test6")
        try LZ4Tests.perform(legacyTest: "test6")
    }

    func test7LZ4() throws {
        try self.perform(test: "test7")
        try LZ4Tests.perform(legacyTest: "test7")
    }

    func test8LZ4() throws {
        try self.perform(test: "test8")
        try LZ4Tests.perform(legacyTest: "test8")
    }

    func test9LZ4() throws {
        try self.perform(test: "test9")
        try LZ4Tests.perform(legacyTest: "test9")
    }

    func testDependentBlocks() throws {
        // This test contains dependent blocks (with the size of 64 kB), as well as has additional features enabled,
        // such as content size and block checksums.
        let testData = try Constants.data(forTest: "SWCompressionSourceCode.tar", withType: LZ4Tests.testType)
        let decompressedData = try LZ4.decompress(data: testData)

        let answerData = try Constants.data(forTest: "SWCompressionSourceCode", withType: "tar")
        XCTAssertEqual(decompressedData, answerData)
    }

    func testBadFile_short() {
        LZ4Tests.checkTruncationError(Data([0]))
    }

    func testBadFile_invalid() throws {
        let testData = try Constants.data(forAnswer: "test6")
        var thrownError: Error?
        XCTAssertThrowsError(try LZ4.decompress(data: testData)) { thrownError = $0 }
        XCTAssertTrue(thrownError is DataError, "Unexpected error type: \(type(of: thrownError))")
        XCTAssertEqual(thrownError as? DataError, .corrupted)
    }

    func testEmptyData() {
        LZ4Tests.checkTruncationError(Data())
    }

    private static func checkTruncationError(_ data: Data) {
        var thrownError: Error?
        XCTAssertThrowsError(try LZ4.decompress(data: data)) { thrownError = $0 }
        XCTAssertTrue(thrownError is DataError, "Unexpected error type: \(type(of: thrownError))")
        XCTAssertEqual(thrownError as? DataError, .truncated)
    }

    func testSkippableFrame() throws {
        let testData = try Constants.data(forTest: "test_skippable_frame", withType: LZ4Tests.testType)
        let decompressedData = try LZ4.decompress(data: testData)

        let answerData = try Constants.data(forAnswer: "test4")
        XCTAssertEqual(decompressedData, answerData)
    }

    func testLegacyFrameMultipleBlocks() throws {
        let testData = try Constants.data(forTest: "zeros", withType: LZ4Tests.testType)
        let decompressedData = try LZ4.decompress(data: testData)

        let answerData = Data(count: 18874368)
        XCTAssertEqual(decompressedData, answerData)
    }

}
