//
//  ConstructorTest.swift
//  XBigIntegerTests
//
//  Created by Leif Ibsen on 11/12/2018.
//

import XCTest

class ConstructorTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        let x1 = BInt("123", radix: 10)!
        XCTAssertEqual(x1.magnitude.count, 1)
        XCTAssertFalse((x1.isNegative))
        let x2 = BInt("-0", radix: 10)!
        XCTAssertEqual(x2.magnitude.count, 1)
        XCTAssertFalse((x2.isNegative))
        let b: Bytes = [0, 0, 0, 123]
        let x3 = BInt(signed: b)
        XCTAssertEqual(x1, x3)
        let x4 = BInt(magnitude: b)
        XCTAssertEqual(x1, x4)
        let x5 = BInt(bitWidth: 100)
        XCTAssertTrue(x5.bitWidth <= 100)
        let x6 = BInt("-123")!
        XCTAssertEqual(x6.magnitude[0], 123)
        let x71 = BInt(bitWidth: 100)
        let x72 = BInt(signed: x71.asSignedBytes())
        XCTAssertEqual(x71, x72)
        let x8 = BInt.ONE << 317
        XCTAssertEqual(x8.trailingZeroBitCount, 317)
        let x9 = BInt(1)
        XCTAssertFalse(x9.isEven)
        XCTAssertTrue(x9.isOdd)
        XCTAssertTrue(x9.isPositive)
        XCTAssertFalse(x9.isNegative)
        XCTAssertFalse(x9.isZero)
        XCTAssertTrue(x9.isNotZero)
        let x10 = BInt(-1)
        XCTAssertFalse(x10.isEven)
        XCTAssertTrue(x10.isOdd)
        XCTAssertFalse(x10.isPositive)
        XCTAssertTrue(x10.isNegative)
        XCTAssertFalse(x10.isZero)
        XCTAssertTrue(x10.isNotZero)
        let x11 = BInt(0)
        XCTAssertTrue(x11.isEven)
        XCTAssertFalse(x11.isOdd)
        XCTAssertFalse(x11.isPositive)
        XCTAssertFalse(x11.isNegative)
        XCTAssertTrue(x11.isZero)
        XCTAssertFalse(x11.isNotZero)
        let x12 = BInt(bitWidth: 1)
        XCTAssertTrue(x12 == BInt.ONE || x12 == BInt.ZERO)
        let x13 = BInt("12345670", radix: 8)
        XCTAssertEqual(x13, BInt("2739128"))
        let x14 = BInt("12345678", radix: 8)
        XCTAssertEqual(x14, nil)
    }

    func test2() {
        let x0 = BInt(0)
        let x1 = BInt(1)
        let xm1 = BInt(-1)
        XCTAssertEqual(x0.magnitude.count, 1)
        XCTAssertEqual(x1.magnitude.count, 1)
        XCTAssertEqual(xm1.magnitude.count, 1)
        XCTAssertFalse(x0.isNegative)
        XCTAssertFalse(x1.isNegative)
        XCTAssertTrue(xm1.isNegative)
        XCTAssertTrue(x0.isZero)
        XCTAssertTrue(x1.isPositive)
        XCTAssertTrue(xm1.isNegative)
    }
    
    func test3() {
        let x0 = BInt([0x8000000000000000], true)
        XCTAssertEqual(x0.asInt(), Int.min)
        let x1 = BInt(signed: [0])
        XCTAssertEqual(x1, BInt.ZERO)
        let x2 = BInt(signed: [0, 255])
        XCTAssertEqual(x2, BInt(255))
        let x3 = BInt(signed: [255])
        XCTAssertEqual(x3, BInt(-1))
        let x4 = BInt(signed: [255, 0])
        XCTAssertEqual(x4, BInt(-256))
        let x5 = BInt(signed: [255, 255])
        XCTAssertEqual(x5, BInt(-1))
    }

    func test4() {
        let x1 = BInt(magnitude: [0])
        XCTAssertEqual(x1, BInt.ZERO)
        let x2 = BInt(magnitude: [0, 255])
        XCTAssertEqual(x2, BInt(255))
        let x3 = BInt(magnitude: [255])
        XCTAssertEqual(x3, BInt(255))
        let x4 = BInt(magnitude: [255, 0])
        XCTAssertEqual(x4, BInt(65280))
        let x5 = BInt(magnitude: [255, 255])
        XCTAssertEqual(x5, BInt(65535))
        let x6 = BInt(magnitude: [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
        XCTAssertEqual(x6, BInt("fffffffffffffffffffffffffffffffeffffffffffffffff", radix: 16)!)
        let x7 = BInt(signed: [0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
        XCTAssertEqual(x7, BInt("fffffffffffffffffffffffffffffffeffffffffffffffff", radix: 16)!)
    }

    func doTest6(_ n: Int) {
        let x = BInt(bitWidth: n)
        for r in 2 ... 36 {
            let s = x.asString(radix: r)
            XCTAssertEqual(x, BInt(s, radix: r))
            XCTAssertEqual(x, BInt("+" + s, radix: r))
            XCTAssertEqual(-x, BInt("-" + s, radix: r))
        }
    }

    func test6() {
        doTest6(1)
        doTest6(10)
        doTest6(100)
        doTest6(1000)
        XCTAssertNil(BInt(""))
        XCTAssertNil(BInt("+"))
        XCTAssertNil(BInt("-"))
        XCTAssertNil(BInt("+ 1"))
        XCTAssertNil(BInt("- 1"))
    }
    
    func test7() {
        XCTAssertEqual(BInt.ZERO.asDouble(), 0.0)
        XCTAssertEqual((-BInt.ZERO).asDouble(), 0.0)
        XCTAssertEqual(BInt.ONE.asDouble(), 1.0)
        XCTAssertEqual((-BInt.ONE).asDouble(), -1.0)
        XCTAssertEqual((BInt.ONE << 1024).asDouble(), Double.infinity)
        XCTAssertEqual(-(BInt.ONE << 1024).asDouble(), -Double.infinity)
        XCTAssert((BInt.ONE << 1023).asDouble().isFinite)
        XCTAssert((-(BInt.ONE << 1023)).asDouble().isFinite)
    }
}
