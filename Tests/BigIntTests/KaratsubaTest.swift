//
//  KaratsubaTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 15/02/2019.
//

import XCTest
@testable import BigInt

class KaratsubaTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: (Limbs.KA_THR + 1) * 64)
            let b = BInt(bitWidth: (Limbs.KA_THR + 1) * 64)
            let p = a * b
            XCTAssertEqual(p, b * a)
            let (q, r) = p.quotientAndRemainder(dividingBy: a)
            XCTAssertEqual(q, b)
            XCTAssertEqual(r, BInt.zero)
        }
    }
    
    func test2() {
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: (Limbs.KA_THR + 1) * 64)
            let p = a ** 2
            let (q, r) = p.quotientAndRemainder(dividingBy: a)
            XCTAssertEqual(q, a)
            XCTAssertEqual(r, BInt.zero)
        }
    }
    
    func test3() {
        let b1 = BInt([0xffffffffffffffff]) << (Limbs.KA_THR * 64)
        let b2 = BInt([0x8000000000000000]) << (Limbs.KA_THR * 64)
        XCTAssertEqual(b1 * b1, b1 ** 2)
        XCTAssertEqual(b2 * b2, b2 ** 2)
        let x = b1 * b2
        XCTAssertEqual(x, b2 * b1)
        let (q1, r1) = x.quotientAndRemainder(dividingBy: b1)
        XCTAssertEqual(q1, b2)
        XCTAssertEqual(r1, BInt.zero)
        let (q2, r2) = x.quotientAndRemainder(dividingBy: b2)
        XCTAssertEqual(q2, b1)
        XCTAssertEqual(r2, BInt.zero)
    }

    // Karatsuba and ToomCook must give same result
    func test4() {
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: (Limbs.KA_THR + 1) * 64)
            let b = BInt(bitWidth: (Limbs.KA_THR + 1) * 64)
            let p = a * b
            let pTC = BInt(a.mag.toomCookTimes(b.mag))
            XCTAssertEqual(p, pTC)
        }
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: (Limbs.KA_THR + 1) * 64)
            let p = a ** 2
            let pTC = BInt(a.mag.toomCookSquare())
            XCTAssertEqual(p, pTC)
        }
    }

}
