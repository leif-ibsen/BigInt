//
//  Limbs.swift
//  BigInt
//
//  Created by Leif Ibsen on 24/12/2018.
//  Copyright © 2018 Leif Ibsen. All rights reserved.
//

extension Array where Element == Limb {
    
    static let UMasks: Limbs = [
        0x1,0x2,0x4,0x8,
        0x10,0x20,0x40,0x80,
        0x100,0x200,0x400,0x800,
        0x1000,0x2000,0x4000,0x8000,
        0x10000,0x20000,0x40000,0x80000,
        0x100000,0x200000,0x400000,0x800000,
        0x1000000,0x2000000,0x4000000,0x8000000,
        0x10000000,0x20000000,0x40000000,0x80000000,
        0x100000000,0x200000000,0x400000000,0x800000000,
        0x1000000000,0x2000000000,0x4000000000,0x8000000000,
        0x10000000000,0x20000000000,0x40000000000,0x80000000000,
        0x100000000000,0x200000000000,0x400000000000,0x800000000000,
        0x1000000000000,0x2000000000000,0x4000000000000,0x8000000000000,
        0x10000000000000,0x20000000000000,0x40000000000000,0x80000000000000,
        0x100000000000000,0x200000000000000,0x400000000000000,0x800000000000000,
        0x1000000000000000,0x2000000000000000,0x4000000000000000,0x8000000000000000]

    // Ensure no leading 0 Limbs - except if self = [0]
    mutating func normalize() {
        let sc = self.count
        if sc == 0 {
            self.append(0)
        } else if sc > 1 {
            var i = sc - 1
            while self[i] == 0 && i > 0 {
                i -= 1
            }
            self.removeSubrange(i + 1 ..< sc)
        }
    }

    mutating func ensureSize(_ size: Int) {
        self.reserveCapacity(size)
        while self.count < size {
            self.append(0)
        }
    }

    func trailingZeroBitCount() -> Int {
        if self == [0] {
            return 0
        }
        var i = 0
        while self[i] == 0 {
            i += 1
        }
        return i * 64 + self[i].trailingZeroBitCount
    }

    /*
     * Bit operations
     */
    
    var bitWidth: Int {
        var lastBits = 0
        var last = self.last!
        while last != 0 {
            last >>= 1
            lastBits += 1
        }
        return (self.count - 1) * 64 + lastBits
    }
    
    func getBitAt(_ i: Int) -> Bool {
        let limbIndex = i >> 6
        if limbIndex >= self.count {
            return false
        }
        return (self[limbIndex] & Limbs.UMasks[i & 0x3f]) != 0
    }
    
    mutating func setBitAt(_ i: Int, to bit: Bool) {
        let limbIndex = i >> 6
        if limbIndex >= self.count && !bit {
            return
        }
        self.ensureSize(limbIndex + 1)
        if bit {
            self[limbIndex] |= Limbs.UMasks[i & 0x3f]
        } else {
            self[limbIndex] &= ~Limbs.UMasks[i & 0x3f]
            self.normalize()
        }
    }

    /*
     * Comparing
     */

    // return -1 if self < x, +1 if self > x, and 0 if self = x
    func compare(_ x: Limbs) -> Int {
        let scount = self.count
        let xcount = x.count
        if scount < xcount {
            return -1
        } else if scount > xcount {
            return 1
        }
        var i = xcount - 1
        while i >= 0 {
            if self[i] < x[i] {
                return -1
            } else if self[i] > x[i] {
                return 1
            }
            i -= 1
        }
        return 0
    }

    // return -1 if self < x, +1 if self > x, and 0 if self = x
    func compare(_ x: Limb) -> Int {
        if self.count > 1 {
            return 1
        }
        return self[0] == x ? 0 : (self[0] < x ? -1 : 1)
    }

    // return self < x
    func lessThan(_ x: Limbs) -> Bool {
        return self.compare(x) < 0
    }

    // return self > x
    func greaterThan(_ x: Limbs) -> Bool {
        return self.compare(x) > 0
    }

    // return self = x
    func equalTo(_ x: Limb) -> Bool {
        return self.count == 1 && self[0] == x
    }

    /*
     * Shifting
     */

    // self = self << 1
    mutating func shift1Left() {
        var b = self[0] & 0x8000000000000000 != 0
        self[0] <<= 1
        for i in 1 ..< self.count {
            let b1 = self[i] & 0x8000000000000000 != 0
            self[i] <<= 1
            if b {
                self[i] |= 1
            }
            b = b1
        }
        if b {
            self.append(1)
        }
    }

    // self = self << shifts
    mutating func shiftLeft(_ shifts: Int) {
        let limbShifts = shifts >> 6
        let bitShifts = shifts & 0x3f
        var b = self[0] >> (64 - bitShifts)
        if bitShifts > 0 {
            self[0] <<= bitShifts
            for i in 1 ..< self.count {
                let b1 = self[i] >> (64 - bitShifts)
                self[i] <<= bitShifts
                self[i] |= b
                b = b1
            }
        }
        if b != 0 {
            self.append(b)
        }
        for _ in 0 ..< limbShifts {
            self.insert(0, at: 0)
        }
    }
    
    // return self << 1
    func shifted1Left() -> Limbs {
        var res = self
        res.shift1Left()
        return res
    }

    // return self << shifts
    func shiftedLeft(_ shifts: Int) -> Limbs {
        var res = self
        res.shiftLeft(shifts)
        return res
    }
    
    // self = self >> 1
    mutating func shift1Right() {
        for i in 0 ..< self.count {
            if i > 0 && self[i] & 1 == 1 {
                self[i - 1] |= 0x8000000000000000
            }
            self[i] >>= 1
        }
        self.normalize()
    }

    // self = self >> shifts
    mutating func shiftRight(_ shifts: Int) {
        let limbShifts = Swift.min(shifts >> 6, self.count)
        self.removeFirst(limbShifts)
        let bitShifts = shifts & 0x3f
        if bitShifts > 0 {
            for i in 0 ..< self.count {
                if i > 0 {
                    self[i - 1] |= self[i] << (64 - bitShifts)
                }
                self[i] >>= bitShifts
            }
        }
        self.normalize()
    }
    
    // return self >> 1
    func shifted1Right() -> Limbs {
        var res = self
        res.shift1Right()
        return res
    }

    // return self >> shifts
    func shiftedRight(_ shifts: Int) -> Limbs {
        var res = self
        res.shiftRight(shifts)
        return res
    }

    /*
     * Addition
     */

    // self[offset ..< self.count] = self[offset ..< self.count] + x
    mutating func add(_ x: Limbs, _ offset: Int = 0, _ uselastcarry: Bool = true) {
        if x.equalTo(0) {
            return
        }
        self.ensureSize(x.count + offset)
        var carry = false
        for i in 0 ..< x.count {
            let io = i + offset
            if carry {
                self[io] = self[io] &+ 1
                if self[io] == 0 {
                    self[io] = x[i]
                    // carry still lives
                } else {
                    (self[io], carry) = self[io].addingReportingOverflow(x[i])
                }
            } else {
                (self[io], carry) = self[io].addingReportingOverflow(x[i])
            }
        }
        var i = x.count + offset
        while carry && i < self.count {
            self[i] = self[i] &+ 1
            carry = self[i] == 0
            i += 1
        }
        if carry && uselastcarry {
            self.append(1)
        }
    }

    // self = self + [x]
    mutating func add(_ x: Limb) {
        var carry: Bool
        (self[0], carry) = self[0].addingReportingOverflow(x)
        var i = 1
        while carry && i < self.count {
            self[i] = self[i] &+ 1
            carry = self[i] == 0
            i += 1
        }
        if carry {
            self.append(1)
        }
    }

    /*
     * Subtraction
     */

    // self[offset ..< self.count] = self[offset ..< self.count] - x, return borrow
    mutating func subtract(_ x: Limbs, _ offset: Int) -> Bool {
        self.ensureSize(x.count + offset)
        var borrow = false
        for i in 0 ..< x.count {
            let io = i + offset
            if borrow {
                if self[io] == 0 {
                    self[io] = 0xffffffffffffffff - x[i]
                    // borrow still lives
                } else {
                    self[io] -= 1
                    (self[io], borrow) = self[io].subtractingReportingOverflow(x[i])
                }
            } else {
                (self[io], borrow) = self[io].subtractingReportingOverflow(x[i])
            }
        }
        var i = x.count + offset
        while borrow && i < self.count {
            self[i] = self[i] &- 1
            borrow = self[i] == 0xffffffffffffffff
            i += 1
        }
        return borrow
    }

    // self = abs(self - x), return self.compare(x)
    mutating func difference(_ x: Limbs) -> Int {
        var xx = x
        let cmp = self.compare(xx)
        if cmp < 0 {
            swap(&self, &xx)
        }
        var borrow = false
        for i in 0 ..< xx.count {
            if borrow {
                if self[i] == 0 {
                    self[i] = 0xffffffffffffffff - xx[i]
                    // borrow still lives
                } else {
                    self[i] -= 1
                    (self[i], borrow) = self[i].subtractingReportingOverflow(xx[i])
                }
            } else {
                (self[i], borrow) = self[i].subtractingReportingOverflow(xx[i])
            }
        }
        var i = xx.count
        while borrow && i < self.count {
            self[i] = self[i] &- 1
            borrow = self[i] == 0xffffffffffffffff
            i += 1
        }
        self.normalize()
        return cmp
    }

    // self = abs(self - [x]), return self.compare([x])
    mutating func difference(_ x: Limb) -> Int {
        var xx = [x]
        let cmp = self.compare(xx)
        if cmp < 0 {
            swap(&self, &xx)
        }
        var borrow: Bool
        (self[0], borrow) = self[0].subtractingReportingOverflow(xx[0])
        var i = 1
        while borrow && i < self.count {
            self[i] = self[i] &- 1
            borrow = self[i] == 0xffffffffffffffff
            i += 1
        }
        self.normalize()
        return cmp
    }

    /*
     * Multiplication
     */

    // Threshold for Karatsuba multiplication
    static let KA_THR = 100
    // Threshold for Toom Cook multiplication
    static let TC_THR = 200

    // self = self * x
    // [KNUTH] - chapter 4.3.1, algorithm M
    mutating func multiply(_ x: Limbs) {
        let m = self.count
        var w: Limbs
        if m > Limbs.KA_THR && x.count > Limbs.KA_THR {
            if m > Limbs.TC_THR || x.count > Limbs.TC_THR {
                w = self.toomCookTimes(x)
            } else {
                w = self.karatsubaTimes(x)
            }
        } else {
            let n = x.count
            w = Limbs(repeating: 0, count: m + n)
            var carry: Limb
            var ovfl1, ovfl2: Bool
            for i in 0 ..< m {
                carry = 0
                for j in 0 ..< n {
                    let (hi, lo) = self[i].multipliedFullWidth(by: x[j])
                    (w[i + j], ovfl1) = w[i + j].addingReportingOverflow(lo)
                    (w[i + j], ovfl2) = w[i + j].addingReportingOverflow(carry)
                    carry = hi
                    if ovfl1 {
                        carry = carry &+ 1
                    }
                    if ovfl2 {
                        carry = carry &+ 1
                    }
                }
                w[i + n] = carry
            }
        }
        w.normalize()
        self = w
    }

    // self = self * x
    mutating func multiply(_ x: Limb) {
        let m = self.count
        var w = Limbs(repeating: 0, count: m + 1)
        var ovfl: Bool
        for i in 0 ..< m {
            let (hi, lo) = self[i].multipliedFullWidth(by: x)
            (w[i], ovfl) = w[i].addingReportingOverflow(lo)
            w[i + 1] = hi
            if ovfl {
                w[i + 1] = w[i + 1] &+ 1
            }
        }
        w.normalize()
        self = w
    }

    func times(_ x: Limbs) -> Limbs {
        var w = self
        w.multiply(x)
        return w
    }

    /*
     * Division and modulus
     */
    
    // [WARREN] - algorithm 9.2
    // (hi || lo) / d => (q, r)
    static func div128(_ hi: Limb, _ lo: Limb, _ d: Limb) -> (q: Limb, r: Limb) {
        precondition(d > 0, "Division by zero")
        var hi = hi
        var lo = lo
        for _ in 0 ..< 64 {
            let t: Limb = hi & 0x8000000000000000 == 0 ? 0 : 0xffffffffffffffff
            hi = (hi << 1) | (lo >> 63)
            lo <<= 1
            if (hi | t) >= d {
                hi = hi &- d
                lo = lo &+ 1
            }
        }
        return (lo, hi)
    }

    // [KNUTH] - chapter 4.3.1, exercise 16
    func divMod1(_ v: Limb) -> (quotient: Limbs, remainder: Limb) {
        if self.equalTo(0) {
            return ([0], 0)
        }
        var w = Limbs(repeating: 0, count: self.count)
        var r = Limb(0)
        for j in (0 ..< self.count).reversed() {
            (w[j], r) = Limbs.div128(r, self[j], v)
        }
        w.normalize()
        return (w, r)
    }

    func divMod(_ v: Limbs) -> (quotient: Limbs, remainder: Limbs) {
        var quotient = Limbs()
        var remainder = Limbs()
        self.divMod(v, &quotient, &remainder)
        return (quotient, remainder)
    }

    // [KNUTH] - chapter 4.3.1, algorithm D
    func divMod(_ v: Limbs, _ quotient: inout Limbs, _ remainder: inout Limbs) {
        if self.lessThan(v) {
            quotient = [0]
            remainder = self
        } else if v.count == 1 {
            let (q, r) = self.divMod1(v[0])
            quotient = q
            remainder = [r]
        } else {
            remainder = self
            var v = v
            let n = v.count
            let m = remainder.count
            let d = v[n - 1].leadingZeroBitCount
            v.shiftLeft(d)
            remainder.shiftLeft(d)
            remainder.append(0)
            var qhat = Limb(0)
            var rhat = Limb(0)
            var k = m - n
            quotient = Limbs(repeating: 0, count: k + 1)
            var ovfl: Bool
            repeat {
                if v[n - 1] == remainder[k + n] {
                    qhat = 0xffffffffffffffff
                    (rhat, ovfl) = remainder[k + n].addingReportingOverflow(remainder[k + n - 1])
                } else {
                    (qhat, rhat) = Limbs.div128(remainder[k + n], remainder[k + n - 1], v[n - 1])
                    ovfl = false
                }
                while !ovfl {
                    let (hi, lo) = qhat.multipliedFullWidth(by: v[n - 2])
                    if hi < rhat || (hi == rhat && lo <= remainder[k + n - 2]) {
                        break
                    }
                    qhat -= 1
                    (rhat, ovfl) = rhat.addingReportingOverflow(v[n - 1])
                }
                if qhat != 0 {
                    let borrow = remainder.subtract(v.times([qhat]), k)
                    if borrow {
                        qhat -= 1
                        remainder.add(v, k, false)
                    }
                }
                quotient[k] = qhat
                k -= 1
            } while k >= 0
            remainder.shiftRight(d)
            quotient.normalize()
        }
    }

    /*
     * gcd algorithms modelled after the gcd algorithms in Java BigInteger
     */
    func gcd(_ x: Limbs) -> Limbs {
        if self == [0] {
            return x
        }
        var u = self
        var v = x
        while v != [0] {
            if v.count == u.count {
                return u.binaryGcd(v)
            }
            let r = u.divMod(v).remainder
            u = v
            v = r
        }
        return u
    }

    func binaryGcd(_ x: Limbs) -> Limbs {
        if self == [0] {
            return x
        }
        var u = self
        var v = x
        let k = Swift.min(u.trailingZeroBitCount(), v.trailingZeroBitCount())
        u.shiftRight(k)
        v.shiftRight(k)
        var t: Limbs
        var tSign: Bool
        if u[0] & 1 == 1 {
            t = v
            tSign = true
        } else {
            t = u
            tSign = false
        }
        while t != [0] {
            t.shiftRight(t.trailingZeroBitCount())
            if tSign {
                v = t
            } else {
                u = t
            }
            if u.count == 1 && v.count == 1 {
                return Limbs.binaryGcd(u[0], v[0]).shiftedLeft(k)
            }
            let cmp = u.compare(v)
            if cmp < 0 {
                v.difference(u)
                t = v
                tSign = true
            } else if cmp > 0 {
                u.difference(v)
                t = u
                tSign = false
            } else {
                break
            }
        }
        return u.shiftedLeft(k)
    }
    
    /*
     * gcd of single Limb values
     */
    static func binaryGcd(_ a: Limb, _ b: Limb) -> Limbs {
        if b == 0 {
            return [a]
        }
        if a == 0 {
            return [b]
        }
        var a = a
        var b = b
        let atz = a.trailingZeroBitCount
        let btz = b.trailingZeroBitCount
        a >>= atz
        b >>= btz
        let t = Swift.min(atz, btz)
        while a != b {
            if a > b {
                a -= b
                a >>= a.trailingZeroBitCount
            } else {
                b -= a
                b >>= b.trailingZeroBitCount
            }
        }
        return [a << t]
    }
    
    /*
     * Exponentiation
     */
    
    func raisedTo(_ x: Int) -> Limbs {
        if x == 0 {
            return [1]
        }
        if x == 1 {
            return self
        }
        var base = self
        var exponent = x
        var y: Limbs = [1]
        while exponent > 1 {
            if exponent & 1 != 0 {
                y.multiply(base)
            }
            base.multiply(base)
            exponent >>= 1
        }
        return base.times(y)
    }
}

