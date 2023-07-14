//
//  BurnikelZiegler.swift
//  BigIntTest
//
//  Created by Leif Ibsen on 05/12/2021.
//

extension BInt {
    
    // Divisor limb limit for Burnikel-Ziegler division
    static var BZ_DIV_LIMIT = 60

    /*
     * [BURNIKEL] - algorithm 3
     */
    func bzDivMod(_ v: BInt) -> (q: BInt, r: BInt) {
        var A = self.abs
        var B = v.abs
        let s = B.words.count
        let m = 1 << (64 - (s / BInt.BZ_DIV_LIMIT).leadingZeroBitCount)
        let j = (s + m - 1) / m
        let n = j * m
        let n64 = n << 6
        let sigma = Swift.max(0, n64 - B.bitWidth)
        A <<= sigma
        B <<= sigma
        let t = Swift.max(2, (A.bitWidth + n64) / n64)
        var Q = BInt.ZERO
        var R = BInt.ZERO
        var Z = A.blockA(n, t - 1) << n64 | A.blockA(n, t - 2)
        for i in (0 ... t - 2).reversed() {
            var Qi: BInt
            (Qi, R) = Z.bzDiv2n1n(n, B)
            Q = Q << n64 | Qi
            if i > 0 {
                Z = R << n64 | A.blockA(n, i - 1)
            }
        }
        return (Q, R >> sigma)

    }

    func blockA(_ n: Int, _ i: Int) -> BInt {
        let mc = self.words.count
        assert(i * n <= mc)
        if (i + 1) * n < mc {
            return BInt(Limbs(self.words[i * n ..< (i + 1) * n]))
        } else {
            return BInt(Limbs(self.words[i * n ..< mc]))
        }
    }

    /*
     * [BURNIKEL] - algorithm 1
     */
    func bzDiv2n1n(_ n: Int, _ B: BInt) -> (q: BInt, r: BInt) {
        if n & 1 == 1 || B.words.count < BInt.BZ_DIV_LIMIT {
            
            // Base case
            
            let (q, r) = self.words.divMod(B.words)
            return (BInt(q), BInt(r))
        }
        let n2 = n >> 1
        let n32 = n << 5
        let (A123, A4) = self.split(n2)
        let (Q1, R1) = A123.bzDiv3n2n(n2, B)
        let (R11, R12) = R1.split(n)
        let (Q2, R) = ((R11 << n32 | R12) << n32 | A4).bzDiv3n2n(n2, B)
        return (Q1 << n32 + Q2, R)
    }

    /*
     * [BURNIKEL] - algorithm 2
     */
    func bzDiv3n2n(_ n: Int, _ B: BInt) -> (q: BInt, r: BInt) {
        let n64 = n << 6
        let (B1, B2) = B.split(n)
        let (A12, A3) = self.split(n)
        let (A1, _) = A12.split(n)
        var Q: BInt
        var R1: BInt
        if A1 < B1 {
            (Q, R1) = A12.bzDiv2n1n(n, B1)
        } else {
            R1 = A12 - (B1 << n64) + B1
            Q = BInt.ONE << n64 - BInt.ONE
        }
        let D = Q * B2
        var R = R1 << n64 | A3
        while R < D {
            R += B
            Q -= BInt.ONE
        }
        return (Q, R - D)
    }
    
    func split(_ n: Int) -> (BInt, BInt) {
        let mc = self.words.count
        if mc > n {
            return (BInt(Limbs(self.words[n ..< mc])), BInt(Limbs(self.words[0 ..< n])))
        } else {
            return (BInt.ZERO, self)
        }
    }

}

