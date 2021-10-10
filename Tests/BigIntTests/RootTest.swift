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
        for _ in 0 ..< 100 {
            let x = BInt(bitWidth: 20000)
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
                let j = x.jacobiSymbol(p)
                XCTAssert(j == 1 || s == nil)
                XCTAssert(j != 1 || (s! ** 2).mod(p) == x.mod(p))
            }
        }
    }
    
    func test3() {
        var bw = 2
        for _ in 0 ..< 20 {
            for _ in 0 ..< 10 {
                let x = BInt(bitWidth: bw)
                XCTAssertEqual((x ** 2).sqrt(), x)
                let s = x.sqrt()
                XCTAssert(s ** 2 <= x)
                XCTAssert((s + 1) ** 2 >  x)
            }
            bw *= 2
        }
    }

}
