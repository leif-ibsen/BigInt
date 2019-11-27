//
//  BitTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 31/12/2018.
//

import XCTest

class BitTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest(_ x1: BInt) {
        var x2 = x1
        x2.negate()
        XCTAssertEqual(x1, -x2)
        XCTAssertEqual(~x1 + 1, -x1)
    }

    func test1() {
        doTest(BInt(0))
        doTest(BInt(1))
        doTest(BInt(-1))
        doTest(BInt(bitWidth: 200))
        var x1 = BInt.ONE << 37
        x1.clearBit(37)
        XCTAssert(x1.isZero)
        var x2 = BInt.ONE << 150
        x2.clearBit(150)
        XCTAssert(x2.isZero)
    }

    func test2() {
        let a = BInt(bitWidth: 300)
        let b = BInt(bitWidth: 300)
        let c = BInt(bitWidth: 300)
        XCTAssertEqual(b ^ b ^ b, b)
        XCTAssertEqual(a & (b | c), (a & b) | (a & c))
    }

    func test3() {
        let a = BInt(bitWidth: 300)
        var b = a
        for i in 0 ..< 300 {
            b.flipBit(i)
        }
        for i in 0 ..< 300 {
            XCTAssertEqual(a.testBit(i), !b.testBit(i))
        }
    }

    func test4() {
        let a = BInt(bitWidth: 300)
        XCTAssertEqual(a | BInt.ZERO, a)
        XCTAssertEqual(a & BInt.ZERO, BInt.ZERO)
        XCTAssertEqual(a & ~BInt.ZERO, a)
        XCTAssertEqual(a ^ BInt.ZERO, a)
        XCTAssertEqual(a ^ ~BInt.ZERO, ~a)
    }

    func test5() {
        let b3 = BInt(3)
        let bm3 = BInt(-3)
        let b7 = BInt(7)
        let bm7 = BInt(-7)
        XCTAssertEqual(b3 & b7, BInt(3))
        XCTAssertEqual(b3 & bm7, BInt(1))
        XCTAssertEqual(bm3 & b7, BInt(5))
        XCTAssertEqual(bm3 & bm7, BInt(-7))
        XCTAssertEqual(b3 | b7, BInt(7))
        XCTAssertEqual(b3 | bm7, BInt(-5))
        XCTAssertEqual(bm3 | b7, BInt(-1))
        XCTAssertEqual(bm3 | bm7, BInt(-3))
        XCTAssertEqual(b3 ^ b7, BInt(4))
        XCTAssertEqual(b3 ^ bm7, BInt(-6))
        XCTAssertEqual(bm3 ^ b7, BInt(-6))
        XCTAssertEqual(bm3 ^ bm7, BInt(4))
        XCTAssertEqual(~b3, BInt(-4))
        XCTAssertEqual(~bm3, BInt(2))
        XCTAssertEqual(~b7, BInt(-8))
        XCTAssertEqual(~bm7, BInt(6))
    }

    func test6() {
        for _ in 0 ..< 100 {
            let x = BInt(bitWidth: 100)
            let y = BInt(bitWidth: 300)
            doTest(x)
            doTest(y)
            XCTAssertEqual(x & y, y & x)
            XCTAssertEqual(x & -y, -y & x)
            XCTAssertEqual(-x & y, y & -x)
            XCTAssertEqual(-x & -y, -y & -x)
            XCTAssertEqual(x | y, y | x)
            XCTAssertEqual(x | -y, -y | x)
            XCTAssertEqual(-x | y, y | -x)
            XCTAssertEqual(-x | -y, -y | -x)
            XCTAssertEqual(x ^ y, y ^ x)
            XCTAssertEqual(x ^ -y, -y ^ x)
            XCTAssertEqual(-x ^ y, y ^ -x)
            XCTAssertEqual(-x ^ -y, -y ^ -x)
        }
    }

}
