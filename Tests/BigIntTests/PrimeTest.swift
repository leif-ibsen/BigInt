//
//  PrimeTest.swift
//  BigIntegerTests
//
//  Created by Leif Ibsen on 15/12/2018.
//

import XCTest
@testable import BigInt

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
        XCTAssertFalse(BInt(100).isProbablyPrime())
        XCTAssertFalse(BInt(100).isProbablyPrime(1))
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
    
    func test3() {
        XCTAssertEqual(BInt(-14).nextPrime(), BInt.two)
        var x = BInt.zero
        for _ in 0 ..< 1000 {
            let p = x.nextPrime()
            XCTAssertTrue(p.isProbablyPrime(100))
            var z = x + 1
            while z < p {
                XCTAssertFalse(z.isProbablyPrime(100))
                z += 1
            }
            x = p
        }
    }

    func test4() {
        for _ in 0 ..< 10 {
            let x = BInt(bitWidth: 100)
            let p = x.nextPrime()
            XCTAssertTrue(p.isProbablyPrime(100))
            var z = x + 1
            while z < p {
                XCTAssertFalse(z.isProbablyPrime(100))
                z += 1
            }
        }
    }
    
    func test5() {
        XCTAssertEqual(BInt.primorial(0), BInt(1))
        XCTAssertEqual(BInt.primorial(1), BInt(1))
        XCTAssertEqual(BInt.primorial(2), BInt(2))
        XCTAssertEqual(BInt.primorial(3), BInt(6))
        XCTAssertEqual(BInt.primorial(4), BInt(6))
        XCTAssertEqual(BInt.primorial(5), BInt(30))
        XCTAssertEqual(BInt.primorial(6), BInt(30))
        XCTAssertEqual(BInt.primorial(7), BInt(210))
        XCTAssertEqual(BInt.primorial(8), BInt(210))
        XCTAssertEqual(BInt.primorial(9), BInt(210))
        XCTAssertEqual(BInt.primorial(10), BInt(210))
        XCTAssertEqual(BInt.primorial(11), BInt(2310))
    }

}
