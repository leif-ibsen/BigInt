//
//  ToByteArrayTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 05/09/2019.
//

import XCTest

class ToByteArrayTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        for _ in 0 ..< 10000 {
            let x = BInt(bitWidth: 1000)
            let x1 = BInt(magnitude: x.asMagnitudeBytes())
            XCTAssertEqual(x, x1)
            let x2 = BInt(signed: x.asSignedBytes())
            XCTAssertEqual(x, x2)
        }
    }

    func test2() {
        for _ in 0 ..< 10000 {
            let x = -BInt(bitWidth: 1000)
            let x1 = -BInt(magnitude: x.asMagnitudeBytes())
            XCTAssertEqual(x, x1)
            let x2 = BInt(signed: x.asSignedBytes())
            XCTAssertEqual(x, x2)
        }
    }

}
