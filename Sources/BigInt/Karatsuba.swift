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
        let x1 = x.getLower(k)
        var x2 = x.getUpper(k)
        let s1 = self.getLower(k)
        var s2 = self.getUpper(k)
        var p1 = x2
        p1.multiply(s2)
        var p2 = x1
        p2.multiply(s1)
        x2.add(x1)
        s2.add(s1)
        var p3 = x2
        p3.multiply(s2)
        p3.subtract(p1, 0)
        p3.subtract(p2, 0)
        var w = Limbs(repeating: 0, count: 4 * k)
        w.add(p1, 2 * k)
        w.add(p3, k)
        w.add(p2, 0)
        return w
    }

}
