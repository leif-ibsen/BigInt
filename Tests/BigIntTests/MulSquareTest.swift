//
//  MulSquareTest.swift
//  BigIntegerTests
//
//  Created by Leif Ibsen on 19/12/2018.
//

import XCTest

class MulSquareTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        for i in 1 ... 10 {
            let a1 = (BInt(1) << (i * 10)).randomLessThan()
            let a2 = (BInt(1) << (i * 100)).randomLessThan()
            let a3 = (BInt(1) << (i * 1000)).randomLessThan()
            let a4 = (BInt(1) << (i * 10000)).randomLessThan()
            let a5 = (BInt(1) << (i * 100000)).randomLessThan()
            let b1 = -a1
            let b2 = -a2
            let b3 = -a3
            let b4 = -a4
            let b5 = -a5
            XCTAssertEqual(a1 ** 2, a1 * a1)
            XCTAssertEqual(a2 ** 2, a2 * a2)
            XCTAssertEqual(a3 ** 2, a3 * a3)
            XCTAssertEqual(a4 ** 2, a4 * a4)
            XCTAssertEqual(a5 ** 2, a5 * a5)
            XCTAssertEqual(b1 ** 2, b1 * b1)
            XCTAssertEqual(b2 ** 2, b2 * b2)
            XCTAssertEqual(b3 ** 2, b3 * b3)
            XCTAssertEqual(b4 ** 2, b4 * b4)
            XCTAssertEqual(b5 ** 2, b5 * b5)
        }
    }

    func test2() {
        var b1 = BInt(1)
        let a1 = BInt(bitWidth: 100)
        for i in 0 ..< 10 {
            XCTAssertEqual(a1 ** i, b1)
            b1 *= a1
        }
    }

}
