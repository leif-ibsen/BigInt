//
//  FractionTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 28/06/2022.
//

import XCTest

class FractionTest: XCTestCase {
    
    func doTestInit(_ n: Int, _ d: Int) {
        XCTAssertEqual(BFraction(n, d), BFraction(BInt(n), BInt(d)))
        XCTAssertEqual(BFraction(n, d), BFraction(n, BInt(d)))
        XCTAssertEqual(BFraction(n, d), BFraction(BInt(n), d))
    }
    
    func testInit() {
        doTestInit(0, 1)
        doTestInit(1, 1)
        doTestInit(-1, 1)
        doTestInit(0, -1)
        doTestInit(1, -1)
        doTestInit(-1, -1)
        doTestInit(Int.max, Int.max)
        doTestInit(Int.max, Int.min)
        doTestInit(Int.min, Int.max)
        doTestInit(Int.min, Int.min)
        for _ in 0 ..< 10 {
            let n = BInt(bitWidth: 100)
            let d = BInt(bitWidth: 100) + 1
            let f1 = BFraction(n, d)
            XCTAssertEqual(f1.numerator.gcd(f1.denominator), BInt.ONE)
            XCTAssert(f1.denominator.isPositive)
            let f2 = BFraction(0, d)
            XCTAssertEqual(f2.numerator, BInt.ZERO)
            XCTAssertEqual(f2.denominator, BInt.ONE)
        }
        for _ in 0 ..< 10 {
            let d = Double.random(in: -100.0 ... 100.0)
            let f = BFraction(d)!
            XCTAssertEqual(f.numerator.gcd(f.denominator), BInt.ONE)
            XCTAssert(f.denominator.isPositive)
            XCTAssert(f.abs <= 100)
        }
        XCTAssertNil(BFraction(0.0 / 0.0))
        XCTAssertNil(BFraction(1.0 / 0.0))
        XCTAssertEqual(BFraction(0.1)!, BFraction(
            BInt("1000000000000000055511151231257827021181583404541015625")!, BInt(10) ** 55))
        XCTAssertEqual(BFraction(0.1)!, BFraction(3602879701896397, 36028797018963968))
        XCTAssertTrue(BFraction(0.0)!.isZero)
        XCTAssertTrue(BFraction(-0.0)!.isZero)
    }
    
    func testCompare() {
        for _ in 0 ..< 10 {
            let n = BInt(bitWidth: 100)
            let d = BInt(bitWidth: 100)
            let g = n.gcd(d)
            let f = BFraction(n, d)
            let x = BFraction(0.1)!
            XCTAssertTrue(f == BFraction(n / g, d / g))
            XCTAssertTrue(f < f + x)
            XCTAssertTrue(f > f - x)
        }
        XCTAssertTrue(BFraction(1, 10) < BFraction(0.1)!)
    }
    
    func testRounding() {
        XCTAssertTrue(BFraction.ZERO.round() == 0)
        XCTAssertTrue(BFraction.ZERO.truncate() == 0)
        XCTAssertTrue(BFraction.ZERO.ceil() == 0)
        XCTAssertTrue(BFraction.ZERO.floor() == 0)
        XCTAssertTrue(BFraction.ONE.round() == 1)
        XCTAssertTrue(BFraction.ONE.truncate() == 1)
        XCTAssertTrue(BFraction.ONE.ceil() == 1)
        XCTAssertTrue(BFraction.ONE.floor() == 1)
        XCTAssertTrue(BFraction(-1, 1).round() == -1)
        XCTAssertTrue(BFraction(-1, 1).truncate() == -1)
        XCTAssertTrue(BFraction(-1, 1).ceil() == -1)
        XCTAssertTrue(BFraction(-1, 1).floor() == -1)
        for _ in 0 ..< 1000 {
            let n = BInt(bitWidth: 100)
            let d = BInt(bitWidth: 100) + 1
            let f1 = BFraction(n, d)
            let f2 = -f1
            let round1 = f1.round()
            let round2 = f2.round()
            let trunc1 = f1.truncate()
            let trunc2 = f2.truncate()
            let ceil1 = f1.ceil()
            let ceil2 = f2.ceil()
            let floor1 = f1.floor()
            let floor2 = f2.floor()
            XCTAssertTrue(round1 == ceil1 || round1 == floor1)
            XCTAssertTrue(round2 == ceil2 || round2 == floor2)
            XCTAssertTrue(trunc1 == floor1)
            XCTAssertTrue(trunc2 == ceil2)
            XCTAssertTrue(ceil1 >= round1)
            XCTAssertTrue(ceil1 >= trunc1)
            XCTAssertTrue(ceil1 >= floor1)
            XCTAssertTrue(floor1 <= round1)
            XCTAssertTrue(floor1 <= trunc1)
            XCTAssertTrue(floor1 <= ceil1)
            XCTAssertTrue((round1 - f1).abs < 1)
            XCTAssertTrue((round2 - f2).abs < 1)
            XCTAssertTrue((trunc1 - f1).abs < 1)
            XCTAssertTrue((trunc2 - f2).abs < 1)
            XCTAssertTrue((ceil1 - f1).abs < 1)
            XCTAssertTrue((ceil2 - f2).abs < 1)
            XCTAssertTrue((floor1 - f1).abs < 1)
            XCTAssertTrue((floor2 - f2).abs < 1)
        }
    }
    
    func testArithmetic() {
        // (a + b) * c = a * c + b * c
        // (a - b) * c = a * c - b * c
        // (a + b) / c = a / c + b / c
        // (a - b) / c = a / c - b / c
        for _ in 0 ..< 1000 {
            let na = BInt(bitWidth: 200)
            let da = BInt(bitWidth: 200) + 1
            let nb = BInt(bitWidth: 200)
            let db = BInt(bitWidth: 200) + 1
            let nc = BInt(bitWidth: 100)
            let dc = BInt(bitWidth: 100) + 1
            let fa = BFraction(na, da)
            let fb = BFraction(nb, db)
            let fc = BFraction(nc, dc)
            XCTAssertEqual((fa + fb) * fc, fa * fc + fb * fc)
            XCTAssertEqual((fa - fb) * fc, fa * fc - fb * fc)
            XCTAssertEqual((fa + fb) / fc, fa / fc + fb / fc)
            XCTAssertEqual((fa - fb) / fc, fa / fc - fb / fc)
        }
    }
    
    func testExp() {
        // a ** 10 = a * a * a * a * a * a * a * a * a * a
        let a = BFraction(BInt(bitWidth: 100), BInt(bitWidth: 100) + 1)
        var x1 = a ** 10
        var x2 = BFraction(1, 1)
        for _ in 0 ..< 10 {
            x2 *= a
        }
        XCTAssertEqual(x1, x2)
        x1 = (-a) ** 10
        x2 = BFraction(1, 1)
        for _ in 0 ..< 10 {
            x2 *= (-a)
        }
        XCTAssertEqual(x1, x2)
    }
    
    func doTestInt2(_ f: BFraction, _ x: Int) {
        let fx = BFraction(x, 1)
        let X = BInt(x)
        XCTAssertEqual(f + fx, f + x)
        XCTAssertEqual(f + fx, x + f)
        XCTAssertEqual(f + fx, f + X)
        XCTAssertEqual(f + fx, X + f)
        XCTAssertEqual(f - fx, f - x)
        XCTAssertEqual(f - fx, f - X)
        XCTAssertEqual(f * fx, f * x)
        XCTAssertEqual(f * fx, x * f)
        XCTAssertEqual(f * fx, f * X)
        XCTAssertEqual(f * fx, X * f)
        if x != 0 {
            XCTAssertEqual(f / fx, f / x)
            XCTAssertEqual(f / fx, f / X)
        }
        XCTAssertEqual(f == fx, f == x)
        XCTAssertEqual(f == fx, f == X)
        XCTAssertEqual(f == fx, x == f)
        XCTAssertEqual(f == fx, X == f)
        XCTAssertEqual(f != fx, f != x)
        XCTAssertEqual(f != fx, f != X)
        XCTAssertEqual(f != fx, x != f)
        XCTAssertEqual(f != fx, X != f)
        XCTAssertEqual(f < fx, f < x)
        XCTAssertEqual(f < fx, f < X)
        XCTAssertEqual(f < fx, x > f)
        XCTAssertEqual(f < fx, X > f)
        XCTAssertEqual(f > fx, f > x)
        XCTAssertEqual(f > fx, f > X)
        XCTAssertEqual(f > fx, x < f)
        XCTAssertEqual(f > fx, X < f)
        XCTAssertEqual(f <= fx, f <= x)
        XCTAssertEqual(f <= fx, f <= X)
        XCTAssertEqual(f <= fx, x >= f)
        XCTAssertEqual(f <= fx, X >= f)
        XCTAssertEqual(f >= fx, f >= x)
        XCTAssertEqual(f >= fx, f >= X)
        XCTAssertEqual(f >= fx, x <= f)
        XCTAssertEqual(f >= fx, X <= f)
    }
    
    func doTestInt1(_ f: BFraction) {
        doTestInt2(f, 0)
        doTestInt2(f, 1)
        doTestInt2(f, -1)
        doTestInt2(f, Int.max)
        doTestInt2(f, Int.min)
    }
    
    func testInt() {
        doTestInt1(BFraction.ZERO)
        doTestInt1(BFraction.ONE)
        doTestInt1(-BFraction.ONE)
        doTestInt1(BFraction(Int.max, 1))
        doTestInt1(BFraction(Int.min, 1))
    }
    
    func testConversion() {
        let f1 = BFraction(1, 10)
        let f2 = BFraction(0.1)!
        XCTAssertEqual(f1.asDecimalString(digits: 1), "0.1")
        XCTAssertEqual(f1.asDecimalString(digits: 55), "0.1000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(f2.asDecimalString(digits: 1), "0.1")
        XCTAssertEqual(f2.asDecimalString(digits: 55), "0.1000000000000000055511151231257827021181583404541015625")
    }
    
    struct testB {
        
        let n: Int
        let num: BInt
        let denum: Int
        
        init(_ n: Int, _ num: BInt, _ denum: Int) {
            self.n = n
            self.num = num
            self.denum = denum
        }
    }
    
    let tests: [testB] = [
        testB(0, BInt("1")!, 1),
        testB(1, BInt("1")!, 2),
        testB(2, BInt("1")!, 6),
        testB(4, BInt("-1")!, 30),
        testB(6, BInt("1")!, 42),
        testB(8, BInt("-1")!, 30),
        testB(10, BInt("5")!, 66),
        testB(12, BInt("-691")!, 2730),
        testB(14, BInt("7")!, 6),
        testB(16, BInt("-3617")!, 510),
        testB(18, BInt("43867")!, 798),
        testB(20, BInt("-174611")!, 330),
        testB(22, BInt("854513")!, 138),
        testB(24, BInt("-236364091")!, 2730),
        testB(26, BInt("8553103")!, 6),
        testB(28, BInt("-23749461029")!, 870),
        testB(30, BInt("8615841276005")!, 14322),
        testB(32, BInt("-7709321041217")!, 510),
        testB(34, BInt("2577687858367")!, 6),
        testB(36, BInt("-26315271553053477373")!, 1919190),
        testB(38, BInt("2929993913841559")!, 6),
        testB(40, BInt("-261082718496449122051")!, 13530),
        testB(42, BInt("1520097643918070802691")!, 1806),
        testB(44, BInt("-27833269579301024235023")!, 690),
        testB(46, BInt("596451111593912163277961")!, 282),
        testB(48, BInt("-5609403368997817686249127547")!, 46410),
        testB(50, BInt("495057205241079648212477525")!, 66),
        testB(52, BInt("-801165718135489957347924991853")!, 1590),
        testB(54, BInt("29149963634884862421418123812691")!, 798),
        testB(56, BInt("-2479392929313226753685415739663229")!, 870),
        testB(58, BInt("84483613348880041862046775994036021")!, 354),
        testB(60, BInt("-1215233140483755572040304994079820246041491")!, 56786730),
    ]
    
    func testBernoulli() {
        for t in tests {
            let b = BFraction.bernoulli(t.n)
            XCTAssertEqual(b, BFraction(t.num, t.denum))
        }
        for i in 1 ..< 100 {
            XCTAssertEqual(BFraction.bernoulli(2 * i + 1), BFraction.ZERO)
        }
    }
    
}
