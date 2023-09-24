//
//  DivModBZTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 05/12/2021.
//

import XCTest
@testable import BigInt

// Test of the Burnikel-Ziegler division algorithm
// Tests are performed by verifying that the result of using Burnikel-Ziegler
// is the same as the result of using basecase division - which is Knuth algorithm D

class DivModBZTest: XCTestCase {

    let b1 = BInt("1ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", radix: 16)!
    let b2 = BInt("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", radix: 16)!

    func doTest1(_ dividend: BInt, _ divisor: BInt) {
        var q1: Limbs = []
        var r1: Limbs = []
        var q2: BInt
        var r2: BInt
        (q1, r1) = dividend.magnitude.divMod(divisor.magnitude)
        (q2, r2) = dividend.bzDivMod(divisor)
        XCTAssertEqual(q1, q2.magnitude)
        XCTAssertEqual(r1, r2.magnitude)
    }

    func doTest2(_ dividend: BInt, _ divisor: BInt) {
        let (q, r) = dividend.quotientAndRemainder(dividingBy: divisor)
        XCTAssertEqual(dividend, divisor * q + r)
    }

    func test1() {
        for _ in 0 ..< 1000 {
            let x = BInt(bitWidth: 2 * (BInt.BZ_DIV_LIMIT + 1) * 64)
            let y = BInt(bitWidth: (BInt.BZ_DIV_LIMIT + 1) * 64)
            doTest1(x, y)
            doTest2(x, y)
            doTest2(x, -y)
            doTest2(-x, y)
            doTest2(-x, -y)
        }
        doTest1(BInt(Limbs(repeating: UInt64.max, count: 2 * (BInt.BZ_DIV_LIMIT + 1))), BInt(Limbs(repeating: UInt64.max, count: BInt.BZ_DIV_LIMIT + 1)))
    }

    func test2() {
        var n = 2
        for _ in 0 ..< 8 {
            let y1 = BInt.ONE << ((BInt.BZ_DIV_LIMIT + 1) * 64 * n)
            let y2 = BInt(bitWidth: (BInt.BZ_DIV_LIMIT + 1) * 64 * n)
            n *= 2
            let x1 = BInt.ONE << ((BInt.BZ_DIV_LIMIT + 1) * 64 * n)
            let x2 = BInt(bitWidth: (BInt.BZ_DIV_LIMIT + 1) * 64 * n)
            doTest1(x1, y1)
            doTest1(x1, y2)
            doTest1(x2, y1)
            doTest1(x2, y2)
        }
    }
    
    // This test used to fail in release 1.13.0
    func test3() {
        doTest2(b1 * b1, b1)
        doTest2(b2 * b2, b2)
    }

}
