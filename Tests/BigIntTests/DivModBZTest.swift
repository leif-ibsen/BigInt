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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest1(_ dividend: BInt, _ divisor: BInt) {
        var q1: Limbs = []
        var r1: Limbs = []
        var q2: Limbs = []
        var r2: Limbs = []
        (q1, r1) = dividend.magnitude.divMod(divisor.magnitude)
        (q2, r2) = dividend.magnitude.bzDivMod(divisor.magnitude)
        XCTAssertEqual(q1, q2)
        XCTAssertEqual(r1, r2)
    }

    func test1() {
        for _ in 0 ..< 1000 {
            let x = BInt(bitWidth: 2 * (Limbs.BZ_DIV_LIMIT + 1) * 64)
            let y = BInt(bitWidth: (Limbs.BZ_DIV_LIMIT + 1) * 64)
            doTest1(x, y)
        }
        doTest1(BInt(Limbs(repeating: UInt64.max, count: 2 * (Limbs.BZ_DIV_LIMIT + 1))), BInt(Limbs(repeating: UInt64.max, count: Limbs.BZ_DIV_LIMIT + 1)))
    }

    func test2() {
        var n = 2
        for _ in 0 ..< 8 {
            let y1 = BInt.ONE << ((Limbs.BZ_DIV_LIMIT + 1) * 64 * n)
            let y2 = BInt(bitWidth: (Limbs.BZ_DIV_LIMIT + 1) * 64 * n)
            n *= 2
            let x1 = BInt.ONE << ((Limbs.BZ_DIV_LIMIT + 1) * 64 * n)
            let x2 = BInt(bitWidth: (Limbs.BZ_DIV_LIMIT + 1) * 64 * n)
            doTest1(x1, y1)
            doTest1(x1, y2)
            doTest1(x2, y1)
            doTest1(x2, y2)
        }
    }

}
