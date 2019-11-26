//
//  ToomCook.swift
//  BigInt
//
//  Created by Leif Ibsen on 07/02/2019.
//  Copyright © 2019 Leif Ibsen. All rights reserved.
//

/*
 * ToomCook multiplication modelled after the ToomCook algorithm in Java BigInteger
 */
extension Array where Element == Limb {

    // Works only when the remainder of the division is known to be 0
    static func divideBy3(_ d: BInt) -> BInt {
        var quotient = Limbs(repeating: 0, count: d.magnitude.count)
        var remainder = Limb(0)
        for i in 0 ..< quotient.count {
            let w = remainder > d.magnitude[i] ? remainder - d.magnitude[i] : d.magnitude[i] - remainder
            let x = w &* 0xaaaaaaaaaaaaaaab
            quotient[i] = x
            remainder = x < 0x5555555555555556 ? 0 : (x < 0xaaaaaaaaaaaaaaab ? 1 : 2)
        }
        return BInt(quotient, d.isNegative)
    }

    func getSlice(_ n: Int, _ k: Int) -> BInt {
        var w: Limbs
        if n * k >= self.count {
            w = []
        } else if (n + 1) * k < self.count {
            w = Limbs(repeating: 0, count: k)
        } else {
            w = Limbs(repeating: 0, count: self.count - n * k)
        }
        for i in 0 ..< w.count {
            w[i] = self[n * k + i]
        }
        return BInt(w)
    }
    
    func toomCookTimes(_ x: Limbs) -> Limbs {
        let k = (Swift.max(self.count, x.count) + 2) / 3
        let x0 = x.getSlice(0, k)
        let x1 = x.getSlice(1, k)
        let x2 = x.getSlice(2, k)
        let s0 = self.getSlice(0, k)
        let s1 = self.getSlice(1, k)
        let s2 = self.getSlice(2, k)
        
        let pp = x0 + x2
        let p1 = pp + x1
        let pm1 = pp - x1
        let pm2 = ((pm1 + x2) << 1) - x0
        let qq = s0 + s2
        let q1 = qq + s1
        let qm1 = qq - s1
        let qm2 = ((qm1 + s2) << 1) - s0
        
        var r0 = x0 * s0
        let r1 = p1 * q1
        let rm1 = pm1 * qm1
        let rm2 = pm2 * qm2
        let rinf = x2 * s2
        var rr3 = Limbs.divideBy3(rm2 - r1)
        var rr1 = (r1 - rm1) >> 1
        var rr2 = rm1 - r0
        
        rr3 = (rr2 - rr3) >> 1 + (rinf << 1)
        rr2 += rr1
        rr2 -= rinf
        rr1 -= rr3
        
        var offset = k << 2
        r0.magnitude.add(rinf.magnitude, offset)
        offset -= k
        r0.magnitude.add(rr3.magnitude, offset)
        offset -= k
        r0.magnitude.add(rr2.magnitude, offset)
        r0.magnitude.add(rr1.magnitude, k)
        return r0.magnitude
    }
    
    func toomCookSquared() -> Limbs {
        let k = (self.count + 2) / 3
        let s0 = self.getSlice(0, k)
        let s1 = self.getSlice(1, k)
        let s2 = self.getSlice(2, k)
        
        let qq = s0 + s2
        let q1 = qq + s1
        let qm1 = qq - s1
        let qm2 = ((qm1 + s2) << 1) - s0
        
        var r0 = s0 ** 2
        let r1 = q1 ** 2
        let rm1 = qm1 ** 2
        let rm2 = qm2 ** 2
        let rinf = s2 ** 2

        var rr3 = Limbs.divideBy3(rm2 - r1)
        var rr1 = (r1 - rm1) >> 1
        var rr2 = rm1 - r0
        
        rr3 = (rr2 - rr3) >> 1 + (rinf << 1)
        rr2 += rr1
        rr2 -= rinf
        rr1 -= rr3

        var offset = k << 2
        r0.magnitude.add(rinf.magnitude, offset)
        offset -= k
        r0.magnitude.add(rr3.magnitude, offset)
        offset -= k
        r0.magnitude.add(rr2.magnitude, offset)
        r0.magnitude.add(rr1.magnitude, k)
        return r0.magnitude
    }

}
