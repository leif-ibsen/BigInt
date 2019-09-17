//
//  Karatsuba.swift
//  BigInt
//
//  Created by Leif Ibsen on 14/02/2019.
//  Copyright © 2019 Leif Ibsen. All rights reserved.
//

/*
 * Karatsuba multiplication modelled after the Karatsuba algorithm in Java BigInteger
 */
extension Array where Element == Limb {
    
    func getUpper(_ k: Int) -> Limbs {
        var w: Limbs
        if self.count <= k {
            w = [0]
        } else {
            w = Limbs(repeating: 0, count: self.count - k)
            for i in 0 ..< w.count {
                w[i] = self[k + i]
            }
        }
        return w
    }

    func getLower(_ k: Int) -> Limbs {
        var w = Limbs(repeating: 0, count: k < self.count ? k : self.count)
        for i in 0 ..< w.count {
            w[i] = self[i]
        }
        return w
    }

    func karatsubaTimes(_ x: Limbs) -> Limbs {
        let k = (Swift.max(self.count, x.count) + 1) >> 1
        var x0 = x.getLower(k)
        let x1 = x.getUpper(k)
        var s0 = self.getLower(k)
        let s1 = self.getUpper(k)
        var w0 = x0
        w0.multiply(s0)
        var w1 = x1
        w1.multiply(s1)
        let xcmp = x0.difference(x1)
        let scmp = s0.difference(s1)
        x0.multiply(s0)
        w0.add(w0, k)
        w0.add(w1, k << 1)
        w0.add(w1, k)
        if xcmp * scmp < 0 {
            w0.add(x0, k)
        } else {
            w0.subtract(x0, k)
        }
        return w0
    }
    
    func karatsubaSquared() -> Limbs {
        let k = (self.count + 1) >> 1
        var s0 = self.getLower(k)
        let s1 = self.getUpper(k)
        var w0 = s0
        w0.square()
        var w1 = s1
        w1.square()
        s0.difference(s1)
        s0.square()
        w0.add(w0, k)
        w0.add(w1, k << 1)
        w0.add(w1, k)
        w0.subtract(s0, k)
        return w0
    }
    
}
