//
//  DivExactTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 04/09/2022.
//

import XCTest

class DivExactTest: XCTestCase {

    func doTest(_ x: BInt, _ d: BInt) {
        let q = x.quotientExact(dividingBy: d)
        if x != q * d {
            print(x)
            print(d)
        }
        XCTAssertEqual(x, q * d)
    }

    func doTest(_ x: BInt, _ d: Int) {
        let q = x.quotientExact(dividingBy: BInt(d))
        XCTAssertEqual(x, q * d)
    }

    func doTest1(_ x: BInt, _ d: BInt) {
        doTest(x, d)
        doTest(x, -d)
        doTest(-x, d)
        doTest(-x, -d)
    }

    func doTest2(_ x: BInt, _ d: Int) {
        doTest(x, d)
        doTest(x, -d)
        doTest(-x, d)
        doTest(-x, -d)
    }

    func test1() {
        doTest1(BInt.ZERO, BInt.ONE)
        for _ in 0 ..< 100 {
            let x = BInt(bitWidth: 200)
            var d = BInt.ONE
            for _ in 0 ..< 10 {
                doTest1(x * d, d)
                doTest1(x * d, x)
                d *= 10
            }
        }
    }

    func test2() {
        doTest2(BInt.ZERO, 1)
        for _ in 0 ..< 100 {
            let x = BInt(bitWidth: 200)
            var d = 1
            for _ in 0 ..< 10 {
                doTest2(x * d, d)
                d *= 10
            }
        }
    }

}
