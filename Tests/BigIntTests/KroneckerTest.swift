//
//  KroneckerTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 09/06/2022.
//

import XCTest
@testable import BigInt

class KroneckerTest: XCTestCase {

    // Wolfram Mathworld - Kronecker Symbol
    
    func doTest1(_ a: BInt, _ b: BInt, _ c: BInt, _ d: BInt) {
        let abcd = (a * b).kroneckerSymbol(c * d)
        let acd = a.kroneckerSymbol(c * d)
        let bcd = b.kroneckerSymbol(c * d)
        let abc = (a * b).kroneckerSymbol(c)
        let abd = (a * b).kroneckerSymbol(d)
        let ac = a.kroneckerSymbol(c)
        let bc = b.kroneckerSymbol(c)
        let ad = a.kroneckerSymbol(d)
        let bd = b.kroneckerSymbol(d)
        XCTAssertEqual(abcd, acd * bcd)
        XCTAssertEqual(abcd, abc * abd)
        XCTAssertEqual(abcd, ac * bc * ad * bd)
    }

    func doTest2(_ a: BInt, _ b: BInt, _ c: Int, _ d: Int) {
        let abcd = (a * b).kroneckerSymbol(c * d)
        let acd = a.kroneckerSymbol(c * d)
        let bcd = b.kroneckerSymbol(c * d)
        let abc = (a * b).kroneckerSymbol(c)
        let abd = (a * b).kroneckerSymbol(d)
        let ac = a.kroneckerSymbol(c)
        let bc = b.kroneckerSymbol(c)
        let ad = a.kroneckerSymbol(d)
        let bd = b.kroneckerSymbol(d)
        XCTAssertEqual(abcd, acd * bcd)
        XCTAssertEqual(abcd, abc * abd)
        XCTAssertEqual(abcd, ac * bc * ad * bd)
    }

    func doTest(_ a: Int, _ b: Int, _ c: Int, _ d: Int) {
        doTest1(BInt(a), BInt(b), BInt(c), BInt(d))
        doTest2(BInt(a), BInt(b), c, d)
    }

    func test1() {
        XCTAssertEqual(BInt.zero.kroneckerSymbol(BInt.zero), 0)
        XCTAssertEqual(BInt.one.kroneckerSymbol(BInt.zero), 1)
        XCTAssertEqual((-BInt.one).kroneckerSymbol(BInt.zero), 1)
        for n in 1 ... 100 {
            XCTAssertEqual(BInt(n).kroneckerSymbol(BInt.one), 1)
            XCTAssertEqual(BInt(-n).kroneckerSymbol(BInt.one), 1)
        }
        for k in 1 ... 100 {
            XCTAssertEqual(BInt.one.kroneckerSymbol(k), 1)
            XCTAssertEqual(BInt.one.kroneckerSymbol(-k), 1)
        }
    }

    func test2() {
        let b1000 = BInt(1000)
        for _ in 0 ..< 100 {
            let a = b1000.randomLessThan().asInt()!
            let b = b1000.randomLessThan().asInt()!
            let c = b1000.randomLessThan().asInt()!
            let d = b1000.randomLessThan().asInt()!
            doTest(a, b, c, d)
        }
    }

}
