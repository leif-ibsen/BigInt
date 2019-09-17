//
//  ExpMod.swift
//  BigInt
//
//  Created by Leif Ibsen on 17/02/2019.
//  Copyright © 2019 Leif Ibsen. All rights reserved.
//

extension BInt {
    
    /*
     * Montgomery helper class for (a ** x) mod m computation, from
     *
     *      Montgomery Multiplication
     *      By Henry S. Warren, Jr.
     *      July 2012
     */
    class OddModulus {
        
        let modulus: Limbs
        let base: Limbs
        let Rsize: Int
        var Rinv: Limbs = [1]
        var mprime: Limbs = [0]
        
        init(_ a: BInt, _ modulus: BInt) {
            self.modulus = modulus.magnitude
            self.Rsize = self.modulus.count
            self.base = a.magnitude.divMod(self.modulus).remainder
            
            // Compute Rinv and mprime such that R * Rinv - modulus * mprime = 1
            
            for _ in 0 ..< Rsize * 64 {
                if self.Rinv[0] & 1 == 0 {
                    self.Rinv.shift1Right()
                    self.mprime.shift1Right()
                } else {
                    self.Rinv.add(self.modulus)
                    self.Rinv.shift1Right()
                    self.mprime.shift1Right()
                    self.mprime.setBitAt(Rsize * 64 - 1, to: true)
                }
            }
        }
        
        func toMspace(_ x: Limbs) -> Limbs {
            return (x.shiftedLeft(self.Rsize * 64)).divMod(self.modulus).remainder
        }
        
        func fromMspace(_ x: Limbs) -> Limbs {
            return (x.times(self.Rinv)).divMod(self.modulus).remainder
        }
        
        func moduloR(_ x: inout Limbs) {
            if x.count > self.Rsize {
                x.removeLast(x.count - self.Rsize)
            }
            x.normalize()
        }
        
        func divideR(_ x: inout Limbs) {
            if x.count > self.Rsize {
                x.removeFirst(self.Rsize)
            } else {
                x = [0]
            }
        }
        
        func reduce(_ t: inout Limbs) {
            var u = t
            moduloR(&u)
            u.multiply(self.mprime)
            moduloR(&u)
            u.multiply(self.modulus)
            u.add(t)
            divideR(&u)
            if !u.lessThan(self.modulus) {
                u.difference(self.modulus)
            }
            t = u
        }
        
        // Handbook of Applied Cryptography - sliding window algorithm 14.85
        func expMod(_ x: BInt) -> BInt {
            let bw = x.bitWidth
            let k = bw < 200 ? 4 : (bw < 700 ? 5 : 6)
            var g = Array(repeating: Limbs(repeating: 0, count: 0), count: 1 << k)
            g[0] = toMspace(self.base)
            var g2 = g[0]
            g2.square()
            reduce(&g2)
            for i in 1 ..< g.count {
                g[i] = g[i - 1].times(g2)
                reduce(&g[i])
            }
            var result = toMspace([1])
            var i = x.bitWidth - 1
            while i >= 0 {
                if x.testBit(i) {
                    var l = max(0, i - k + 1)
                    while !x.testBit(l) {
                        l += 1
                    }
                    for _ in 0 ..< i - l + 1 {
                        result.square()
                        reduce(&result)
                    }
                    var ndx = 0
                    for j in (l ... i).reversed() {
                        ndx <<= 1
                        if x.testBit(j) {
                            ndx += 1
                        }
                    }
                    ndx >>= 1
                    result.multiply(g[ndx])
                    reduce(&result)
                    i = l - 1
                } else {
                    result.square()
                    reduce(&result)
                    i -= 1
                }
            }
            return BInt(fromMspace(result))
        }
    }
    
    /*
     * Helper class for (a ** x) mod m computation for m a power of 2
     */
    class Pow2Modulus {
        
        var limbCount = 0
        var mask: Limb = 0
        var base: Limbs
        
        init(_ a: BInt, _ modulus: BInt) {
            let trailing = modulus.trailingZeroBitCount
            self.limbCount = trailing / Limb.bitWidth
            if trailing % Limb.bitWidth != 0 {
                self.limbCount += 1
            }
            for _ in 0 ..< trailing % Limb.bitWidth {
                self.mask = (self.mask << 1) + 1
            }
            self.base = a.magnitude
            reduce(&self.base)
        }
        
        func reduce(_ t: inout Limbs) {
            let k = t.count - self.limbCount
            if k > 0 {
                t.removeLast(k)
            }
            if t.count == self.limbCount {
                t[t.count - 1] &= self.mask
            }
            t.normalize()
        }
        
        func expMod(_ x: BInt) -> BInt {
            var exponent = x.magnitude
            var result: Limbs = [1]
            while true {
                if exponent[0] & 1 == 1 {
                    result.multiply(self.base)
                    reduce(&result)
                }
                exponent.shift1Right()
                if exponent.equalTo(0) {
                    break
                }
                self.base.square()
                reduce(&self.base)
            }
            return BInt(result)
        }
        
    }
    
    /*
     * Helper class for (a ** x) mod m computation for small exponents
     */
    class BarrettModulus {
        
        var base: Limbs
        let modulus: Limbs
        let u: Limbs
        let k1: Int
        let km1: Int
        
        init(_ a: BInt, _ modulus: BInt) {
            self.modulus = modulus.magnitude
            self.k1 = self.modulus.count + 1
            self.km1 = self.modulus.count - 1
            self.base = a.magnitude
            var uu = Limbs(repeating: 0, count: 2 * self.modulus.count + 1)
            uu[2 * self.modulus.count] = 1
            self.u = uu.divMod(self.modulus).quotient
            self.base = self.base.divMod(self.modulus).remainder
        }
        
        func moduloK1(_ x: inout Limbs) {
            if x.count > self.k1 {
                x.removeLast(x.count - self.k1)
            }
            x.normalize()
        }
        
        func divideK(_ k: Int, _ x: inout Limbs) {
            if x.count > k {
                x.removeFirst(k)
            } else {
                x = [0]
            }
        }

        // Handbook of Applied Cryptography - Barrett reduction algorithm 14.42
        func reduce(_ t: inout Limbs) {
            if self.modulus.compare(t) > 0 {
                return
            }
            var q = t
            divideK(self.km1, &q)
            q.multiply(self.u)
            divideK(self.k1, &q)
            moduloK1(&t)
            q.multiply(self.modulus)
            moduloK1(&q)
            if t.compare(q) < 0 {
                var bk = Limbs(repeating: 0, count: self.k1)
                bk[self.k1 - 1] = 1
                t.add(bk)
            }
            t.difference(q)
            while t.compare(self.modulus) >= 0 {
                t.difference(self.modulus)
            }
        }
        
        func expMod(_ x: BInt) -> BInt {
            var exponent = x.magnitude
            var result: Limbs = [1]
            while true {
                if exponent[0] & 1 == 1 {
                    result.multiply(self.base)
                    reduce(&result)
                }
                exponent.shift1Right()
                if exponent.equalTo(0) {
                    break
                }
                self.base.square()
                reduce(&self.base)
            }
            return BInt(result)
        }
        
    }
    
}
