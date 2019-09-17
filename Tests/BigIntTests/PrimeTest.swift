//
//  PrimeTest.swift
//  BigIntegerTests
//
//  Created by Leif Ibsen on 15/12/2018.
//

import XCTest

class PrimeTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doMersenne(_ x: Int) {
        XCTAssertTrue((BInt(1) << x - 1).isProbablyPrime())
        XCTAssertTrue(!(BInt(1) << x + 1).isProbablyPrime())
    }
    func test1() {
        XCTAssertTrue(BInt(100).isProbablyPrime(0))
        XCTAssertTrue(!BInt(100).isProbablyPrime())
        for i in 1 ... 5 {
            XCTAssertTrue(BInt.probablePrime(100 * i).isProbablyPrime())
        }
    }

    func test2() {
        doMersenne(3)
        doMersenne(5)
        doMersenne(7)
        doMersenne(13)
        doMersenne(17)
        doMersenne(19)
        doMersenne(31)
        doMersenne(61)
        doMersenne(89)
        doMersenne(107)
        doMersenne(127)
        doMersenne(521)
    }

}
