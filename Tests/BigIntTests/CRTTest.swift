//
//  CRTTest.swift
//  
//
//  Created by Leif Ibsen on 26/04/2023.
//

import XCTest
@testable import BigInt

final class CRTTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest1(_ n: Int) {
        var p = [BInt](repeating: BInt.ZERO, count: 4)
        p[0] = BInt.probablePrime(n)
        p[1] = BInt.probablePrime(2 * n)
        p[2] = BInt.probablePrime(3 * n)
        p[3] = p[0] + 1
        let crt = CRT(p)!
        var a1 = [BInt](repeating: BInt.ZERO, count: 4)
        var a2 = [BInt](repeating: BInt.ZERO, count: 4)
        for i in 0 ..< 4 {
            a1[i] = p[0].randomLessThan()
            a2[i] = -a1[i]
        }
        let x1 = crt.compute(a1)
        let x2 = crt.compute(a2)
        for i in 0 ..< 4 {
            XCTAssertEqual(x1.mod(p[i]), a1[i].mod(p[i]))
            XCTAssertEqual(x2.mod(p[i]), a2[i].mod(p[i]))
        }
    }

    func doTest2(_ n: Int) {
        var p = [Int](repeating: 0, count: 4)
        p[0] = (BInt.probablePrime(n)).asInt()!
        p[1] = (BInt.probablePrime(2 * n)).asInt()!
        p[2] = (BInt.probablePrime(3 * n)).asInt()!
        p[3] = p[0] + 1
        let crt = CRT(p)!
        var a1 = [Int](repeating: 0, count: 4)
        var a2 = [Int](repeating: 0, count: 4)
        for i in 0 ..< 4 {
            a1[i] = Int.random(in: 0 ..< p[0])
            a2[i] = -a1[i]
        }
        let x1 = crt.compute(a1)
        let x2 = crt.compute(a2)
        for i in 0 ..< 4 {
            XCTAssertEqual(x1.mod(p[i]), BInt(a1[i]).mod(p[i]))
            XCTAssertEqual(x2.mod(p[i]), BInt(a2[i]).mod(p[i]))
        }
    }

    func test1() {
        doTest1(50)
        doTest1(100)
        doTest1(200)
    }

    func test2() {
        doTest2(20)
    }

    func test3() {
        let p = [3, 5, 7]
        let a = [Int.min, 0, Int.max]
        let crt = CRT(p)!
        let x = crt.compute(a)
        for i in 0 ..< 3 {
            XCTAssertEqual(x.mod(p[i]), BInt(a[i]).mod(p[i]))
        }
    }
}
