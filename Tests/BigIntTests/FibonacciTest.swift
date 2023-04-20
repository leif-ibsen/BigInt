//
//  FibonacciTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 18/05/2022.
//

import XCTest
@testable import BigInt

class FibonacciTest: XCTestCase {


    func simpleFib(_ n: Int) -> BInt {
        XCTAssertTrue(n >= 0)
        if n == 0 {
            return BInt.ZERO
        } else if n == 1 {
            return BInt.ONE
        } else {
            var t: Limbs = [0]
            var t1: Limbs = [0]
            var t2: Limbs = [1]
            for _ in 2 ... n {
                t = t1
                t.add(t2)
                t1 = t2
                t2 = t
            }
            return BInt(t)
        }
    }

    func simpleLucas(_ n: Int) -> BInt {
        XCTAssertTrue(n >= 0)
        if n == 0 {
            return BInt.TWO
        } else if n == 1 {
            return BInt.ONE
        } else {
            var t: Limbs = [0]
            var t1: Limbs = [2]
            var t2: Limbs = [1]
            for _ in 2 ... n {
                t = t1
                t.add(t2)
                t1 = t2
                t2 = t
            }
            return BInt(t)
        }
    }

    func testFibonacci() {
        for i in 0 ... 1000 {
            XCTAssertEqual(simpleFib(i), BInt.fibonacci(i))
            let (a, b) = BInt.fibonacci2(i)
            XCTAssertEqual(a + b, BInt.fibonacci(i + 2))
        }
    }

    func testLucas() {
        XCTAssertEqual(BInt.lucas(0), BInt.TWO)
        for i in 1 ... 1000 {
            XCTAssertEqual(simpleLucas(i), BInt.lucas(i))
            XCTAssertEqual(BInt.lucas(i), BInt.fibonacci(i - 1) + BInt.fibonacci(i + 1))
        }
    }


}
