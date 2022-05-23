//
//  RootTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 11/09/2019.
//

import XCTest

class RootTest: XCTestCase {

    func test1() {
        for _ in 0 ..< 100 {
            let x = BInt(bitWidth: 20000)
            for n in 1 ... 10 {
                let y = x.root(n)
                XCTAssert(y ** n <= x)
                XCTAssert((y + 1) ** n > x)
                let (root, rem) = x.rootRemainder(n)
                XCTAssertEqual(root ** n + rem, x)
            }
            let x1 = -x
            for n in stride(from: 1, through: 11, by: 2) {
                let y = x1.root(n)
                XCTAssert(y ** n >= x1)
                XCTAssert((y - 1) ** n < x1)
                let (root, rem) = x1.rootRemainder(n)
                XCTAssertEqual(root ** n + rem, x1)
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
                let (root, rem) = x.sqrtRemainder()
                XCTAssertEqual(root ** 2 + rem, x)
            }
            bw *= 2
        }
    }
    
    func test4() {
        XCTAssert(BInt.ZERO.isPerfectSquare())
        XCTAssert(BInt.ONE.isPerfectSquare())
        XCTAssert(!(-BInt.ONE).isPerfectSquare())
        for i in 2 ..< 1000 {
            let x = BInt(i)
            let x1 = x + 1
            let x2 = x - 1
            XCTAssert((x * x).isPerfectSquare())
            XCTAssert(!(x * x1).isPerfectSquare())
            XCTAssert(!(x * x2).isPerfectSquare())
        }
    }

    func test5() {
        for i in 0 ..< 1000 {
            let x = BInt(i)
            let (root, rem) = x.sqrtRemainder()
            XCTAssertEqual(root * root + rem, x)
            XCTAssert(x.isPerfectSquare() || rem.isPositive)
            XCTAssert(!x.isPerfectSquare() || rem.isZero)
        }
    }

    func test6() {
        XCTAssert(BInt.ZERO.isPerfectRoot())
        XCTAssert(BInt.ONE.isPerfectRoot())
        XCTAssert((-BInt.ONE).isPerfectRoot())
        for i in 0 ..< 1000 {
            let x = BInt(i)
            let perfect = x.isPerfectRoot()
            for n in 2 ... 10 {
                XCTAssert((x ** n).isPerfectRoot())
                let (_, rem) = x.rootRemainder(n)
                XCTAssert(perfect || rem.isPositive)
            }
            let x1 = -x
            for n in stride(from: 1, through: 11, by: 2) {
                let y = x1.root(n)
                XCTAssert(y ** n >= x1)
                XCTAssert((y - 1) ** n < x1)
                let (root, rem) = x1.rootRemainder(n)
                XCTAssertEqual(root ** n + rem, x1)
            }
        }
    }

}
