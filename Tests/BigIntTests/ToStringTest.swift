//
//  ToStringTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 04/02/2019.
//

import XCTest

class ToStringTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testToString1() {
        var x = BInt(1)
        var s = "1"
        for _ in 0 ..< 100 {
            x *= 10
            s += "0"
            XCTAssertEqual(s, x.asString(radix: 10))
        }
    }
    
    func testToString2() {
        let x: Limbs = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        let b = BInt(x, false)
        for r in 2 ... 36 {
            let b1 = BInt(b.asString(radix: r), radix: r)
            XCTAssertEqual(b, b1)
        }
    }
    
    func testToString3() {
        let x: Limbs = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        let b = BInt(x, true)
        for r in 2 ... 36 {
            let b1 = BInt(b.asString(radix: r), radix: r)
            XCTAssertEqual(b, b1)
        }
    }

    func testToString4() {
        var bw = 10
        for _ in 0 ..< 10 {
            for _ in 0 ..< 100 {
                let x = BInt(bitWidth: bw)
                XCTAssertEqual(x, BInt(x.asString())!)
                XCTAssertEqual(-x, BInt((-x).asString())!)
            }
            bw *= 2
        }
    }

}
