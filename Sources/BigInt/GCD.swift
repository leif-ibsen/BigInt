//
//  RecGCD.swift
//  BigIntTest
//
//  Created by Leif Ibsen on 24/05/2024.
//

extension BInt {
    
    static let RECURSIVE_GCD_LIMIT = 2000
    
    /*
     * Recursive GCD algorithm
     * [CRANDALL] - algorithm 9.4.6
     */
    class RecursiveGCD {
        
        static let limit = BInt.ONE << 256
        static let precision = 64
        
        var G11 = BInt.ONE
        var G12 = BInt.ZERO
        var G21 = BInt.ZERO
        var G22 = BInt.ONE
        let x: BInt
        let y: BInt

        init(_ x: BInt, _ y: BInt) {
            self.x = x
            self.y = y
        }
        
        func shgcd(_ x: BInt, _ y: BInt) -> (BInt, BInt, BInt, BInt) {
            assert(x >= 0)
            assert(y >= 0)
            var (A11, A12, A21, A22) = (BInt.ONE, BInt.ZERO, BInt.ZERO, BInt.ONE)
            var (u, v) = (x, y)
            while v * v > x {
                let (q, r) = u.quotientAndRemainder(dividingBy: v)
                (u, v) = (v, r)
                (A11, A12, A21, A22) = (A21, A22, A11 - q * A21, A12 - q * A22)
            }
            return (A11, A12, A21, A22)
        }
        
        func hgcd(_ b: Int, _ x: BInt, _ y: BInt) {
            if y.isZero {
                return
            }
            var u = x >> b
            var v = y >> b
            var m = u.bitWidth
            if m < RecursiveGCD.precision {
                (G11, G12, G21, G22) = shgcd(u, v)
                return
            }
            m >>= 1
            hgcd(m, u, v)
            (u, v) = (u * G11 + v * G12, u * G21 + v * G22)
            if u.isNegative {
                (u, G11, G12) = (-u, -G11, -G12)
            }
            if v.isNegative {
                (v, G21, G22) = (-v, -G21, -G22)
            }
            if u < v {
                (u, v, G11, G12, G21, G22) = (v, u, G21, G22, G11, G12)
            }
            if v.isNotZero {
                (u, v) = (v, u)
                let q = v / u
                (G11, G12, G21, G22) = (G21, G22, G11 - q * G21, G12 - q * G22)
                v -= q * u
                m >>= 1
                let (C11, C12, C21, C22) = (G11, G12, G21, G22)
                hgcd(m, u, v)
                (G11, G12, G21, G22) = (G11 * C11 + G12 * C21,
                                        G11 * C12 + G12 * C22,
                                        G21 * C11 + G22 * C21,
                                        G21 * C12 + G22 * C22)
            }
        }
        
        func rgcd() -> BInt {
            var (u, v) = (self.x.abs, self.y.abs)
            while true {
                if u < v {
                    (u, v) = (v, u)
                }
                if v < RecursiveGCD.limit {
                    return u.lehmerGCD(v)
                }
                (G11, G12, G21, G22) = (BInt.ONE, BInt.ZERO, BInt.ZERO, BInt.ONE)
                hgcd(0, u, v)
                (u, v) = (u * G11 + v * G12, u * G21 + v * G22)
                (u, v) = (u.abs, v.abs)
                if u < v {
                    (u, v) = (v, u)
                }
                if v < RecursiveGCD.limit {
                    return u.lehmerGCD(v)
                }
                (u, v) = (v, u.mod(v))
            }
        }
        
    }
    
    func recursiveGCD(_ x: BInt) -> BInt {
        return RecursiveGCD(self, x).rgcd()
    }
    
    /*
     * Lehmer's gcd algorithm
     * [KNUTH] - chapter 4.5.2, algorithm L
     */
    // Leave one bit for the sign and one for a possible overflow
    static let B62 = BInt.ONE << 62

    func lehmerGCD(_ x: BInt) -> BInt {
        var u: BInt
        var v: BInt
        let selfabs = self.abs
        let xabs = x.abs
        if selfabs < xabs {
            u = xabs
            v = selfabs
        } else {
            u = selfabs
            v = xabs
        }
        while v >= BInt.B62 {
            let size = u.bitWidth - 62
            var x = (u >> size).asInt()!
            var y = (v >> size).asInt()!
            var A = 1
            var B = 0
            var C = 0
            var D = 1
            while true {
                let yC = y + C
                let yD = y + D
                if yC == 0 || yD == 0 {
                    break
                }
                let q = (x + A) / yC
                if q != (x + B) / yD {
                    break
                }
                (A, B, x, C, D, y) = (C, D, y, A - q * C, B - q * D, x - q * y)
            }
            if B == 0 {
                (u, v) = (v, u.mod(v))
            } else {
                (u, v) = (A * u + B * v, C * u + D * v)
            }
        }
        if v.isZero {
            return u
        }
        if u.magnitude.count > 1 {
            let r = u.quotientAndRemainder(dividingBy: v).remainder
            u = v
            v = r
            if v.isZero {
                return u
            }
        }
        // u and v are one-limb values
        assert(u < BInt.ONE << 64)
        assert(v < BInt.ONE << 64)
        return BInt([Limbs.binaryGcd(u.magnitude[0], v.magnitude[0])])
     }
}
