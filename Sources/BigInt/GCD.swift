//
//  RecGCD.swift
//  BigIntTest
//
//  Created by Leif Ibsen on 24/05/2024.
//

extension BInt {
    
    // Limb limits for recursive GCD

    // 128.000 bits
    static let RECURSIVE_GCD_LIMIT = 2000
    // 64.000 bits
    static let RECURSIVE_GCD_EXT_LIMIT = 1000

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

        func hgcd(_ b: Int, _ x: BInt, _ y: BInt) {
            if y.isZero {
                return
            }
            var u = x >> b
            var v = y >> b
            var m = u.bitWidth
            if m < RecursiveGCD.precision {
                
                // shgcd
                
                (G11, G12, G21, G22) = (BInt.ONE, BInt.ZERO, BInt.ZERO, BInt.ONE)
                let _u = u
                while v * v > _u {
                    let (q, r) = u.quotientAndRemainder(dividingBy: v)
                    (u, v) = (v, r)
                    (G11, G12, G21, G22) = (G21, G22, G11 - q * G21, G12 - q * G22)
                }
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
        
        // [CRANDALL] - algorithm 9.4.6 combined with [KNUTH] section 4.5.2 algorithm X
        func rgcdExt() -> (BInt, BInt, BInt) {
            
            func finalize() {
                let (g, a, b) = u3.lehmerGCDext(v3)
                u3 = g
                if self.x == u3 {
                    u1 = BInt.ONE
                    u2 = BInt.ZERO
                } else if self.x == -u3 {
                    u1 = -BInt.ONE
                    u2 = BInt.ZERO
                } else if self.y == u3 {
                    u1 = BInt.ZERO
                    u2 = BInt.ONE
                } else if self.y == -u3 {
                    u1 = BInt.ZERO
                    u2 = -BInt.ONE
                } else {
                    u1 = a * u1 + b * v1
                    if self.x < 0 {
                        u1 = -u1
                    }
                    
                    // u3 = self.x * u1 + self.y * u2
                    
                    u2 = (u3 - self.x * u1) / self.y
                }
            }

            var (u1, u2, u3) = (BInt.ONE, BInt.ZERO, self.x.abs)
            var (v1, v3) = (BInt.ZERO, self.y.abs)
            while true {
                if u3 < v3 {
                    (u1, v1) = (v1, u1)
                    (u3, v3) = (v3, u3)
                }
                if v3 < RecursiveGCD.limit {
                    finalize()
                    return (u3, u1, u2)
                }
                (G11, G12, G21, G22) = (BInt.ONE, BInt.ZERO, BInt.ZERO, BInt.ONE)
                hgcd(0, u3, v3)
                (u1, v1) = (u1 * G11 + v1 * G12, u1 * G21 + v1 * G22)
                (u3, v3) = (u3 * G11 + v3 * G12, u3 * G21 + v3 * G22)
                if u3.isNegative {
                    (u1, u3) = (-u1, -u3)
                }
                if v3.isNegative {
                    (v1, v3) = (-v1, -v3)
                }
                if u3 < v3 {
                    (u1, v1) = (v1, u1)
                    (u3, v3) = (v3, u3)
                }
                if v3 < RecursiveGCD.limit {
                    finalize()
                    return (u3, u1, u2)
                }
                let q = u3 / v3
                (u1, v1) = (v1, u1 - q * v1)
                (u3, v3) = (v3, u3 - q * v3)
            }
        }

    }

    func recursiveGCD(_ x: BInt) -> BInt {
        return RecursiveGCD(self, x).rgcd()
    }

    func recursiveGCDext(_ x: BInt) -> (BInt, BInt, BInt) {
        return RecursiveGCD(self, x).rgcdExt()
    }

    // Leave one bit for the sign and one for a possible overflow
    static let B62 = BInt.ONE << 62

    // Lehmer's gcd algorithm - [KNUTH] chapter 4.5.2, algorithm L
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
    
    // Lehmer's gcd algorithm - [KNUTH] chapter 4.5.2, algorithm L and exercise 18
    func lehmerGCDext(_ x: BInt) -> (g: BInt, a: BInt, b: BInt) {
        let selfabs = self.abs
        let xabs = x.abs
        if self.isZero {
            return (xabs, BInt.ZERO, x.isNegative ? -BInt.ONE : BInt.ONE)
        }
        if x.isZero {
            return (selfabs, self.isNegative ? -BInt.ONE : BInt.ONE, BInt.ZERO)
        }
        var u: BInt
        var v: BInt
        var u2 = BInt.ZERO
        var v2 = BInt.ONE
        if selfabs < xabs {
            u = xabs
            v = selfabs
        } else {
            u = selfabs
            v = xabs
        }
        var u3 = u
        var v3 = v
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
                let q = u3 / v3
                (u2, v2) = (v2, u2 - q * v2)
                (u3, v3) = (v3, u3 - q * v3)
            } else {
                (u, v) = (A * u + B * v, C * u + D * v)
                (u2, v2) = (A * u2 + B * v2, C * u2 + D * v2)
                (u3, v3) = (A * u3 + B * v3, C * u3 + D * v3)
            }
        }
        while v3.isNotZero {
            let q = u3 / v3
            (u2, v2) = (v2, u2 - v2 * q)
            (u3, v3) = (v3, u3 - v3 * q)
        }
        
        var u1: BInt
        if selfabs < xabs {
            // u3 = u2 * selfabs + u1 * xabs
            u1 = (u3 - u2 * selfabs) / xabs
            (u1, u2) = (u2, u1)
        } else {
            // u3 = u1 * selfabs + u2 * xabs
            u1 = (u3 - u2 * xabs) / selfabs
        }
        
        // Fix the signs

        if x.isNegative {
            u2 = -u2
        }
        if self.isNegative {
            u1 = -u1
        }
        return (u3, u1, u2)
    }

}
