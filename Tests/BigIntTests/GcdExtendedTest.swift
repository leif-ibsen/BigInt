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

    func doTest(_ a: BInt, _ b: BInt) {
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
        doTest(BInt.ZERO, BInt.ZERO)
        doTest(BInt.ZERO, BInt.ONE)
        doTest(BInt.ONE, BInt.ZERO)
        doTest(BInt.ONE, BInt.ONE)
        for _ in 0 ..< 100 {
            let a = BInt(bitWidth: 100)
            doTest(a, BInt.ZERO)
            doTest(a, BInt.ONE)
            doTest(a, BInt.TWO)
            for _ in 0 ..< 100 {
                let b = BInt(bitWidth: 100)
                doTest(a, b)
            }
        }
    }

}
