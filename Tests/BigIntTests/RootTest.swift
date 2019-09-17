//
//  RootTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 11/09/2019.
//

import XCTest

class RootTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        for _ in 0 ..< 1000 {
            let x = BInt(bitWidth: 1000)
            let y = x.sqrt()
            XCTAssert(y * y <= x)
            XCTAssert((y + 1) * (y + 1) > x)
            for n in 1 ... 10 {
                let y = x.root(n)
                XCTAssert(y ** n <= x)
                XCTAssert((y + 1) ** n > x)
            }
        }
    }

    func test2() {
        for _ in 0 ..< 100 {
            let p = BInt.probablePrime(100)
            for _ in 0 ..< 100 {
                let x = BInt(bitWidth: 300)
                let s = x.sqrtMod(p)
                XCTAssert(x.jacobiSymbol(p) != 1 || (s! ** 2).mod(p) == x.mod(p))
            }
        }
    }

}
