//
//  DivModTest.swift
//  XBigIntegerTests
//
//  Created by Leif Ibsen on 11/12/2018.
//

import XCTest

class DivModTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest1(_ bw1: Int, _ bw2: Int) {
        let x1 = BInt(bitWidth: bw1)
        let x2 = BInt(bitWidth: bw2) + BInt.ONE
        doTest2(x1, x2)
    }

    func doTest2(_ x1: BInt, _ x2: BInt) {
        let r1 = x1 % x2
        let q1 = x1 / x2
        XCTAssertEqual(x1, x2 * q1 + r1)
        let (q2, r2) = x1.quotientAndRemainder(dividingBy: x2)
        XCTAssertEqual(q1, q2)
        XCTAssertEqual(r1, r2)
        var q3 = BInt.ZERO
        var r3 = BInt.ZERO
        x1.quotientAndRemainder(dividingBy: x2, &q3, &r3)
        XCTAssertEqual(q1, q3)
        XCTAssertEqual(r1, r3)
        XCTAssertEqual(x1.mod(Int.min), x1.mod(BInt(Int.min)).asInt()!)
    }

    func test1() {
        doTest1(30, 20)
        doTest1(30, 120)
        doTest1(130, 20)
        doTest1(130, 120)
        doTest2(BInt.ONE << 512 - 1, BInt.ONE)
        doTest2(BInt.ONE << 512 - 1, BInt.ONE << 512 - 1)
        doTest2(BInt.ONE << 512, BInt.ONE)
        doTest2(BInt.ONE << 512, BInt.ONE << 512 - 1)
    }

    func test2() {
        XCTAssertEqual(BInt(7) % BInt(4), BInt(3))
        XCTAssertEqual(BInt(-7) % BInt(4), BInt(-3))
        XCTAssertEqual(BInt(7) % BInt(-4), BInt(3))
        XCTAssertEqual(BInt(-7) % BInt(-4), BInt(-3))
        XCTAssertEqual(BInt(7) % 4, BInt(3))
        XCTAssertEqual(BInt(-7) % 4, BInt(-3))
        XCTAssertEqual(BInt(7) % (-4), BInt(3))
        XCTAssertEqual(BInt(-7) % (-4), BInt(-3))
        XCTAssertEqual(BInt(7).mod(BInt(4)), BInt(3))
        XCTAssertEqual(BInt(-7).mod(BInt(4)), BInt(1))
        XCTAssertEqual(BInt(7).mod(BInt(-4)), BInt(3))
        XCTAssertEqual(BInt(-7).mod(BInt(-4)), BInt(1))
        XCTAssertEqual(BInt(7).mod(4), 3)
        XCTAssertEqual(BInt(-7).mod(4), 1)
        XCTAssertEqual(BInt(7).mod(-4), 3)
        XCTAssertEqual(BInt(-7).mod(-4), 1)
        XCTAssertEqual(BInt(8).mod(4), 0)
        XCTAssertEqual(BInt(-8).mod(4), 0)
        XCTAssertEqual(BInt(8).mod(-4), 0)
        XCTAssertEqual(BInt(-8).mod(-4), 0)
        doTest2(BInt(7), BInt(4))
        doTest2(BInt(-7), BInt(4))
        doTest2(BInt(7), BInt(-4))
        doTest2(BInt(-7), BInt(-4))
        doTest2(BInt(Limbs(repeating: UInt64.max, count: 50)), BInt(Limbs(repeating: UInt64.max, count: 35)))
    }
    
    func test3() {
        XCTAssertEqual(BInt(0) / BInt(7), BInt.ZERO)
        XCTAssertEqual(-BInt(0) / BInt(7), BInt.ZERO)
        XCTAssertEqual(BInt(0) / BInt(-7), BInt.ZERO)
        XCTAssertEqual(-BInt(0) / BInt(-7), BInt.ZERO)
        XCTAssertEqual(BInt(7) % BInt(7), BInt.ZERO)
        XCTAssertEqual(BInt(-7) % BInt(7), BInt.ZERO)
        XCTAssertEqual(BInt(7) % BInt(-7), BInt.ZERO)
        XCTAssertEqual(BInt(-7) % BInt(-7), BInt.ZERO)
        XCTAssertEqual(BInt(7) % 7, BInt.ZERO)
        XCTAssertEqual(BInt(-7) % 7, BInt.ZERO)
        XCTAssertEqual(BInt(7) % (-7), BInt.ZERO)
        XCTAssertEqual(BInt(-7) % (-7), BInt.ZERO)
    }
    
    func test4() {
        // a BInt modulo an Int
        for _ in 0 ..< 100 {
            let x = BInt(bitWidth: 1000)
            let m = x.magnitude[0] == 0 ? 1 : Int(x.magnitude[0] & 0x7fffffffffffffff)
            XCTAssertEqual(x.mod(m), x.mod(BInt(m)).asInt()!)
            XCTAssertEqual(x.mod(-m), x.mod(-BInt(m)).asInt()!)
        }
    }
    
}
