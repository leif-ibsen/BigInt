//
//  DivModTest.swift
//  XBigIntegerTests
//
//  Created by Leif Ibsen on 11/12/2018.
//

import XCTest
@testable import BigInt

class DivRoundedTest: XCTestCase {

    func sameSignB(_ x: BInt, _ d: BInt) -> Bool {
        return x.isNegative == d.isNegative
    }

    func sameSignI(_ x: Int, _ d: Int) -> Bool {
        return (x < 0) == (d < 0)
    }

    func checkB(_ x: BInt, _ d: BInt, _ q: BInt, _ r: BInt, _ qc: BInt, _ rc: BInt, _ qf: BInt, _ rf: BInt) {
        XCTAssertTrue(x == d * q + r)
        XCTAssertTrue(x == d * qc + rc)
        XCTAssertTrue(x == d * qf + rf)
        XCTAssertTrue(r.abs < d.abs)
        XCTAssertTrue(rc.abs < d.abs)
        XCTAssertTrue(rf.abs < d.abs)
        if r.isZero {
            XCTAssertTrue(rc.isZero)
            XCTAssertTrue(rf.isZero)
            XCTAssertTrue(q == qc)
            XCTAssertTrue(q == qf)
        } else {
            XCTAssertTrue(qf != qc && rf != rc)
            XCTAssertTrue((q == qc && r == rc) || (q == qf && r == rf))
            XCTAssertTrue(sameSignB(r, x))
            XCTAssertTrue(!sameSignB(rc, d))
            XCTAssertTrue(sameSignB(rf, d))
        }
    }

    func checkI(_ x: BInt, _ d: Int, _ q: BInt, _ r: Int, _ qc: BInt, _ rc: Int, _ qf: BInt, _ rf: Int) {
        XCTAssertTrue(x == d * q + r)
        XCTAssertTrue(x == d * qc + rc)
        XCTAssertTrue(x == d * qf + rf)
        if d > Int.min {
            XCTAssertTrue(abs(r) < abs(d))
            XCTAssertTrue(abs(rc) < abs(d))
            XCTAssertTrue(abs(rf) < abs(d))
        }
        if r == 0 {
            XCTAssertTrue(rc == 0)
            XCTAssertTrue(rf == 0)
            XCTAssertTrue(q == qc)
            XCTAssertTrue(q == qf)
        } else {
            XCTAssertTrue(qf != qc && rf != rc)
            XCTAssertTrue((q == qc && r == rc) || (q == qf && r == rf))
            XCTAssertTrue(sameSignB(BInt(r), x))
            XCTAssertTrue(!sameSignI(rc, d))
            XCTAssertTrue(sameSignI(rf, d))
        }
    }

    func doTestB(_ x: BInt, _ d: BInt) {
        let (q1, r1) = x.quotientAndRemainder(dividingBy: d)
        let (qc1, rc1) = x.quotientAndRemainderCeil(dividingBy: d)
        let (qf1, rf1) = x.quotientAndRemainderFloor(dividingBy: d)
        checkB(x, d, q1, r1, qc1, rc1, qf1, rf1)
        var q2 = BInt.ZERO
        var r2 = BInt.ZERO
        var qc2 = BInt.ZERO
        var rc2 = BInt.ZERO
        var qf2 = BInt.ZERO
        var rf2 = BInt.ZERO
        x.quotientAndRemainder(dividingBy: d, &q2, &r2)
        x.quotientAndRemainderCeil(dividingBy: d, &qc2, &rc2)
        x.quotientAndRemainderFloor(dividingBy: d, &qf2, &rf2)
        checkB(x, d, q2, r2, qc2, rc2, qf2, rf2)
    }
    
    func doTestI(_ x: BInt, _ d: Int) {
        let (q1, r1) = x.quotientAndRemainder(dividingBy: d)
        let (qc1, rc1) = x.quotientAndRemainderCeil(dividingBy: d)
        let (qf1, rf1) = x.quotientAndRemainderFloor(dividingBy: d)
        checkI(x, d, q1, r1, qc1, rc1, qf1, rf1)
        var q2 = BInt.ZERO
        var r2 = 0
        var qc2 = BInt.ZERO
        var rc2 = 0
        var qf2 = BInt.ZERO
        var rf2 = 0
        x.quotientAndRemainder(dividingBy: d, &q2, &r2)
        x.quotientAndRemainderCeil(dividingBy: d, &qc2, &rc2)
        x.quotientAndRemainderFloor(dividingBy: d, &qf2, &rf2)
        checkI(x, d, q2, r2, qc2, rc2, qf2, rf2)
    }
    
    func testB() {
        doTestB(BInt(0), BInt(7))
        doTestB(BInt(0), BInt(-7))
        doTestB(BInt(1), BInt(7))
        doTestB(BInt(1), BInt(-7))
        doTestB(BInt(-1), BInt(7))
        doTestB(BInt(-1), BInt(-7))
        let m = BInt.ONE << 1000
        for _ in 0 ..< 100 {
            let x = m.randomLessThan()
            let d = m.randomLessThan() | BInt.ONE
            doTestB(x, d)
            doTestB(x, -d)
            doTestB(-x, d)
            doTestB(-x, -d)
        }
    }

    func testI() {
        doTestI(BInt(0), 7)
        doTestI(BInt(0), -7)
        doTestI(BInt(0), Int.max)
        doTestI(BInt(0), Int.min)
        doTestI(BInt(1), 7)
        doTestI(BInt(1), -7)
        doTestI(BInt(1), Int.max)
        doTestI(BInt(1), Int.min)
        doTestI(BInt(-1), 7)
        doTestI(BInt(-1), -7)
        doTestI(BInt(-1), Int.max)
        doTestI(BInt(-1), Int.min)
        let m = BInt.ONE << 1000
        for _ in 0 ..< 100 {
            let x = m.randomLessThan()
            let d = Int.random(in: Int.min ... Int.max)
            if d != 0 {
                doTestI(x, d)
                doTestI(x, -d)
                doTestI(-x, d)
                doTestI(-x, -d)
            }
        }
    }

}
