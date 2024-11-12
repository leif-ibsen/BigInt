//
//  AdditionTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 17/01/2019.
//

import XCTest
@testable import BigInt

class Pow2Test: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        XCTAssertTrue((BInt.ONE << 0).isPow2)
        XCTAssertTrue((BInt.ONE << 1).isPow2)
        XCTAssertTrue((BInt.ONE << 5).isPow2)
        XCTAssertTrue((BInt.ONE << 100).isPow2)
        XCTAssertTrue((BInt.ONE << 1000).isPow2)
        XCTAssertFalse((-BInt.ONE << 0).isPow2)
        XCTAssertFalse((-BInt.ONE << 1).isPow2)
        XCTAssertFalse((-BInt.ONE << 5).isPow2)
        XCTAssertFalse((-BInt.ONE << 100).isPow2)
        XCTAssertFalse((-BInt.ONE << 1000).isPow2)
        XCTAssertFalse((BInt.ONE << 1 + 1).isPow2)
        XCTAssertFalse((BInt.ONE << 5 + 1).isPow2)
        XCTAssertFalse((BInt.ONE << 100 + 1).isPow2)
        XCTAssertFalse((BInt.ONE << 1000 + 1).isPow2)
    }
    
}
