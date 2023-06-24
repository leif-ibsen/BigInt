//
//  gcdTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 15/01/2019.
//

import XCTest
@testable import BigInt

class GcdTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest(_ x: BInt, _ y: BInt) {
        let g = x.gcd(y)
        XCTAssertFalse(g.isNegative)
        XCTAssertEqual(g, y.gcd(x))
        XCTAssertEqual(x.gcd(BInt.zero), x.abs)
        XCTAssertEqual(x.gcd(BInt.one), BInt.one)
        XCTAssertEqual(x.gcd(x), x.abs)
        if g > 0 {
            precondition(g != 0)
            let (qx, rx) = x.quotientAndRemainder(dividingBy: g)
            let (qy, ry) = y.quotientAndRemainder(dividingBy: g)
            XCTAssertEqual(rx, BInt.zero)
            XCTAssertEqual(ry, BInt.zero)
            XCTAssertEqual(qx.gcd(qy), BInt.one)
            XCTAssertEqual(qy.gcd(qx), BInt.one)
        }
        XCTAssertEqual(x.gcd(x + 1), BInt.one)
    }

    func doTest1(_ x: BInt, _ y: BInt) {
        doTest(x, y)
        doTest(-x, y)
        doTest(x, -y)
        doTest(-x, -y)
    }

    func test1() {
        var i = 1
        for _ in 0 ..< 4 {
            i *= 10
            for _ in 0 ..< 100 {
                let x = BInt(bitWidth: i)
                let y = BInt(bitWidth: 2 * i)
                doTest1(x, y)
                doTest1(x, BInt(Int.max))
                doTest1(x, BInt(Int.min))
                doTest1(x, BInt(Int.max) + 1)
                doTest1(x, BInt(Int.min) - 1)
            }
        }
    }

    func test2() {
        doTest1(BInt.zero, BInt.zero)
        doTest1(BInt.zero, BInt.one)
        doTest1(BInt.one, BInt.one)
    }

}
