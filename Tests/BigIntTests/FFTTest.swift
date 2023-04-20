//
//  FFTTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 09/11/2021.
//

import XCTest
@testable import BigInt

class FFTTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: Limbs.FFT_THR * 2 * 64)
            let b = BInt(bitWidth: Limbs.FFT_THR * 2 * 64)
            let p = a * b
            XCTAssertEqual(p, b * a)
            let (q, r) = p.quotientAndRemainder(dividingBy: a)
            XCTAssertEqual(q, b)
            XCTAssertEqual(r, BInt.ZERO)
        }
    }

    func test2() {
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: Limbs.FFT_THR * 2 * 64)
            let p = a ** 2
            let (q, r) = p.quotientAndRemainder(dividingBy: a)
            XCTAssertEqual(q, a)
            XCTAssertEqual(r, BInt.ZERO)
        }
    }

    func test3() {
        let b1 = BInt([0xffffffffffffffff]) << (Limbs.FFT_THR * 64)
        let b2 = BInt([0x8000000000000000]) << (Limbs.FFT_THR * 64)
        XCTAssertEqual(b1 * b1, b1 ** 2)
        XCTAssertEqual(b2 * b2, b2 ** 2)
        let x = b1 * b2
        XCTAssertEqual(x, b2 * b1)
        let (q1, r1) = x.quotientAndRemainder(dividingBy: b1)
        XCTAssertEqual(q1, b2)
        XCTAssertEqual(r1, BInt.ZERO)
        let (q2, r2) = x.quotientAndRemainder(dividingBy: b2)
        XCTAssertEqual(q2, b1)
        XCTAssertEqual(r2, BInt.ZERO)
    }

    // FFT and ToomCook must give same result
    func test4() {
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: (Limbs.FFT_THR + 1) * 64)
            let b = BInt(bitWidth: (Limbs.FFT_THR + 1) * 64)
            let p = a * b
            let pTC = BInt(a.magnitude.toomCookTimes(b.magnitude))
            XCTAssertEqual(p, pTC)
        }
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: (Limbs.FFT_THR + 1) * 64)
            let p = a ** 2
            let pTC = BInt(a.magnitude.toomCookSquare())
            XCTAssertEqual(p, pTC)
        }
    }
    
    func test5() {
        var prod = BInt.ONE
        var x = [BInt](repeating: BInt.ZERO, count: 10)
        for i in 0 ..< 10 {
            x[i] = BInt(bitWidth: (Limbs.FFT_THR + 1) * 64)
            prod *= x[i]
        }
        var q = prod
        var r = BInt.ZERO
        for i in 0 ..< 10 {
            (q, r) = q.quotientAndRemainder(dividingBy: x[i])
            XCTAssertEqual(r, BInt.ZERO)
        }
        XCTAssertEqual(q, BInt.ONE)
    }

}
