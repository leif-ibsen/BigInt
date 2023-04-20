//
//  SubtractionTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 19/01/2019.
//

import XCTest
@testable import BigInt

class SubtractionTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        XCTAssertEqual(BInt(7) - BInt(4), BInt(3))
        XCTAssertEqual(BInt(7) - BInt(-4), BInt(11))
        XCTAssertEqual(BInt(-7) - BInt(4), BInt(-11))
        XCTAssertEqual(BInt(-7) - BInt(-4), BInt(-3))
        XCTAssertEqual(BInt(-7) - BInt(0), BInt(-7))
        XCTAssertEqual(BInt(7) - BInt(0), BInt(7))
        XCTAssertEqual(BInt(7) - 4, BInt(3))
        XCTAssertEqual(BInt(7) - (-4), BInt(11))
        XCTAssertEqual(BInt(-7) - 4, BInt(-11))
        XCTAssertEqual(BInt(-7) - (-4), BInt(-3))
        XCTAssertEqual(BInt(-7) - 0, BInt(-7))
        XCTAssertEqual(BInt(7) - 0, BInt(7))
        XCTAssertEqual(7 - BInt(4), BInt(3))
        XCTAssertEqual(7 - BInt(-4), BInt(11))
        XCTAssertEqual((-7) - BInt(4), BInt(-11))
        XCTAssertEqual((-7) - BInt(-4), BInt(-3))
        XCTAssertEqual((-7) - BInt(0), BInt(-7))
        XCTAssertEqual(7 - BInt(0), BInt(7))
        XCTAssertEqual(0 - BInt(7), BInt(-7))
        XCTAssertEqual(0 - BInt(-7), BInt(7))
        XCTAssertEqual(0 - BInt(0), BInt(0))
    }
    
    func test2() {
        var x1 = BInt(7)
        x1 -= BInt(4)
        XCTAssertEqual(x1, BInt(3))
        var x2 = BInt(7)
        x2 -= BInt(-4)
        XCTAssertEqual(x2, BInt(11))
        var x3 = BInt(-7)
        x3 -= BInt(4)
        XCTAssertEqual(x3, BInt(-11))
        var x4 = BInt(-7)
        x4 -= BInt(-4)
        XCTAssertEqual(x4, BInt(-3))
    }
    
    func doTest1(_ x: BInt, _ y: Int) {
        XCTAssertEqual(x - y, x - BInt(y))
        XCTAssertEqual((-x) - y, (-x) - BInt(y))
        if y != Int.min {
            XCTAssertEqual(x - (-y), x - BInt(-y))
            XCTAssertEqual((-x) - (-y), (-x) - BInt(-y))
        }
    }
    
    func doTest2(_ x: BInt) {
        doTest1(x, 0)
        doTest1(x, 1)
        doTest1(x, -1)
        doTest1(x, Int.max)
        doTest1(x, Int.min)
        doTest1(x, Int.max - 1)
        doTest1(x, Int.min + 1)
    }

    func test3() {
        doTest2(BInt(bitWidth: 1000))
        doTest2(BInt(0))
        doTest2(BInt(1))
        doTest2(BInt(-1))
        doTest2(BInt(Int.max))
        doTest2(-BInt(Int.max))
        doTest2(BInt(Int.min))
        doTest2(-BInt(Int.min))
    }

}
