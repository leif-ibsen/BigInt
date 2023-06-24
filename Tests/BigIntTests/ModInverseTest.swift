//
//  ModInverseTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 02/01/2019.
//

import XCTest
@testable import BigInt

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
            if x1.gcd(p1) == BInt.one {
                XCTAssert((x1 * x1.modInverse(p1)).mod(p1) == BInt.one)
                XCTAssert(((-x1) * (-x1).modInverse(p1)).mod(p1) == BInt.one)
                if let pp1 = p1.asInt() {
                    XCTAssert(x1.modInverse(p1) == x1.modInverse(pp1))
                }
            }
            if x1.isEven {
                x1 += 1
            }
            for i in 1 ..< 12 {
                let m = BInt.one << i
                let q1 = x1.modInverse(m)
                let q2 = (-x1).modInverse(m)
                XCTAssertEqual((q1 * x1).mod(m), BInt.one)
                XCTAssertEqual((q2 * (-x1)).mod(m), BInt.one)
            }
        }
    }
    
    func test1() {
        doTest(3, 4)
        doTest(30, 40)
        doTest(300, 400)
        doTest(4, 3)
        doTest(40, 30)
        doTest(400, 300)
    }
    
    func test2() {
        XCTAssertEqual(BInt.two.modInverse(1), 0)
        XCTAssertEqual((-BInt.two).modInverse(1), 0)
        XCTAssertEqual(BInt.three.modInverse(1), 0)
        XCTAssertEqual((-BInt.three).modInverse(1), 0)
        XCTAssertEqual(BInt.two.modInverse(BInt.one), BInt.zero)
        XCTAssertEqual((-BInt.two).modInverse(BInt.one), BInt.zero)
        XCTAssertEqual(BInt.three.modInverse(BInt.one), BInt.zero)
        XCTAssertEqual((-BInt.three).modInverse(BInt.one), BInt.zero)
    }
    
    func test3() {
        let x1 = BInt.one << 20 + 1
        let x2 = BInt.one << 200 + 1
        for i in 0 ... 62 {
            let m = 1 << i
            XCTAssertEqual(BInt(x1.modInverse(m)), x1.modInverse(BInt(m)))
            XCTAssertEqual(BInt((-x1).modInverse(m)), (-x1).modInverse(BInt(m)))
            XCTAssertEqual(BInt(x2.modInverse(m)), x2.modInverse(BInt(m)))
            XCTAssertEqual(BInt((-x2).modInverse(m)), (-x2).modInverse(BInt(m)))
        }
    }
    
}
