//
//  KaratsubaTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 15/02/2019.
//

import XCTest

class KaratsubaTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: (Limbs.KA_THR + Limbs.TC_THR) / 2 * 64)
            let b = BInt(bitWidth: (Limbs.KA_THR + Limbs.TC_THR) / 2 * 64)
            let p = a * b
            let (q, r) = p.quotientAndRemainder(dividingBy: a)
            XCTAssertEqual(q, b)
            XCTAssertEqual(r, BInt.ZERO)
        }
    }
    
    func test2() {
        for _ in 0 ..< 10 {
            let a = BInt(bitWidth: (Limbs.KA_THR + Limbs.TC_THR) / 2 * 64)
            let p = a ** 2
            let (q, r) = p.quotientAndRemainder(dividingBy: a)
            XCTAssertEqual(q, a)
            XCTAssertEqual(r, BInt.ZERO)
        }
    }


}
