//
//  BitTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 31/12/2018.
//

import XCTest
@testable import BigInt

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
        var x1 = BInt.one << 37
        x1.clearBit(37)
        XCTAssert(x1.isZero)
        var x2 = BInt.one << 150
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
        XCTAssertEqual(a | BInt.zero, a)
        XCTAssertEqual(a & BInt.zero, BInt.zero)
        XCTAssertEqual(a & ~BInt.zero, a)
        XCTAssertEqual(a ^ BInt.zero, a)
        XCTAssertEqual(a ^ ~BInt.zero, ~a)
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
    
    func test7() {
        let x = BInt(bitWidth: 50)
        var y = x
        y.setBit(-1)
        XCTAssertEqual(x, y)
        y.clearBit(-1)
        XCTAssertEqual(x, y)
        y.flipBit(-1)
        XCTAssertEqual(x, y)
        XCTAssertFalse(y.testBit(-1))
        y = BInt(0)
        y.setBit(200)
        XCTAssertEqual(y.mag.count, 4)
        XCTAssertEqual(y, BInt.one << 200)
        XCTAssertTrue(y.testBit(200))
        y.clearBit(200)
        XCTAssertEqual(y.mag.count, 1)
        XCTAssertFalse(y.testBit(200))
        XCTAssertEqual(y, BInt.zero)
        y.flipBit(200)
        XCTAssertEqual(y, BInt.one << 200)
        y.flipBit(200)
        XCTAssertEqual(y, BInt.zero)
    }
    
    func popCount(_ a: BInt) -> Int {
        var n = 0
        var x = a
        while x.isNotZero {
            if x.isOdd {
                n += 1
            }
            x >>= 1
        }
        return n
    }

    func test8() {
        XCTAssertEqual(BInt.zero.population, 0)
        let x = BInt("ffffffffffffffff", radix: 16)!
        for i in 0 ..< 100 {
            XCTAssertEqual((BInt.one << i).population, 1)
            XCTAssertEqual((x << i).population, 64)
        }
        for _ in 0 ..< 100 {
            let x = BInt(bitWidth: 200)
            XCTAssertEqual(x.population, popCount(x))
        }
    }

}
