//
//  MultiplicationTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 19/01/2019.
//

import XCTest

class MultiplicationTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest1(_ i: Int) {
        let a = BInt(bitWidth: 200 * i)
        let b = BInt(bitWidth: 100 * i)
        let c = a * b
        let (q, r) = c.quotientAndRemainder(dividingBy: a)
        XCTAssertEqual(r, BInt(0))
        XCTAssertEqual(q, b)
        let (q1, r1) = c.quotientAndRemainder(dividingBy: b)
        XCTAssertEqual(r1, BInt(0))
        XCTAssertEqual(q1, a)
        var am = a.magnitude
        am.square()
        XCTAssertEqual(a * a, BInt(am))
    }

    func test1() {
        for i in 1 ..< 10 {
            doTest1(i)
        }
        doTest1(1000)
    }

    func test2() {
        XCTAssertEqual(BInt.ONE * BInt.ZERO, BInt.ZERO)
        XCTAssertEqual(BInt(-1) * BInt.ZERO, BInt.ZERO)
        XCTAssertEqual(BInt.ZERO * BInt.ONE, BInt.ZERO)
        XCTAssertEqual(BInt.ZERO * BInt(-1), BInt.ZERO)
        XCTAssertEqual(BInt.ONE * 0, BInt.ZERO)
        XCTAssertEqual(BInt(-1) * 0, BInt.ZERO)
        XCTAssertEqual(0 * BInt.ONE, BInt.ZERO)
        XCTAssertEqual(0 * BInt(-1), BInt.ZERO)
    }

    func test3() {
        XCTAssertEqual(BInt(7) * BInt(4), BInt(28))
        XCTAssertEqual(BInt(7) * BInt(-4), BInt(-28))
        XCTAssertEqual(BInt(-7) * BInt(4), BInt(-28))
        XCTAssertEqual(BInt(-7) * BInt(-4), BInt(28))
        XCTAssertEqual(BInt(-7) * BInt(0), BInt(0))
        XCTAssertEqual(BInt(7) * BInt(0), BInt(0))
        XCTAssertEqual(BInt(7) * 4, BInt(28))
        XCTAssertEqual(BInt(7) * (-4), BInt(-28))
        XCTAssertEqual(BInt(-7) * 4, BInt(-28))
        XCTAssertEqual(BInt(-7) * (-4), BInt(28))
        XCTAssertEqual(BInt(-7) * 0, BInt(0))
        XCTAssertEqual(BInt(7) * 0, BInt(0))
        XCTAssertEqual(7 * BInt(4), BInt(28))
        XCTAssertEqual(7 * BInt(-4), BInt(-28))
        XCTAssertEqual((-7) * BInt(4), BInt(-28))
        XCTAssertEqual((-7) * BInt(-4), BInt(28))
        XCTAssertEqual((-7) * BInt(0), BInt(0))
        XCTAssertEqual(7 * BInt(0), BInt(0))
    }
    
    func test5() {
        var x1 = BInt(7)
        x1 *= BInt(4)
        XCTAssertEqual(x1, BInt(28))
        var x2 = BInt(7)
        x2 *= BInt(-4)
        XCTAssertEqual(x2, BInt(-28))
        var x3 = BInt(-7)
        x3 *= BInt(4)
        XCTAssertEqual(x3, BInt(-28))
        var x4 = BInt(-7)
        x4 *= BInt(-4)
        XCTAssertEqual(x4, BInt(28))
    }

}
