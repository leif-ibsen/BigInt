//
//  ShiftTest.swift
//  XBigIntegerTests
//
//  Created by Leif Ibsen on 11/12/2018.
//

import XCTest
@testable import BigInt

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
        XCTAssertEqual(x1, (x1 << 300) >> 300)
        XCTAssertEqual(x1 << -300, x1 >> 300)
        XCTAssertEqual(x1 << 300, x1 >> -300)
        let x2 = BInt("1234567890")
        XCTAssertEqual(x2, (x2 << 200) / (BInt.one << 200))
        var x3 = x2
        x3 <<= 1
        XCTAssertEqual(x3, BInt("2469135780"))
    }

    func test2() {
        let x: Limbs = [0]
        XCTAssertEqual(x.shiftedLeft(0), [0])
        XCTAssertEqual(x.shiftedLeft(1), [0])
        XCTAssertEqual(x.shiftedLeft(64), [0])
        XCTAssertEqual(x.shiftedLeft(65), [0])
        XCTAssertEqual(x.shiftedLeft(128), [0])
        XCTAssertEqual(x.shiftedLeft(129), [0])
    }
    
    func test3() {
        XCTAssertEqual(BInt.zero << Int.max, BInt.zero)
        XCTAssertEqual(BInt.zero >> Int.max, BInt.zero)
        XCTAssertEqual(BInt.one >> Int.max, BInt.zero)
        XCTAssertEqual(BInt.zero << Int.min, BInt.zero)
        XCTAssertEqual(BInt.zero >> Int.min, BInt.zero)
        XCTAssertEqual(BInt.one << Int.min, BInt.zero)
    }

}
