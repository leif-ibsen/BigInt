//
//  LimbTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 24/12/2018.
//

import XCTest

class LimbTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        var x1: Limbs = [0, 0, 0]
        XCTAssertEqual(x1.count, 3)
        x1.ensureSize(5)
        XCTAssertEqual(x1.count, 5)
        x1.normalize()
        XCTAssertEqual(x1.count, 1)
        x1 = [0, 0, 1]
        XCTAssertEqual(x1.bitWidth, 129)
        x1.setBitAt(1, to: true)
        XCTAssertEqual(BInt(x1), (BInt(1) << 128) + 2)
    }

}
