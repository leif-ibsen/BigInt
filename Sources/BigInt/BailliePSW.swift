//
//  BailliePSW.swift
//  BigInt
//
//  Created by Leif Ibsen on 28/10/2025.
//

extension BInt {

    func millerRabin() -> Bool {
        let self1 = self - 1
        let s = self1.trailingZeroBitCount
        let d = self1 >> s
        var a = BInt.TWO.expMod(d, self)
        if a.isOne {
            return true
        }
        for _ in 0 ..< s {
            if a == self1 {
                return true
            }
            a = (a * a) % self
        }
        return a == self1
    }

    // 5 -7 9 -11 13 -15 . . .
    func computeD() -> (Int, Int) {
        var D = 5
        var j = BInt(D).jacobiSymbol(self)
        while j > 0 {
            D += D > 0 ? 2 : -2
            D = -D
            if D == -15 && self.isPerfectSquare() {
                return (0, 0)
            }
            j = BInt(D).jacobiSymbol(self)
        }
        return (D, j)
    }

    func div2mod(_ x: BInt) -> BInt {
        return ((x.isOdd ? x + self : x) >> 1) % self
    }

    func computeUV(_ k: BInt, _ P: Int, _ D: Int) -> (BInt, BInt) {
        var U = BInt.ONE
        var V = BInt(P)
        for i in (0 ..< k.bitWidth - 1).reversed() {
            (U, V) = ((U * V) % self, div2mod(V * V + D * U * U))
            if k.testBit(i) {
                (U, V) = (div2mod(P * U + V), div2mod(D * U + P * V))
            }
        }
        return (U, V)
    }

    func lucas(_ D: Int, _ P: Int, _ Q: Int) -> Bool {
        var d = self + 1
        var Q = BInt(Q)
        let s = d.trailingZeroBitCount
        d >>= s
        var (U, V) = computeUV(d, P, D)
        if U.isZero {
            return true
        }
        Q = Q.expMod(d, self)
        for _ in 0 ..< s {
            if V.isZero {
                return true
            }
            V = (V * V - 2 * Q) % self
            Q = (Q * Q) % self
        }
        return false
    }

    func bailliePSW() -> Bool {
        if !self.millerRabin() {
            return false
        }
        let (D, j) = self.computeD()
        if j == 0 {
            return false
        }
        return self.lucas(D, 1, (1 - D) / 4)
    }

}
