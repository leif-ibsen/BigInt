//
//  JacobiTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 24/01/2021.
//

import XCTest

class JacobiTest: XCTestCase {

    func doTest1(_ a: Int, _ b: Int, _ m: Int, _ n: Int) {
        let am = BInt(a).jacobiSymbol(m)
        let bm = BInt(b).jacobiSymbol(m)
        let an = BInt(a).jacobiSymbol(n)
        let abm = (BInt(a) * b).jacobiSymbol(m)
        let amn = BInt(a).jacobiSymbol(m * n)
        XCTAssertEqual(abm, am * bm)
        XCTAssertEqual(amn, am * an)
    }

    func doTest2(_ a: Int, _ b: Int, _ m: BInt, _ n: BInt) {
        let am = BInt(a).jacobiSymbol(m)
        let bm = BInt(b).jacobiSymbol(m)
        let an = BInt(a).jacobiSymbol(n)
        let abm = (BInt(a) * b).jacobiSymbol(m)
        let amn = BInt(a).jacobiSymbol(m * n)
        XCTAssertEqual(abm, am * bm)
        XCTAssertEqual(amn, am * an)
    }

    func doTest(_ a: Int, _ b: Int, _ m: Int, _ n: Int) {
        doTest1(a, b, m, n)
        doTest2(a, b, BInt(m), BInt(n))
    }

    func test1() {
        doTest(0, 0, 5, 11)
        doTest(3, 4, 5, 11)
        doTest(0, 0, 33, 11)
        doTest(3, 4, 33, 11)
    }

    func test2() {
        let b1000 = BInt(1000)
        for _ in 0 ..< 100 {
            let a = b1000.randomLessThan().asInt()!
            let b = b1000.randomLessThan().asInt()!
            var m = b1000.randomLessThan().asInt()!
            if m & 1 == 0 {
                m += 1
            }
            var n = b1000.randomLessThan().asInt()!
            if n & 1 == 0 {
                n += 1
            }
            doTest(a, b, m, n)
            doTest(-a, b, m, n)
            doTest(a, -b, m, n)
            doTest(-a, -b, m, n)
        }
    }
}
