//
//  ComparisonTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 25/08/2022.
//

import XCTest

class ComparisonTest: XCTestCase {
    
    func doTest1(_ a: BInt, _ b: BInt) {
        let eq = a == b
        let ne = a != b
        let lt = a < b
        let le = a <= b
        let gt = a > b
        let ge = a >= b
        XCTAssertNotEqual(eq, ne)
        XCTAssertNotEqual(lt, eq || gt)
        XCTAssertNotEqual(gt, eq || lt)
        XCTAssertEqual(le, eq || lt)
        XCTAssertEqual(ge, eq || gt)
    }

    func doTest2(_ a: BInt, _ b: Int) {
        let eq = a == b
        let ne = a != b
        let lt = a < b
        let le = a <= b
        let gt = a > b
        let ge = a >= b
        XCTAssertNotEqual(eq, ne)
        XCTAssertNotEqual(lt, eq || gt)
        XCTAssertNotEqual(gt, eq || lt)
        XCTAssertEqual(le, eq || lt)
        XCTAssertEqual(ge, eq || gt)
    }

    func doTest3(_ a: Int, _ b: BInt) {
        let eq = a == b
        let ne = a != b
        let lt = a < b
        let le = a <= b
        let gt = a > b
        let ge = a >= b
        XCTAssertNotEqual(eq, ne)
        XCTAssertNotEqual(lt, eq || gt)
        XCTAssertNotEqual(gt, eq || lt)
        XCTAssertEqual(le, eq || lt)
        XCTAssertEqual(ge, eq || gt)
    }

    func test1() {
        doTest1(BInt.ZERO, BInt.ZERO)
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: 100)
            let b = BInt(bitWidth: 100)
            doTest1(a, a)
            doTest1(a, -a)
            doTest1(-a, a)
            doTest1(-a, -a)
            doTest1(a, b)
            doTest1(a, -b)
            doTest1(-a, b)
            doTest1(-a, -b)
        }
    }

    func test2() {
        doTest2(BInt.ZERO, 0)
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: 50)
            doTest2(a, 0)
            doTest2(a, 1)
            doTest2(a, -1)
            doTest2(a, Int.max)
            doTest2(a, Int.min)
            doTest2(-a, 0)
            doTest2(-a, 1)
            doTest2(-a, -1)
            doTest2(-a, Int.max)
            doTest2(-a, Int.min)
        }
    }
    
    func test3() {
        doTest3(0, BInt.ZERO)
        for _ in 0 ..< 10 {
            let b = BInt(bitWidth: 50)
            doTest3(0, b)
            doTest3(1, b)
            doTest3(-1, b)
            doTest3(Int.max, b)
            doTest3(Int.min, b)
            doTest3(0, -b)
            doTest3(1, -b)
            doTest3(-1, -b)
            doTest3(Int.max, -b)
            doTest3(Int.min, -b)
        }
    }

    func doTestEq(_ a: BInt, _ b: BInt) {
        let ia = a.asInt()!
        let ib = b.asInt()!
        XCTAssertEqual(a == b, ia == b)
        XCTAssertEqual(a == b, a == ib)
        XCTAssertEqual(a == -b, ia == -b)
        XCTAssertEqual(a == -b, a == -ib)
        XCTAssertEqual(-a == b, -ia == b)
        XCTAssertEqual(-a == b, -a == ib)
        XCTAssertEqual(-a == -b, -ia == -b)
        XCTAssertEqual(-a == -b, -a == -ib)
    }

    func doTestNe(_ a: BInt, _ b: BInt) {
        let ia = a.asInt()!
        let ib = b.asInt()!
        XCTAssertEqual(a != b, ia != b)
        XCTAssertEqual(a != b, a != ib)
        XCTAssertEqual(a != -b, ia != -b)
        XCTAssertEqual(a != -b, a != -ib)
        XCTAssertEqual(-a != b, -ia != b)
        XCTAssertEqual(-a != b, -a != ib)
        XCTAssertEqual(-a != -b, -ia != -b)
        XCTAssertEqual(-a != -b, -a != -ib)
    }

    func doTestLt(_ a: BInt, _ b: BInt) {
        let ia = a.asInt()!
        let ib = b.asInt()!
        XCTAssertEqual(a < b, ia < b)
        XCTAssertEqual(a < b, a < ib)
        XCTAssertEqual(a < -b, ia < -b)
        XCTAssertEqual(a < -b, a < -ib)
        XCTAssertEqual(-a < b, -ia < b)
        XCTAssertEqual(-a < b, -a < ib)
        XCTAssertEqual(-a < -b, -ia < -b)
        XCTAssertEqual(-a < -b, -a < -ib)
    }

    func doTestLe(_ a: BInt, _ b: BInt) {
        let ia = a.asInt()!
        let ib = b.asInt()!
        XCTAssertEqual(a <= b, ia <= b)
        XCTAssertEqual(a <= b, a <= ib)
        XCTAssertEqual(a <= -b, ia <= -b)
        XCTAssertEqual(a <= -b, a <= -ib)
        XCTAssertEqual(-a <= b, -ia <= b)
        XCTAssertEqual(-a <= b, -a <= ib)
        XCTAssertEqual(-a <= -b, -ia <= -b)
        XCTAssertEqual(-a <= -b, -a <= -ib)
    }

    func doTestGt(_ a: BInt, _ b: BInt) {
        let ia = a.asInt()!
        let ib = b.asInt()!
        XCTAssertEqual(a > b, ia > b)
        XCTAssertEqual(a > b, a > ib)
        XCTAssertEqual(a > -b, ia > -b)
        XCTAssertEqual(a > -b, a > -ib)
        XCTAssertEqual(-a > b, -ia > b)
        XCTAssertEqual(-a > b, -a > ib)
        XCTAssertEqual(-a > -b, -ia > -b)
        XCTAssertEqual(-a > -b, -a > -ib)
    }

    func doTestGe(_ a: BInt, _ b: BInt) {
        let ia = a.asInt()!
        let ib = b.asInt()!
        XCTAssertEqual(a >= b, ia >= b)
        XCTAssertEqual(a >= b, a >= ib)
        XCTAssertEqual(a >= -b, ia >= -b)
        XCTAssertEqual(a >= -b, a >= -ib)
        XCTAssertEqual(-a >= b, -ia >= b)
        XCTAssertEqual(-a >= b, -a >= ib)
        XCTAssertEqual(-a >= -b, -ia >= -b)
        XCTAssertEqual(-a >= -b, -a >= -ib)
    }

    func test4() {
        for _ in 0 ..< 100 {
            let a = BInt(bitWidth: 50)
            let b = BInt(bitWidth: 50)
            doTestEq(a, b)
            doTestNe(a, b)
            doTestLt(a, b)
            doTestLe(a, b)
            doTestGt(a, b)
            doTestGe(a, b)
        }
    }

}
