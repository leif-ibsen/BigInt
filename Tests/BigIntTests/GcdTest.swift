//
//  gcdTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 15/01/2019.
//

import XCTest

class GcdTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        XCTAssertEqual(BInt.ZERO.gcd(BInt.ZERO), BInt.ZERO)
        XCTAssertEqual(BInt.ONE.gcd(BInt.ZERO), BInt.ONE)
        XCTAssertEqual(BInt.ZERO.gcd(BInt.ONE), BInt.ONE)
        let x = BInt(bitWidth: 100)
        XCTAssertEqual(x.gcd(BInt.ONE), BInt.ONE)
        XCTAssertEqual(x.gcd(BInt.ZERO), x)
        XCTAssertEqual(x.gcd(x), x)
        XCTAssertEqual(BInt(4).gcd(BInt(272)), BInt(4))
    }

    func test2() {
        var i = 1
        for _ in 0 ..< 3 {
            i *= 10
            let x = BInt(bitWidth: i)
            let y = BInt(bitWidth: 2 * i)
            let gcd = x.gcd(y)
            let (qx, rx) = x.quotientAndRemainder(dividingBy: gcd)
            let (qy, ry) = y.quotientAndRemainder(dividingBy: gcd)
            XCTAssertEqual(rx, BInt.ZERO)
            XCTAssertEqual(ry, BInt.ZERO)
            XCTAssertEqual(qx.gcd(qy), BInt.ONE)
            XCTAssertEqual(qy.gcd(qx), BInt.ONE)
        }
    }

    func test3() {
        for _ in 0 ..< 1000 {
            let x1 = BInt(bitWidth: 10)
            XCTAssertEqual(x1.gcd(x1), x1)
            XCTAssertEqual(x1.gcd(x1 + 1), BInt.ONE)
            let x2 = BInt(bitWidth: 60)
            XCTAssertEqual(x2.gcd(x2), x2)
            XCTAssertEqual(x2.gcd(x2 + 1), BInt.ONE)
            let x3 = BInt(bitWidth: 1000)
            XCTAssertEqual(x3.gcd(x3), x3)
            XCTAssertEqual(x3.gcd(x3 + 1), BInt.ONE)
        }
    }

}
