//
//  GcdExtendedTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 05/08/2022.
//

import XCTest
@testable import BigInt

class GcdExtendedTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest1(_ a: BInt, _ b: BInt) {
        let g1 = a.gcd(b)
        let g2 = a.gcd(-b)
        let g3 = (-a).gcd(b)
        let g4 = (-a).gcd(-b)
        let (ge1, x1, y1) = a.gcdExtended(b)
        let (ge2, x2, y2) = a.gcdExtended(-b)
        let (ge3, x3, y3) = (-a).gcdExtended(b)
        let (ge4, x4, y4) = (-a).gcdExtended(-b)
        XCTAssertEqual(g1, ge1)
        XCTAssertEqual(g2, ge2)
        XCTAssertEqual(g3, ge3)
        XCTAssertEqual(g4, ge4)
        XCTAssertEqual(g1, a * x1 + b * y1)
        if g1.isNotZero {
            XCTAssertTrue(x1.abs <= (b / g1).abs || a == 0 || b == 0)
            XCTAssertTrue(y1.abs <= (a / g1).abs || a == 0 || b == 0)
        }
        XCTAssertEqual(g2, a * x2 + (-b) * y2)
        if g2.isNotZero {
            XCTAssertTrue(x2.abs <= (b / g2).abs || a == 0 || b == 0)
            XCTAssertTrue(y2.abs <= (a / g2).abs || a == 0 || b == 0)
        }
        XCTAssertEqual(g3, (-a) * x3 + b * y3)
        if g3.isNotZero {
            XCTAssertTrue(x3.abs <= (b / g3).abs || a == 0 || b == 0)
            XCTAssertTrue(y3.abs <= (a / g3).abs || a == 0 || b == 0)
        }
        XCTAssertEqual(g4, (-a) * x4 + (-b) * y4)
        if g4.isNotZero {
            XCTAssertTrue(x4.abs <= (b / g4).abs || a == 0 || b == 0)
            XCTAssertTrue(y4.abs <= (a / g4).abs || a == 0 || b == 0)
        }
    }

    func doTest2(_ a: BInt, _ b: Int) {
        let g1 = a.gcd(b)
        let g2 = a.gcd(-b)
        let g3 = (-a).gcd(b)
        let g4 = (-a).gcd(-b)
        let (ge1, x1, y1) = a.gcdExtended(b)
        let (ge2, x2, y2) = a.gcdExtended(-b)
        let (ge3, x3, y3) = (-a).gcdExtended(b)
        let (ge4, x4, y4) = (-a).gcdExtended(-b)
        XCTAssertEqual(g1, ge1)
        XCTAssertEqual(g2, ge2)
        XCTAssertEqual(g3, ge3)
        XCTAssertEqual(g4, ge4)
        XCTAssertEqual(g1, a * x1 + b * y1)
        if g1.isNotZero {
            XCTAssertTrue(x1.abs <= (b / g1).abs || a == 0 || b == 0)
            XCTAssertTrue(y1.abs <= (a / g1).abs || a == 0 || b == 0)
        }
        XCTAssertEqual(g2, a * x2 + (-b) * y2)
        if g2.isNotZero {
            XCTAssertTrue(x2.abs <= (b / g2).abs || a == 0 || b == 0)
            XCTAssertTrue(y2.abs <= (a / g2).abs || a == 0 || b == 0)
        }
        XCTAssertEqual(g3, (-a) * x3 + b * y3)
        if g3.isNotZero {
            XCTAssertTrue(x3.abs <= (b / g3).abs || a == 0 || b == 0)
            XCTAssertTrue(y3.abs <= (a / g3).abs || a == 0 || b == 0)
        }
        XCTAssertEqual(g4, (-a) * x4 + (-b) * y4)
        if g4.isNotZero {
            XCTAssertTrue(x4.abs <= (b / g4).abs || a == 0 || b == 0)
            XCTAssertTrue(y4.abs <= (a / g4).abs || a == 0 || b == 0)
        }
    }

    func test1() {
        doTest1(BInt.ZERO, BInt.ZERO)
        doTest1(BInt.ZERO, BInt.ONE)
        doTest1(BInt.ONE, BInt.ZERO)
        doTest1(BInt.ONE, BInt.ONE)
        for _ in 0 ..< 100 {
            let a = BInt(bitWidth: 100)
            doTest1(a, BInt.ZERO)
            doTest1(a, BInt.ONE)
            doTest1(a, BInt.TWO)
            for _ in 0 ..< 100 {
                let b = BInt(bitWidth: 100)
                doTest1(a, b)
            }
        }
    }

    func test2() {
        doTest2(BInt.ZERO, 0)
        doTest2(BInt.ZERO, 1)
        doTest2(BInt.ONE, 0)
        doTest2(BInt.ONE, 1)
        for _ in 0 ..< 100 {
            let a = BInt(bitWidth: 100)
            doTest2(a, 0)
            doTest2(a, 1)
            doTest2(a, 2)
            for _ in 0 ..< 100 {
                let b = BInt(bitWidth: 60).asInt()!
                doTest2(a, b)
            }
        }
    }
    
    func doTest3(_ x: BInt, _ y: BInt) {
        var (g1, a1, b1) = x.recursiveGCDext(y)
        var (g2, a2, b2) = x.lehmerGCDext(y)
        XCTAssertEqual(g1, g2)
        XCTAssertEqual(a1, a2)
        XCTAssertEqual(b1, b2)
        XCTAssertEqual(g1, a1 * x + b1 * y)
        (g1, a1, b1) = x.recursiveGCDext(-y)
        (g2, a2, b2) = x.lehmerGCDext(-y)
        XCTAssertEqual(g1, g2)
        XCTAssertEqual(a1, a2)
        XCTAssertEqual(b1, b2)
        XCTAssertEqual(g1, a1 * x + b1 * (-y))
        (g1, a1, b1) = (-x).recursiveGCDext(y)
        (g2, a2, b2) = (-x).lehmerGCDext(y)
        XCTAssertEqual(g1, g2)
        XCTAssertEqual(a1, a2)
        XCTAssertEqual(b1, b2)
        XCTAssertEqual(g1, a1 * (-x) + b1 * y)
        (g1, a1, b1) = (-x).recursiveGCDext(-y)
        (g2, a2, b2) = (-x).lehmerGCDext(-y)
        XCTAssertEqual(g1, g2)
        XCTAssertEqual(a1, a2)
        XCTAssertEqual(b1, b2)
        XCTAssertEqual(g1, a1 * (-x) + b1 * (-y))
    }

    // Recursive extended GCD and Lehmer extended GCD must give same result
    func testRecursiveGCD() {
        var bw = BInt.RECURSIVE_GCD_EXT_LIMIT << 6
        for _ in 0 ..< 5 {
            let x = BInt(bitWidth: bw)
            let y = BInt(bitWidth: bw)
            doTest3(x, y)
            doTest3(x * y, y)
            doTest3(x, x * y)
            bw *= 2
        }
    }

}
