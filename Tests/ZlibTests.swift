//
//  ZlibTests.swift
//  SWCompression
//
//  Created by Timofey Solomko on 14.11.16.
//  Copyright © 2016 Timofey Solomko. All rights reserved.
//

import XCTest
import SWCompression

class ZlibTests: XCTestCase {

    static let testType: String = "zlib"

    func testZlib1() {
        let testName = "test1"
        guard let testData = try? Data(contentsOf: Constants.url(forTest: testName, withType: ZlibTests.testType)) else {
            XCTFail("Failed to load test archive")
            return
        }

        guard let decompressedData = try? ZlibArchive.unarchive(archiveData: testData) else {
            XCTFail("Failed to decompress")
            return
        }

        guard let answerData = try? Data(contentsOf: Constants.url(forAnswer: testName)) else {
            XCTFail("Failed to get the answer")
            return
        }

        XCTAssertEqual(decompressedData, answerData, "Decompression was incorrect")
    }

    func testZlib2() {
        let testName = "test2"
        guard let testData = try? Data(contentsOf: Constants.url(forTest: testName, withType: ZlibTests.testType)) else {
            XCTFail("Failed to load test archive")
            return
        }

        guard let decompressedData = try? ZlibArchive.unarchive(archiveData: testData) else {
            XCTFail("Failed to decompress")
            return
        }

        guard let answerData = try? Data(contentsOf: Constants.url(forAnswer: testName)) else {
            XCTFail("Failed to get the answer")
            return
        }

        XCTAssertEqual(decompressedData, answerData, "Decompression was incorrect")
    }

    func testZlib3() {
        let testName = "test3"
        guard let testData = try? Data(contentsOf: Constants.url(forTest: testName, withType: ZlibTests.testType)) else {
            XCTFail("Failed to load test archive")
            return
        }

        guard let decompressedData = try? ZlibArchive.unarchive(archiveData: testData) else {
            XCTFail("Failed to decompress")
            return
        }

        guard let answerData = try? Data(contentsOf: Constants.url(forAnswer: testName)) else {
            XCTFail("Failed to get the answer")
            return
        }

        XCTAssertEqual(decompressedData, answerData, "Decompression was incorrect")
    }

    func testZlib4() {
        let testName = "test4"
        guard let testData = try? Data(contentsOf: Constants.url(forTest: testName, withType: ZlibTests.testType)) else {
            XCTFail("Failed to load test archive")
            return
        }

        guard let decompressedData = try? ZlibArchive.unarchive(archiveData: testData) else {
            XCTFail("Failed to decompress")
            return
        }

        guard let answerData = try? Data(contentsOf: Constants.url(forAnswer: testName)) else {
            XCTFail("Failed to get the answer")
            return
        }

        XCTAssertEqual(decompressedData, answerData, "Decompression was incorrect")
    }

    func testZlib5() {
        let testName = "test5"
        guard let testData = try? Data(contentsOf: Constants.url(forTest: testName, withType: ZlibTests.testType)) else {
            XCTFail("Failed to load test archive")
            return
        }

        guard let decompressedData = try? ZlibArchive.unarchive(archiveData: testData) else {
            XCTFail("Failed to decompress")
            return
        }

        guard let answerData = try? Data(contentsOf: Constants.url(forAnswer: testName)) else {
            XCTFail("Failed to get the answer")
            return
        }

        XCTAssertEqual(decompressedData, answerData, "Decompression was incorrect")
    }

    func testZlib6() {
        let testName = "test6"
        guard let testData = try? Data(contentsOf: Constants.url(forTest: testName, withType: ZlibTests.testType)) else {
            XCTFail("Failed to load test archive")
            return
        }

        guard let decompressedData = try? ZlibArchive.unarchive(archiveData: testData) else {
            XCTFail("Failed to decompress")
            return
        }

        guard let answerData = try? Data(contentsOf: Constants.url(forAnswer: testName)) else {
            XCTFail("Failed to get the answer")
            return
        }

        XCTAssertEqual(decompressedData, answerData, "Decompression was incorrect")
    }

    func testZlib7() {
        let testName = "test7"
        guard let testData = try? Data(contentsOf: Constants.url(forTest: testName, withType: ZlibTests.testType)) else {
            XCTFail("Failed to load test archive")
            return
        }

        guard let decompressedData = try? ZlibArchive.unarchive(archiveData: testData) else {
            XCTFail("Failed to decompress")
            return
        }

        guard let answerData = try? Data(contentsOf: Constants.url(forAnswer: testName)) else {
            XCTFail("Failed to get the answer")
            return
        }

        XCTAssertEqual(decompressedData, answerData, "Decompression was incorrect")
    }

}
