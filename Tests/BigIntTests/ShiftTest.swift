//
//  ShiftTest.swift
//  XBigIntegerTests
//
//  Created by Leif Ibsen on 11/12/2018.
//

import XCTest

class ShiftTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        let x1 = BInt(bitWidth: 200)
        XCTAssertEqual(x1, (x1 << 3) >> 3)
        XCTAssertEqual(x1 << -3, x1 >> 3)
        XCTAssertEqual(x1 << 3, x1 >> -3)
        let x2 = BInt("1234567890")!
        XCTAssertEqual(x2, (x2 << 200) / (BInt.ONE << 200))
        var x3 = x2
        x3 <<= 1
        XCTAssertEqual(x3, BInt("2469135780")!)
    }


}
