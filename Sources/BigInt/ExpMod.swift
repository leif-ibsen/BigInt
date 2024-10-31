//
//  ExpMod.swift
//  BigInt
//
//  Created by Leif Ibsen on 17/02/2019.
//  Copyright © 2019 Leif Ibsen. All rights reserved.
//

extension BInt {
    
    class Modulus {
        
        let modulus: Limbs
        let base: Limbs

        init(_ a: BInt, _ modulus: BInt) {
            self.modulus = modulus.magnitude
            self.base = a.magnitude.divMod(self.modulus).remainder
        }

        func reduce(_ t: inout Limbs) {
            fatalError("Modulus.reduce called")
        }

        // [HANDBOOK] - sliding window algorithm 14.85
        func expMod(_ x: BInt) -> BInt {

            // Window width = 4 or 5

            let k = x.bitWidth < 512 ? 4 : 5
            var g = Array(repeating: Limbs(repeating: 0, count: 0), count: 1 << k)
            g[0] = self.base
            var g2 = g[0].squared()
            self.reduce(&g2)
            for i in 1 ..< g.count {
                g[i] = g[i - 1].times(g2)
                self.reduce(&g[i])
            }
            var result: Limbs = [1]
            var i = x.bitWidth - 1
            while i >= 0 {
                if x.testBit(i) {
                    var l = Swift.max(0, i - k + 1)
                    while !x.testBit(l) {
                        l += 1
                    }
                    for _ in 0 ..< i - l + 1 {
                        result.square()
                        self.reduce(&result)
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
                    self.reduce(&result)
                    i = l - 1
                } else {
                    result.square()
                    self.reduce(&result)
                    i -= 1
                }
            }
            return BInt(result)
        }

    }

    /*
     * Subclass for (a ** x) mod m computation for m a power of 2
     */
    class Pow2Modulus: Modulus {
        
        var limbCount = 0
        var mask: Limb = 0
        
        override init(_ a: BInt, _ modulus: BInt) {
            super.init(a, modulus)
            let trailing = modulus.trailingZeroBitCount
            self.limbCount = trailing / Limb.bitWidth
            if trailing % Limb.bitWidth != 0 {
                self.limbCount += 1
            }
            for _ in 0 ..< trailing % Limb.bitWidth {
                self.mask = (self.mask << 1) + 1
            }
        }
        
        override func reduce(_ t: inout Limbs) {
            let k = t.count - self.limbCount
            if k > 0 {
                t.removeLast(k)
            }
            if t.count == self.limbCount {
                t[t.count - 1] &= self.mask
            }
            t.normalize()
        }
        
    }

    /*
     * Subclass for (a ** x) mod m computation using Barrett reduction
     */
    class BarrettModulus: Modulus {
        
        var u: Limbs = []
        var k1: Int = 0
        var km1: Int = 0

        override init(_ a: BInt, _ modulus: BInt) {
            super.init(a, modulus)
            self.k1 = self.modulus.count + 1
            self.km1 = self.modulus.count - 1
            var uu = Limbs(repeating: 0, count: 2 * self.modulus.count + 1)
            uu[2 * self.modulus.count] = 1
            self.u = uu.divMod(self.modulus).quotient
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

        // [HANDBOOK] - Barrett reduction algorithm 14.42
        override func reduce(_ t: inout Limbs) {
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
                var bk = Limbs(repeating: 0, count: self.k1 + 1)
                bk[self.k1] = 1
                t.add(bk)
            }
            _ = t.difference(q)
            while t.compare(self.modulus) >= 0 {
                _ = t.difference(self.modulus)
            }
        }

    }
    
}
