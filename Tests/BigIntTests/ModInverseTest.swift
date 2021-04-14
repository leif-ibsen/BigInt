//
//  ModInverseTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 02/01/2019.
//

import XCTest

class ModInverseTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest(_ n: Int, _ m: Int) {
        for _ in 0 ..< 100 {
            let p1 = BInt.probablePrime(m)
            var x1 = BInt(bitWidth: n)
            if x1 == 0 {
                x1 = BInt(1)
            }
            if x1.gcd(p1) == BInt.ONE {
                XCTAssert((x1 * x1.modInverse(p1)).mod(p1) == BInt.ONE)
                XCTAssert(((-x1) * (-x1).modInverse(p1)).mod(p1) == BInt.ONE)
                if let pp1 = p1.asInt() {
                    XCTAssert(x1.modInverse(p1) == x1.modInverse(pp1))
                }
            }
        }
    }

    func test() {
        doTest(3, 4)
        doTest(30, 40)
        doTest(300, 400)
        doTest(4, 3)
        doTest(40, 30)
        doTest(400, 300)
    }

}
