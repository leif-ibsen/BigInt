//
//  BurnikelZiegler.swift
//  BigIntTest
//
//  Created by Leif Ibsen on 05/12/2021.
//

extension Array where Element == Limb {

    // Divisor limb limit for Burnikel-Ziegler division
    static let BZ_DIV_LIMIT = 60

    /*
     * [BURNIKEL] - algorithm 3
     */
    func bzDivMod(_ v: Limbs) -> (quotient: Limbs, remainder: Limbs) {
        var quotient: Limbs = [0]
        var remainder: Limbs = []
        var A = self
        var B = v
        let s = B.count
        let m = 1 << (64 - (s / Limbs.BZ_DIV_LIMIT).leadingZeroBitCount)
        let j = (s + m - 1) / m
        let n = j * m
        let n64 = n << 6
        let sigma = Swift.max(0, n64 - B.bitWidth)
        A.shiftLeft(sigma)
        B.shiftLeft(sigma)
        let t = Swift.max(2, (A.bitWidth + n64) / n64)
        var Z = Limbs(repeating: 0, count: 2 * n)
        var from = (t - 1) * n
        var zi = n
        for ai in from ..< A.count {
            Z[zi] = A[ai]
            zi += 1
        }
        from -= n
        zi = 0
        for ai in from ..< from + n {
            Z[zi] = A[ai]
            zi += 1
        }
        for i in (0 ... t - 2).reversed() {
            var (Q, R) = Div2n1n(n, Z, B)
            R.normalize()
            quotient.add(Q, from)
            if i > 0 {
                from -= n
                for zi in 0 ..< R.count {
                    Z[n + zi] = R[zi]
                }
                for zi in R.count ..< n {
                    Z[n + zi] = 0
                }
                zi = 0
                for ai in from ..< from + n {
                    Z[zi] = A[ai]
                    zi += 1
                }
            } else {
                remainder = R
                remainder.shiftRight(sigma)
            }
        }
        return (quotient, remainder)
    }

    /*
     * [BURNIKEL] - algorithm 1
     */
    func Div2n1n(_ n: Int, _ A: Limbs, _ B: Limbs) -> (Limbs, Limbs) {
        if B.count & 1 == 1 || B.count < Limbs.BZ_DIV_LIMIT {
            
            // Basecase

            var a = A
            a.normalize()
            var b = B
            b.normalize()
            return a.divMod(b)
        }
        let n12 = n >> 1
        let (A1, A2, A3, A4) = A.split4(n12)
        let (Q1, R1) = Div3n2n(n12, A1, A2, A3, B)
        let (R11, R12) = R1.split2(n12)
        let (Q2, R) = Div3n2n(n12, R11, R12, A4, B)
        var Q = Q1.shiftedLeft(n12 << 6)
        Q.add(Q2, 0)
        return (Q, R)
    }

    /*
     * [BURNIKEL] - algorithm 2
     */
    func Div3n2n(_ n: Int, _ A1: Limbs, _ A2: Limbs, _ A3: Limbs, _ B: Limbs) -> (Limbs, Limbs) {
        let n64 = n << 6
        let (B1, B2) = B.split2(n)
        var Q: Limbs
        var R: Limbs
        if A1.compare(B1) < 0 {
            var A = A1.shiftedLeft(n64)
            A.add(A2, 0)
            (Q, R) = Div2n1n(n, A, B1)
        } else {
            R = A1
            _ = R.subtract(B1, 0)
            R.shiftLeft(n64)
            R.add(A2, 0)
            R.add(B1, 0)
            Q = Limbs(repeating: 0xffffffffffffffff, count: n)
        }
        var D = Q
        D.multiply(B2)
        R.shiftLeft(n64)
        R.add(A3, 0)
        while R.compare(D) < 0 {
            R.add(B, 0)
            _ = Q.subtract([1], 0)
        }
        _ = R.subtract(D, 0)
        return (Q, R)
    }

    func split2(_ n: Int) -> (Limbs, Limbs) {
        if self.count > n {
            return (Limbs(self[n ..< self.count]), Limbs(self[0 ..< n]))
        } else {
            return ([0], Limbs(self[0 ..< self.count]))
        }
    }

    func split4(_ n: Int) -> (Limbs, Limbs, Limbs, Limbs) {
        let n2 = n << 1
        let n3 = n + n2
        if self.count > n3 {
            return (Limbs(self[n3 ..< self.count]), Limbs(self[n2 ..< n3]), Limbs(self[n ..< n2]), Limbs(self[0 ..< n]))
        } else if self.count > n2 {
            return ([0], Limbs(self[n2 ..< self.count]), Limbs(self[n ..< n2]), Limbs(self[0 ..< n]))
        } else if self.count > n {
            return ([0], [0], Limbs(self[n ..< self.count]), Limbs(self[0 ..< n]))
        } else {
            return ([0], [0], [0], Limbs(self[0 ..< self.count]))
        }
    }
}
