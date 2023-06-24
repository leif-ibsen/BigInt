//
//  ConstructorTest.swift
//  XBigIntegerTests
//
//  Created by Leif Ibsen on 11/12/2018.
//

import XCTest
@testable import BigInt

class ConstructorTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        let x1 = BInt("123", radix: 10)!
        XCTAssertEqual(x1.mag.count, 1)
        XCTAssertFalse((x1.isNegative))
        let x2 = BInt("-0", radix: 10)!
        XCTAssertEqual(x2.mag.count, 1)
        XCTAssertFalse((x2.isNegative))
        let b: Bytes = [0, 0, 0, 123]
        let x3 = BInt(signed: b)
        XCTAssertEqual(x1, x3)
        let x4 = BInt(magnitude: b)
        XCTAssertEqual(x1, x4)
        let x5 = BInt(bitWidth: 100)
        XCTAssertTrue(x5.bitWidth <= 100)
        let x6 = BInt("-123")
        XCTAssertEqual(x6.mag[0], 123)
        let x71 = BInt(bitWidth: 100)
        let x72 = BInt(signed: x71.asSignedBytes())
        XCTAssertEqual(x71, x72)
        let x8 = BInt.one << 317
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
        XCTAssertTrue(x12 == BInt.one || x12 == BInt.zero)
        let x13 = BInt("12345670", radix: 8)
        XCTAssertEqual(x13, BInt("2739128"))
        let x14 = BInt("12345678", radix: 8)
        XCTAssertEqual(x14, nil)
    }

    func test2() {
        let x0 = BInt(0)
        let x1 = BInt(1)
        let xm1 = BInt(-1)
        XCTAssertEqual(x0.mag.count, 1)
        XCTAssertEqual(x1.mag.count, 1)
        XCTAssertEqual(xm1.mag.count, 1)
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
        XCTAssertEqual(x1, BInt.zero)
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
        XCTAssertEqual(x1, BInt.zero)
        let x2 = BInt(magnitude: [0, 255])
        XCTAssertEqual(x2, BInt(255))
        let x3 = BInt(magnitude: [255])
        XCTAssertEqual(x3, BInt(255))
        let x4 = BInt(magnitude: [255, 0])
        XCTAssertEqual(x4, BInt(65280))
        let x5 = BInt(magnitude: [255, 255])
        XCTAssertEqual(x5, BInt(65535))
        let x6 = BInt(magnitude:
            [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
             0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xff, 0xff,
             0xff, 0xff, 0xff, 0xff])
        XCTAssertEqual(x6, BInt(0xfffffffffffffffffffffffffffffffeffffffffffffffff))
        let x7 = BInt(signed:
            [0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
             0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xff,
             0xff, 0xff, 0xff, 0xff, 0xff])
        XCTAssertEqual(x7, BInt(0xfffffffffffffffffffffffffffffffeffffffffffffffff))
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
        XCTAssertNil(BInt("", radix:10))
        XCTAssertNil(BInt("+", radix:10))
        XCTAssertNil(BInt("-", radix:10))
        XCTAssertNil(BInt("+ 1", radix:10))
        XCTAssertNil(BInt("- 1", radix:10))
    }
    
    // BInt to Double
    func test7() {
        XCTAssertEqual(BInt.zero.asDouble(), 0.0)
        XCTAssertEqual((-BInt.zero).asDouble(), 0.0)
        XCTAssertEqual(BInt.one.asDouble(), 1.0)
        XCTAssertEqual((-BInt.one).asDouble(), -1.0)
        XCTAssertEqual((BInt.one << 1024).asDouble(), Double.infinity)
        XCTAssertEqual(-(BInt.one << 1024).asDouble(), -Double.infinity)
        XCTAssert((BInt.one << 1023).asDouble().isFinite)
        XCTAssert((-(BInt.one << 1023)).asDouble().isFinite)
    }
    
    // BInt from a Double value
    func test8() {
        XCTAssertEqual(BInt(0.0), BInt.zero)
        XCTAssertEqual(BInt(1.0), BInt.one)
        XCTAssertEqual(BInt(-1.0), -BInt.one)
        XCTAssertNil(BInt(0.0 / 0.0))
        XCTAssertNil(BInt(1.0 / 0.0))
        XCTAssertNil(BInt(-1.0 / 0.0))
        for i in 0 ..< 10 {
            XCTAssertEqual(BInt(10), BInt(10.0 + Double(i) / 10.0))
            XCTAssertEqual(BInt(9), BInt(10.0 - Double(i + 1) / 10.0))
            XCTAssertEqual(BInt(-9), BInt(-10.0 + Double(i + 1) / 10.0))
            XCTAssertEqual(BInt(-10), BInt(-10.0 - Double(i) / 10.0))
        }
        for _ in 0 ..< 100 {
            let x = BInt(bitWidth: 1000)
            let d = x.asDouble()
            let x1 = BInt(d)!
            XCTAssertTrue((x - x1).abs.asDouble() / d <= 1.0e-15)
        }
    }
    
    // BInt from a StaticBigInt
    func test8a() {
        let bigNumber = BInt(1234567890_1234567890_1234567890_1234567890)
        let nbigNumber = BInt(-1234567890_1234567890_1234567890_1234567890)
        XCTAssertEqual(bigNumber.description,
                       "1234567890123456789012345678901234567890")
        XCTAssertEqual(nbigNumber.description,
                       "-1234567890123456789012345678901234567890")
    }
    
    let strings = ["0",
                   "10",
                   "120",
                   "1230",
                   "12340",
                   "123450",
                   "1234560",
                   "12345670",
                   "123456780",
                   "1234567890",
                   "123456789a0",
                   "123456789ab0",
                   "123456789abc0",
                   "123456789abcd0",
                   "123456789abcde0",
                   "123456789abcdef0",
                   "123456789abcdefg0",
                   "123456789abcdefgh0",
                   "123456789abcdefghi0",
                   "123456789abcdefghij0",
                   "123456789abcdefghijk0",
                   "123456789abcdefghijkl0",
                   "123456789abcdefghijklm0",
                   "123456789abcdefghijklmn0",
                   "123456789abcdefghijklmno0",
                   "123456789abcdefghijklmnop0",
                   "123456789abcdefghijklmnopq0",
                   "123456789abcdefghijklmnopqr0",
                   "123456789abcdefghijklmnopqrs0",
                   "123456789abcdefghijklmnopqrst0",
                   "123456789abcdefghijklmnopqrstu0",
                   "123456789abcdefghijklmnopqrstuv0",
                   "123456789abcdefghijklmnopqrstuvw0",
                   "123456789abcdefghijklmnopqrstuvwx0",
                   "123456789abcdefghijklmnopqrstuvwxy0",
                   "123456789abcdefghijklmnopqrstuvwxyz0",
    ]

    // Radix test
    func test9() {
        for r in 2 ... 36 {
            for i in 0 ..< strings.count {
                let x = BInt(strings[i], radix: r)
                let X = BInt(strings[i].uppercased(), radix: r)
                if i < r {
                    XCTAssertNotNil(x)
                    let z = x?.asString(radix: r, uppercase: false)
                    XCTAssertEqual(z, strings[i])
                    XCTAssertNotNil(X)
                    let Z = X?.asString(radix: r, uppercase: true)
                    XCTAssertEqual(Z, strings[i].uppercased())
                    XCTAssertEqual(BInt(z!, radix: r), BInt(Z!, radix: r))
                } else {
                    XCTAssertNil(x)
                    XCTAssertNil(X)
                }
            }
        }
    }

}
