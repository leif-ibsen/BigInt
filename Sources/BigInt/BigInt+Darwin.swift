// ``SecRandomCopyBytes`` only exists within Foundation on Darwin
#if canImport(Darwin)

import Foundation

extension BitSieve
{
    /**
     * Test probable primes in the sieve and return successful candidates.
     */
    func retrieve() -> BInt? {
        // Examine the sieve one word at a time to find possible primes
        var offset = 1
        for i in 0 ..< bits.count {
            let nextWord = ~bits[i]
            for j in 0 ..< 64 {
                if nextWord & Limbs.UMasks[j] != 0 {
                    let candidate = self.base + offset
                    if candidate.isProbablyPrime(prob) {
                        return candidate
                    }
                }
                offset += 2
            }
        }
        return nil
    }
}

extension BInt
{
    /// Constructs a random BInt with a specified number of bits
    ///
    /// - Precondition: bitWidth is positive
    /// - Parameter bitWidth: Number of bits
    /// - Returns: A uniformly distributed random BInt in range 0 ..< 2 ^ `bitWidth`
    public init(bitWidth: Int) {
        precondition(bitWidth > 0, "Bitwidth must be positive")
        let (q, r) = bitWidth.quotientAndRemainder(dividingBy: 64)
        var limbs = Limbs(repeating: 0, count: r == 0 ? q : q + 1)
        BInt.randomLimbs(&limbs)
        if r > 0 {
            limbs[limbs.count - 1] <<= 64 - r
            limbs[limbs.count - 1] >>= 64 - r
        }
        self.init(limbs)
    }

    // MARK: Prime number functions

    static internal func randomBytes(_ bytes: inout Bytes) {
        // guard SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes) == errSecSuccess else {
        //     fatalError("randomBytes failed")
        // }
    }

    static internal func randomLimbs(_ limbs: inout Limbs) {
        // guard SecRandomCopyBytes(kSecRandomDefault, 8 * limbs.count, &limbs) == errSecSuccess else {
        //     fatalError("randomLimbs failed")
        // }
    }

    // Small prime product
    static let SPP = BInt("152125131763605")! // = 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 37 * 41

    static func smallPrime(_ bitLength: Int) -> BInt {
        let multiple8 = bitLength & 0x7 == 0
        let length = multiple8 ? (bitLength + 7) >> 3 + 1 : (bitLength + 7) >> 3
        var bytes = Bytes(repeating: 0, count: length)
        let highBit = Byte(1 << ((bitLength + 7) & 0x7))  // High bit of high int
        let highMask = Byte((Int(highBit) << 1) - 1)  // Bits to keep in high int

        while true {
            BInt.randomBytes(&bytes)
            if multiple8 {
                bytes[0] = 0
                bytes[1] = (bytes[1] & highMask) | highBit
            } else {
                bytes[0] = (bytes[0] & highMask) | highBit
            }
            let x = BInt(signed: bytes)
            if bitLength > 6 {
                let r = x % SPP
                if r % 3 == 0 || r % 5 == 0 || r % 7 == 0 || r % 11 == 0 || r % 13 == 0 || r % 17 == 0 ||
                    r % 19 == 0 || r % 23 == 0 || r % 29 == 0 || r % 31 == 0 || r % 37 == 0 || r % 41 == 0 {
                    continue
                }
            }
            if x.isProbablyPrime() {
                return x
            }
        }
    }

    static func largePrime(_ bitLength: Int, _ p: Int) -> BInt {
        var x = BInt(bitWidth: bitLength)
        x.setBit(bitLength - 1)
        x.clearBit(0)
        var bs = BitSieve(x, p)
        var candidate = bs.retrieve()
        while candidate == nil || candidate!.bitWidth != bitLength {
            x += BInt(2 * bs.length)
            if x.bitWidth != bitLength {
                x = BInt(bitWidth: bitLength)
                x.setBit(bitLength - 1)
            }
            x.clearBit(0)
            bs = BitSieve(x, p)
            candidate = bs.retrieve()
        }
        return candidate!
    }

    /// Checks whether `self` is prime using the Miller-Rabin algorithm
    ///
    /// - Precondition: Probability parameter is positive
    /// - Parameter p: If `true` is returned, `self` is prime with probability > 1 - 1/2^p
    /// - Returns: `true` if `self` is probably prime, `false` if `self` is definitely not prime
    public func isProbablyPrime(_ p: Int = 30) -> Bool {
        precondition(p > 0, "Probability must be positive")
        if self == BInt.TWO {
            return true
        }
        if self.isEven || self < 2 {
            return false
        }
        var rounds: Int
        if self.bitWidth < 100 {
            rounds = 50
        } else if self.bitWidth < 256 {
            rounds = 27
        } else if bitWidth < 512 {
            rounds = 15
        } else if bitWidth < 768 {
            rounds = 8
        } else if bitWidth < 1024 {
            rounds = 4
        } else {
            rounds = 2
        }
        rounds = Swift.min((p + 1) / 2, rounds)
        let s1 = self - 1
        for _ in 0 ..< rounds {
            if !self.pass(s1.randomLessThan() + 1) {
                return false
            }
        }
        return true
    }

    func pass(_ a: BInt) -> Bool {
        let s_1 = self - 1
        let k = s_1.trailingZeroBitCount
        let m = s_1 >> k
        var x = a.expMod(m, self)
        if x == 1 {
            return true
        }
        if k > 0 {
            for _ in 0 ..< k - 1 {
                if x == s_1 {
                    return true
                }
                x = (x ** 2) % self
            }
        }
        return x == s_1
    }

    /// The next probable prime greater than `self`
    ///
    /// - Parameter p: The returned number is prime with probability > 1 - 1/2^p, default value is 30
    /// - Returns: The smallest probable prime greater than `self`, returns 2 if `self` is negative
    public func nextPrime(_ p: Int = 30) -> BInt {
        if self < BInt.TWO {
            return BInt.TWO
        }
        var result = self + BInt.ONE
        if result.bitWidth < 100 {
            if result.isEven {
                result += BInt.ONE
            }
            while true {
                if result.bitWidth > 6 {
                    let r = result % BInt.SPP
                    if r % 3 == 0 || r % 5 == 0 || r % 7 == 0 || r % 11 == 0 || r % 13 == 0 || r % 17 == 0 ||
                        r % 19 == 0 || r % 23 == 0 || r % 29 == 0 || r % 31 == 0 || r % 37 == 0 || r % 41 == 0 {
                        result += BInt.TWO
                        continue
                    }
                }
                if result.bitWidth < 4 || result.isProbablyPrime(p) {
                    return result
                }
                result += BInt.TWO
            }
        }
        if result.isOdd {
            result -= BInt.ONE
        }
        while true {
            let sieve = BitSieve(result, p)
            let candidate = sieve.retrieve()
            if candidate != nil {
                return candidate!
            }
            result += 2 * sieve.length
        }
    }

    /// A probable prime number with a given bitwidth
    ///
    /// - Precondition: bitWidth > 1
    /// - Parameters:
    ///   - bitWidth: The bitWidth - must be > 1
    ///   - p: The returned number is prime with probability > 1 - 1/2^p, default value is 30
    /// - Returns: A prime number with the specified bitwidth and probability
    public static func probablePrime(_ bitWidth: Int, _ p: Int = 30) -> BInt {
        precondition(bitWidth > 1, "Bitwidth must be > 1")
        return bitWidth < 100 ? smallPrime(bitWidth) : largePrime(bitWidth, p)
    }

    /// Random value
    ///
    /// - Precondition: `self` is positive
    /// - Returns: A uniformly distributed  random value in range 0 ..< `self`
    public func randomLessThan() -> BInt {
        precondition(self.isPositive, "Must be positive")
        var x: BInt
        repeat {
            x = BInt(bitWidth: self.bitWidth)
        } while x >= self
        return x
    }

    /// Random value
    ///
    /// - Precondition: *x* < `self`
    /// - Parameter x: Lower bound smaller than `self`
    /// - Returns: A uniformly distributed  random value in range *x* ..< `self`
    public func randomFrom(_ x: BInt) -> BInt {
        precondition(x < self, "Too large")
        return (self - x).randomLessThan() + x
    }

    /// Random value
    ///
    /// - Precondition: `self` < *x*
    /// - Parameter x: Upper bound larger than `self`
    /// - Returns: A uniformly distributed random value in range `self` ..< *x*
    public func randomTo(_ x: BInt) -> BInt {
        precondition(self < x, "Too small")
        return (x - self).randomLessThan() + self
    }

    /*
     * [CRANDALL] - algorithm 2.3.8
     */
    /// Square root modulo a prime number - `BInt` version
    ///
    /// - Parameter p: An odd prime number
    /// - Returns: x, such that x^2 = `self` (mod p), or `nil` if no such x exists
    public func sqrtMod(_ p: BInt) -> BInt? {
        if self.jacobiSymbol(p) != 1 {
            return nil
        }
        let A = self % p
        switch p.mod(8) {
        case 3, 7:
            return A.expMod((p + 1) >> 2, p)

        case 5:
            var x = A.expMod((p + 3) >> 3, p)
            if (x ** 2) % p != A % p {
                x = x * BInt.TWO.expMod((p - 1) >> 2, p) % p
            }
            return x

        case 1:
            let p_1 = p - 1
            var d = BInt.ZERO
            let p_3 = p - 3
            while true {
                d = p_3.randomLessThan() + 2
                if d.jacobiSymbol(p) == -1 {
                    break
                }
            }
            var s = 0
            var t = p_1
            while t.isEven {
                s += 1
                t >>= 1
            }
            let A1 = A.expMod(t, p)
            let D = d.expMod(t, p)
            var m = BInt.ZERO
            var exp = BInt.ONE << (s - 1)
            for i in 0 ..< s {
                if ((D.expMod(m * exp, p) * A1.expMod(exp, p))).mod(p) == p_1 {
                    m.setBit(i)
                }
                exp >>= 1
            }
            return (A.expMod((t + 1) >> 1, p) * D.expMod(m >> 1, p)) % p

        default:
            return nil
        }
    }
}

#endif
