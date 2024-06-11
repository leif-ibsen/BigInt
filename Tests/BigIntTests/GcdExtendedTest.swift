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
        XCTAssertEqual(g2, a * x2 + (-b) * y2)
        XCTAssertEqual(g3, (-a) * x3 + b * y3)
        XCTAssertEqual(g4, (-a) * x4 + (-b) * y4)
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
        XCTAssertEqual(g2, a * x2 + (-b) * y2)
        XCTAssertEqual(g3, (-a) * x3 + b * y3)
        XCTAssertEqual(g4, (-a) * x4 + (-b) * y4)
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

}
