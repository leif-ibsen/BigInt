//
//  BigInt.swift
//  BigInt
//
//  Created by Leif Ibsen on 24/12/2018.
//  Copyright © 2018 Leif Ibsen. All rights reserved.
//

/// Unsigned 8 bit value
public typealias Byte = UInt8
/// Array of unsigned 8 bit values
public typealias Bytes = [UInt8]

/// Unsigned 64 bit value
public typealias Limb = UInt64
/// Array of unsigned 64 bit values
public typealias Limbs = [UInt64]

precedencegroup ExponentiationPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
    lowerThan: BitwiseShiftPrecedence
}

infix operator ** : ExponentiationPrecedence

/// A signed integer of unbounded size.
/// A BInt value is represented with magnitude and sign.
/// The magnitude is an array of unsigned 64 bit integers (a.k.a. Limbs).
/// The sign is a boolean value, *true* means value < 0, *false* means value >= 0
/// The representation is little-endian, least significant Limb has index 0.
/// The representation is minimal, there is no leading zero Limbs.
/// The exception is that the value 0 is represented as a single 64 bit zero Limb and sign *false*
public struct BInt: CustomStringConvertible, Equatable, Hashable {    

    static let digits: [Character] = [
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    
    // MARK: - Constants

    /// BInt(0)
    public static let ZERO = BInt(0)
    /// BInt(1)
    public static let ONE = BInt(1)
    /// BInt(2)
    public static let TWO = BInt(2)
    /// BInt(3)
    public static let THREE = BInt(3)
    /// BInt(10)
    public static let TEN = BInt(10)


    // MARK: - Initializers

    /// Constructs a BInt from magnitude and sign
    ///
    /// - Parameters:
    ///   - magnitude: magnitude of value
    ///   - isNegative: *true* means negative value, *false* means 0 or positive value, default is *false*
    public init(_ magnitude: Limbs, _ isNegative : Bool = false) {
        self.magnitude = magnitude
        self.magnitude.normalize()
        self.isNegative = isNegative
        if self.isZero {
            self.isNegative = false
        }
    }

    /// Constructs a BInt from an Int value
    ///
    /// - Parameter x: Int value
    public init(_ x: Int) {
        if x == Int.min {
            self.init([0x8000000000000000], true)
        } else if x < 0 {
            self.init([Limb(-x)], true)
        } else {
            self.init([Limb(x)], false)
        }
    }
    
    /// Constructs a BInt from a String value and radix
    ///
    /// - Parameters:
    ///   - x: String value to be converted
    ///   - radix: Radix of x, from 2 to 36 inclusive, default is 10
    ///
    /// Examples:
    ///    * BInt("90abcdef", radix = 16)
    ///    * BInt("111110010", radix = 2)
    ///    * BInt("1cdefghijk44", radix = 26)
    public init?(_ x: String, radix: Int = 10) {
        if radix < 2 || radix > 36 {
            return nil
        }
        var sign = false
        var number = x
        if number.hasPrefix("-") {
            sign = true
            number.remove(at: number.startIndex)
        } else if number.hasPrefix("+") {
            number.remove(at: number.startIndex)
        }
        if number.isEmpty {
            return nil
        }
        var magnitude = [Limb(0)]
        
        // Find the number of digits that fits in a single Limb for the given radix
        // Process that number of digits at a time
        let digits = BInt.limbDigits[radix]
        
        // Groups of digits
        let digitGroups = number.count / digits
        
        // Pow = radix ** digits
        let pow = BInt.limbRadix[radix].magnitude
        
        // Number of digits to process
        var g = number.count - digitGroups * digits
        if g == 0 {
            g = digits
        }
        var i = 0
        var l = Limb(0)
        for c in number {
            if let digit = BInt.digits.firstIndex(of: c) {
                let d = digit < 36 ? digit : digit - 26
                if d >= radix {
                    return nil
                }
                l *= Limb(radix)
                l += Limb(d)
            } else {
                return nil
            }
            i += 1
            if i == g {
                magnitude.multiply(pow)
                magnitude.add(l)
                g = digits
                l = 0
                i = 0
            }
        }
        self.init(magnitude, sign)
    }

    /// Constructs a random BInt with a specified number of bits
    ///
    /// - Precondition: bitWidth is positive
    /// - Parameter bitWidth: Number of bits
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
    
    /// Constructs a BInt from a big-endian magnitude byte array representation
    ///
    /// - Precondition: Byte array is not empty
    /// - Parameter x: Magnitude big-endian byte array
    ///
    /// Examples:
    ///    * The byte array [1, 0, 0] represents BInt value 65536
    ///    * The byte array [128, 0] represents BInt value 32768
    ///    * The byte array [255, 127] represents BInt value 65407
    public init(magnitude x: Bytes) {
        precondition(!x.isEmpty, "Empty byte array")
        var bb = x
        if bb[0] > 127 {
            bb.insert(0, at: 0)
        }
        self.init(signed: bb)
    }
    
    /// Constructs a BInt from a big-endian 2's complement byte array representation
    ///
    /// - Precondition: Byte array is not empty
    /// - Parameter x: 2's complement big-endian byte array
    ///
    /// Examples:
    ///    * The byte array [1, 0, 0] represents BInt value 65536
    ///    * The byte array [128, 0] represents BInt value -32768
    ///    * The byte array [255, 127] represents BInt value -129
    public init(signed x: Bytes) {
        precondition(!x.isEmpty, "Empty byte array")
        self.isNegative = x[0] > 127
        var bb = x
        if self.isNegative {
            while bb.count > 1 && bb[0] == 255 {
                bb.remove(at: 0)
            }
        } else {
            while bb.count > 1 && bb[0] == 0 {
                bb.remove(at: 0)
            }
        }
        if self.isNegative {
            var carry = true
            var bbi = bb.count
            for _ in 0 ..< bb.count {
                bbi -= 1
                bb[bbi] = ~bb[bbi]
                if carry {
                    if bb[bbi] == 255 {
                        bb[bbi] = 0
                    } else {
                        bb[bbi] += 1
                        carry = false
                    }
                }
            }
            if carry {
                bb.insert(1, at: 0)
            }
        }
        let chunks = bb.count / 8
        let remaining = bb.count - chunks * 8
        self.magnitude = Limbs(repeating: 0, count: chunks + (remaining == 0 ? 0 : 1))
        var bi = 0
        var li = self.magnitude.count
        if remaining > 0 {
            li -= 1
        }
        for _ in 0 ..< remaining {
            self.magnitude[li] <<= 8
            self.magnitude[li] |= Limb(bb[bi])
            bi += 1
        }
        for _ in 0 ..< chunks {
            li -= 1
            for _ in 0 ..< 8 {
                self.magnitude[li] <<= 8
                self.magnitude[li] |= Limb(bb[bi])
                bi += 1
            }
        }
    }

    
    // MARK: Stored properties
    
    /// The sign, *true* if *self* < 0, *false* otherwise
    public internal(set) var isNegative: Bool

    /// The magnitude limb array
    public internal(set) var magnitude: Limbs

    
    // MARK: Computed properties
    
    /// The number of bits in the magnitude of *self*. 0 if *self* = 0
    public var bitWidth: Int {
        return self.magnitude.bitWidth
    }
    
    /// Base 10 string value of *self*
    public var description: String {
        return self.asString()
    }
    
    /// Is *true* if *self* is even, *false* if *self* is odd
    public var isEven: Bool {
        return self.magnitude[0] & 1 == 0
    }
    
    /// Is *false* if *self* = 0, *true* otherwise
    public var isNotZero: Bool {
        return self.magnitude.count > 1 || self.magnitude[0] > 0
    }
    
    /// Is *true* if *self* is odd, *false* if *self* is even
    public var isOdd: Bool {
        return self.magnitude[0] & 1 == 1
    }
    
    /// Is *true* if *self* = 1, *false* otherwise
    public var isOne: Bool {
        return self.magnitude.count == 1 && self.magnitude[0] == 1 && !self.isNegative
    }
    
    /// Is *true* if *self* > 0, *false* otherwise
    public var isPositive: Bool {
        return !self.isNegative && self.isNotZero
    }

    /// Is *true* if *self* = 0, *false* otherwise
    public var isZero: Bool {
        return self.magnitude.count == 1 && self.magnitude[0] == 0
    }
    
    /// The absolute value of *self*
    public var abs: BInt {
        return BInt(self.magnitude)
    }

    /// The number of leading zero bits in the magnitude of *self*. 0 if *self* = 0
    public var leadingZeroBitCount: Int {
        return self.isZero ? 0 : self.magnitude.last!.leadingZeroBitCount
    }
    
    /// Is 0 if *self* = 0, 1 if *self* > 0, and -1 if *self* < 0
    public var signum: Int {
        return self.isZero ? 0 : (self.isNegative ? -1 : 1)
    }

    /// The number of trailing zero bits in the magnitude of *self*. 0 if *self* = 0
    public var trailingZeroBitCount: Int {
        return self.magnitude.trailingZeroBitCount()
    }

    mutating func setSign(_ sign: Bool) {
        self.isNegative = self.isZero ? false : sign
    }

    
    // MARK: Conversion functions to Int, String, and Bytes

    /// *self* as an Int
    ///
    /// - Returns: *self* as an Int or *nil* if *self* is not representable as an Int
    public func asInt() -> Int? {
        if self.magnitude.count > 1 {
            return nil
        }
        let mag0 = self.magnitude[0]
        if self.isNegative {
            return mag0 > 0x8000000000000000 ? nil : (mag0 == 0x8000000000000000 ? Int.min : -Int(mag0))
        } else {
            return mag0 < 0x8000000000000000 ? Int(mag0) : nil
        }
    }
    
    static let zeros = "000000000000000000000000000000000000000000000000000000000000000"
    static let limbDigits = [0, 0,
                             63, 40, 31, 27, 24, 22, 21, 20, 19, 18, 17, 17, 16, 16, 15, 15, 15,
                             15, 14, 14, 14, 14, 13, 13, 13, 13, 13, 13, 13, 12, 12, 12, 12, 12, 12]
    static let limbRadix = [BInt(0), BInt(0),
                            BInt([0x8000000000000000]),
                            BInt([0xa8b8b452291fe821]),
                            BInt([0x4000000000000000]),
                            BInt([0x6765c793fa10079d]),
                            BInt([0x41c21cb8e1000000]),
                            BInt([0x3642798750226111]),
                            BInt([0x8000000000000000]),
                            BInt([0xa8b8b452291fe821]),
                            BInt([0x8ac7230489e80000]),
                            BInt([0x4d28cb56c33fa539]),
                            BInt([0x1eca170c00000000]),
                            BInt([0x780c7372621bd74d]),
                            BInt([0x1e39a5057d810000]),
                            BInt([0x5b27ac993df97701]),
                            BInt([0x1000000000000000]),
                            BInt([0x27b95e997e21d9f1]),
                            BInt([0x5da0e1e53c5c8000]),
                            BInt([0xd2ae3299c1c4aedb]),
                            BInt([0x16bcc41e90000000]),
                            BInt([0x2d04b7fdd9c0ef49]),
                            BInt([0x5658597bcaa24000]),
                            BInt([0xa0e2073737609371]),
                            BInt([0xc29e98000000000]),
                            BInt([0x14adf4b7320334b9]),
                            BInt([0x226ed36478bfa000]),
                            BInt([0x383d9170b85ff80b]),
                            BInt([0x5a3c23e39c000000]),
                            BInt([0x8e65137388122bcd]),
                            BInt([0xdd41bb36d259e000]),
                            BInt([0xaee5720ee830681]),
                            BInt([0x1000000000000000]),
                            BInt([0x172588ad4f5f0981]),
                            BInt([0x211e44f7d02c1000]),
                            BInt([0x2ee56725f06e5c71]),
                            BInt([0x41c21cb8e1000000])]

    /// Byte array representation of magnitude value
    ///
    /// - Returns: Minimal big-endian magnitude byte array representation
    ///
    /// Examples:
    ///    * BInt(1).asMagnitudeBytes() = [1]
    ///    * BInt(-1).asMagnitudeBytes() = [1]
    public func asMagnitudeBytes() -> Bytes {
        var bb = (self.isNegative ? -self : self).asSignedBytes()
        while bb.count > 1 && bb[0] == 0 {
            bb.remove(at: 0)
        }
        return bb
    }
    
    /// Byte array representation of 2's complement value
    ///
    /// - Returns: Minimal big-endian 2's complement byte array representation
    ///
    /// Examples:
    ///    * BInt(1).asSignedBytes() = [1]
    ///    * BInt(-1).asSignedBytes() = [255]
    public func asSignedBytes() -> Bytes {
        var xl = self.magnitude
        if self.isNegative {
            var carry = true
            for i in 0 ..< xl.count {
                xl[i] = ~xl[i]
                if carry {
                    if xl[i] == Limb.max {
                        xl[i] = 0
                    } else {
                        xl[i] += 1
                        carry = false
                    }
                }
            }
        }
        var bb = Bytes(repeating: 0, count: xl.count * 8)
        var bbi = bb.count
        for i in 0 ..< xl.count {
            var l = xl[i]
            for _ in 0 ..< 8 {
                bbi -= 1
                bb[bbi] = Byte(l & 0xff)
                l >>= 8
            }
        }
        if self.isNegative {
            if bb[0] < 128 {
                bb.insert(255, at: 0)
            }
            while bb.count > 1 && bb[0] == 255 && bb[1] > 127 {
                bb.remove(at: 0)
            }
        } else {
            if bb[0] > 127 {
                bb.insert(0, at: 0)
            }
            while bb.count > 1 && bb[0] == 0 && bb[1] < 128 {
                bb.remove(at: 0)
            }
        }
        return bb
    }
    
    /// *self* as a String with a given radix
    ///
    /// - Precondition: Radix between 2 and 36 inclusive
    /// - Parameters:
    ///   - radix: Radix from 2 to 36 inclusive
    ///   - uppercase: *true* to use uppercase letters, *false* to use lowercase letters, default is *false*
    /// - Returns: *self* as a String in the given radix
    public func asString(radix: Int = 10, uppercase: Bool = false) -> String {
        precondition(radix >= 2 && radix <= 36, "Wrong radix \(radix)")
        if self.isZero {
            return "0"
        }
        let d = BInt.limbRadix[radix]
        var digitGroups = [String]()
        var tmp = BInt(self.magnitude)
        while tmp.isNotZero {
            let (q, r) = tmp.quotientAndRemainder(dividingBy: d)
            digitGroups.append(r.isZero ? "0" : String(r.magnitude[0], radix: radix, uppercase: uppercase))
            tmp = q
        }
        var result = self.isNegative ? "-" : ""
        result += digitGroups.last!
        for i in (0 ..< digitGroups.count - 1).reversed() {
            let leadingZeros = BInt.limbDigits[radix] - digitGroups[i].count
            result += BInt.zeros.prefix(leadingZeros)
            result += digitGroups[i]
        }
        return result
    }

    static func toSignedLimbsPair(_ x: BInt, _ y: BInt) -> (bx: Limbs, by: Limbs) {
        var bx = x.magnitude
        var by = y.magnitude
        if x.isNegative {
            invert(&bx)
            if bx.last! & 0x8000000000000000 == 0 {
                bx.append(0xffffffffffffffff)
            }
        } else {
            if bx.last! & 0x8000000000000000 != 0 {
                bx.append(0)
            }
        }
        if y.isNegative {
            invert(&by)
            if by.last! & 0x8000000000000000 == 0 {
                by.append(0xffffffffffffffff)
            }
        } else {
            if by.last! & 0x8000000000000000 != 0 {
                by.append(0)
            }
        }
        let x0: Limb = bx.last! & 0x8000000000000000 == 0 ? 0 : 0xffffffffffffffff
        let y0: Limb = by.last! & 0x8000000000000000 == 0 ? 0 : 0xffffffffffffffff
        while bx.count < by.count {
            bx.append(x0)
        }
        while by.count < bx.count {
            by.append(y0)
        }
        return (bx, by)
    }

    static func fromSignedLimbs(_ x: inout Limbs) -> BInt {
        if x.last! & 0x8000000000000000 != 0 {
            invert(&x)
            return BInt(x, true)
        }
        return BInt(x)
    }

    static func invert(_ x: inout Limbs) {
        // flip the bits
        for i in 0 ..< x.count {
            x[i] ^= 0xffffffffffffffff
        }
        // and add 1
        var i = 0
        var carry = true
        while carry && i < x.count {
            x[i] = x[i] &+ 1
            carry = x[i] == 0
            i += 1
        }
        if carry {
            x.append(1)
        }
    }

    
    // MARK: Bit operation functions

    /// Bitwise **and** operator - behaves as if two's complement representation were used,</br>
    /// although this is not actually the case
    ///
    /// - Parameters:
    ///   - x: First value
    ///   - y: Second value
    /// - Returns: BInt(signed: bx & by) where
    ///   - bx = x.asSignedBytes()
    ///   - by = y.asSignedBytes()
    public static func &(x: BInt, y: BInt) -> BInt {
        var (bx, by) = toSignedLimbsPair(x, y)
        for i in 0 ..< bx.count {
            bx[i] = bx[i] & by[i]
        }
        return fromSignedLimbs(&bx)
    }

    /// x = x & y
    ///
    /// - Parameters:
    ///   - x: Left hand parameter
    ///   - y: Right hand parameter
    public static func &=(x: inout BInt, y: BInt) {
        x = x & y
    }
    
    /// Bitwise **or** operator - behaves as if two's complement representation were used,</br>
    /// although this is not actually the case
    ///
    /// - Parameters:
    ///   - x: First value
    ///   - y: Second value
    /// - Returns: BInt(signed: bx | by) where
    ///   - bx = x.asSignedBytes()
    ///   - by = y.asSignedBytes()
    public static func |(x: BInt, y: BInt) -> BInt {
        var (bx, by) = toSignedLimbsPair(x, y)
        for i in 0 ..< bx.count {
            bx[i] = bx[i] | by[i]
        }
        return fromSignedLimbs(&bx)
    }

    /// x = x | y
    ///
    /// - Parameters:
    ///   - x: Left hand parameter
    ///   - y: Right hand parameter
    public static func |=(x: inout BInt, y: BInt) {
        x = x | y
    }
    
    /// Bitwise **xor** operator - behaves as if two's complement representation were used,</br>
    /// although this is not actually the case
    ///
    /// - Parameters:
    ///   - x: First value
    ///   - y: Second value
    /// - Returns: BInt(signed: bx ^ by) where
    ///   - bx = x.asSignedBytes()
    ///   - by = y.asSignedBytes()
    public static func ^(x: BInt, y: BInt) -> BInt {
        var (bx, by) = toSignedLimbsPair(x, y)
        for i in 0 ..< bx.count {
            bx[i] = bx[i] ^ by[i]
        }
        return fromSignedLimbs(&bx)
    }

    /// x = x ^ y
    ///
    /// - Parameters:
    ///   - x: Left hand parameter
    ///   - y: Right hand parameter
    public static func ^=(x: inout BInt, y: BInt) {
        x = x ^ y
    }
    
    /// Bitwise **not** operator - behaves as if two's complement arithmetic were used,</br>
    /// although this is not actually the case
    ///
    /// - Parameter x: BInt value
    /// - Returns: -x - 1
    public static prefix func ~(x: BInt) -> BInt {
        return -x - 1
    }
    
    /// Clear a specified bit
    ///
    /// - Parameter n: Bit number
    public mutating func clearBit(_ n: Int) {
        self.magnitude.setBitAt(n, to: false)
    }
    
    /// Invert a specified bit
    ///
    /// - Parameter n: Bit number
    public mutating func flipBit(_ n: Int) {
        self.magnitude.setBitAt(n, to: !self.magnitude.getBitAt(n))
    }
    
    /// Set a specified bit
    ///
    /// - Parameter n: Bit number
    public mutating func setBit(_ n: Int) {
        self.magnitude.setBitAt(n, to: true)
    }
    
    /// Test a specified bit
    ///
    /// - Parameter n: Bit number
    /// - Returns: *true* if bit is set, *false* otherwise
    public func testBit(_ n: Int) -> Bool {
        return self.magnitude.getBitAt(n)
    }

    
    // MARK: Addition functions
    
    /// Prefix plus
    ///
    /// - Parameter x: BInt value
    /// - Returns: x
    public prefix static func +(x: BInt) -> BInt {
        return x
    }
    
    /// Addition
    ///
    /// - Parameters:
    ///   - x: First addend
    ///   - y: Second addend
    /// - Returns: x + y
    public static func +(x: BInt, y: BInt) -> BInt {
        var sum = x
        sum += y
        return sum
    }
    
    /// Addition
    ///
    /// - Parameters:
    ///   - x: First addend
    ///   - y: Second addend
    /// - Returns: x + y
    public static func +(x: Int, y: BInt) -> BInt {
        var sum = y
        sum += x
        return sum
    }

    /// Addition
    ///
    /// - Parameters:
    ///   - x: First addend
    ///   - y: Second addend
    /// - Returns: x + y
    public static func +(x: BInt, y: Int) -> BInt {
        var sum = x
        sum += y
        return sum
    }

    /// x = x + y
    ///
    /// - Parameters:
    ///   - x: Left hand addend
    ///   - y: Right hand addend
    public static func +=(x: inout BInt, y: BInt) {
        if x.isNegative == y.isNegative {
            x.magnitude.add(y.magnitude)
        } else {
            let cmp = x.magnitude.difference(y.magnitude)
            if cmp < 0 {
                x.isNegative = !x.isNegative
            } else if cmp == 0 {
                x.isNegative = false
            }
        }
    }

    /// x = x + y
    ///
    /// - Parameters:
    ///   - x: Left hand addend
    ///   - y: Right hand addend
    public static func +=(x: inout BInt, y: Int) {
        let absy = Limb(Swift.abs(y))
        if (y < 0 && x.isNegative) || (y >= 0 && !x.isNegative) {
            x.magnitude.add(absy)
        } else {
            let cmp = x.magnitude.compare(absy)
            x.magnitude.difference(absy)
            if cmp < 0 {
                x.isNegative = !x.isNegative
            } else if cmp == 0 {
                x.isNegative = false
            }
        }
    }

    
    // MARK: Negation functions
    
    /// Negates *self*
    public mutating func negate() {
        if self.isNotZero {
            self.isNegative = !self.isNegative
        }
    }
    
    /// Negation
    ///
    /// - Parameter x: Operand
    /// - Returns: -x
    public static prefix func -(x: BInt) -> BInt {
        var y = x
        y.negate()
        return y
    }
    
    
    // MARK: Subtraction functions

    /// Subtraction
    ///
    /// - Parameters:
    ///   - x: Minuend
    ///   - y: Subtrahend
    /// - Returns: x - y
    public static func -(x: BInt, y: BInt) -> BInt {
        var diff = x
        diff -= y
        return diff
    }
    
    /// Subtraction
    ///
    /// - Parameters:
    ///   - x: Minuend
    ///   - y: Subtrahend
    /// - Returns: x - y
    public static func -(x: Int, y: BInt) -> BInt {
        var diff = y
        diff -= x
        return -diff
    }

    /// Subtraction
    ///
    /// - Parameters:
    ///   - x: Minuend
    ///   - y: Subtrahend
    /// - Returns: x - y
    public static func -(x: BInt, y: Int) -> BInt {
        var diff = x
        diff -= y
        return diff
    }

    /// x = x - y
    ///
    /// - Parameters:
    ///   - x: Left hand minuend
    ///   - y: Right hand subtrahend
    public static func -=(x: inout BInt, y: BInt) {
        if x.isNegative == y.isNegative {
            let cmp = x.magnitude.difference(y.magnitude)
            if cmp < 0 {
                x.isNegative = !x.isNegative
            } else if cmp == 0 {
                x.isNegative = false
            }
        } else {
            x.magnitude.add(y.magnitude)
        }
    }

    /// x = x - y
    ///
    /// - Parameters:
    ///   - x: Left hand minuend
    ///   - y: Right hand subtrahend
    public static func -=(x: inout BInt, y: Int) {
        let absy = Limb(Swift.abs(y))
        if (y < 0 && !x.isNegative) || (y >= 0 && x.isNegative) {
            x.magnitude.add(absy)
        } else {
            let cmp = x.magnitude.compare(absy)
            x.magnitude.difference(absy)
            if cmp < 0 {
                x.isNegative = !x.isNegative
            } else if cmp == 0 {
                x.isNegative = false
            }
        }
    }


    // MARK: Multiplication functions
    
    /// Multiplication
    ///
    /// - Parameters:
    ///   - x: Multiplier
    ///   - y: Multiplicand
    /// - Returns: x * y
    public static func *(x: BInt, y: BInt) -> BInt {
        var prod = x
        prod *= y
        return prod
    }

    /// Multiplication
    ///
    /// - Parameters:
    ///   - x: Multiplier
    ///   - y: Multiplicand
    /// - Returns: x * y
    public static func *(x: Int, y: BInt) -> BInt {
        var prod = y
        prod *= x
        return prod
    }

    /// Multiplication
    ///
    /// - Parameters:
    ///   - x: Multiplier
    ///   - y: Multiplicand
    /// - Returns: x * y
    public static func *(x: BInt, y: Int) -> BInt {
        var prod = x
        prod *= y
        return prod
    }

    /// x = x * y
    ///
    /// - Parameters:
    ///   - x: Left hand multiplier
    ///   - y: Right hand multiplicand
    public static func *=(x: inout BInt, y: BInt) {
        x.magnitude.multiply(y.magnitude)
        x.setSign(x.isNegative != y.isNegative)
    }

    /// x = x * y
    ///
    /// - Parameters:
    ///   - x: Left hand multiplier
    ///   - y: Right hand multiplicand
    public static func *=(x: inout BInt, y: Int) {
        if y > 0 {
            x.magnitude.multiply(Limb(y))
        } else if y < 0 {
            x.magnitude.multiply(Limb(-y))
            x.setSign(!x.isNegative)
        } else {
            x = BInt.ZERO
        }
    }
    
    
    // MARK: Division functions
    
    /// Division
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameter x: Divisor
    /// - Returns: Quotient and remainder of *self* / x
    public func quotientAndRemainder(dividingBy x: BInt) -> (quotient: BInt, remainder: BInt) {
        var quotient = BInt.ZERO
        var remainder = BInt.ZERO
        self.quotientAndRemainder(dividingBy: x, &quotient, &remainder)
        return (quotient, remainder)
    }
    
    /// Division
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Divisor
    ///   - quotient: Set to the quotient of *self* / x
    ///   - remainder: Set to the remainder of *self* / x
    public func quotientAndRemainder(dividingBy x: BInt, _ quotient: inout BInt, _ remainder: inout BInt) {
        self.magnitude.divMod(x.magnitude, &quotient.magnitude, &remainder.magnitude)
        quotient.setSign(self.isNegative != x.isNegative)
        remainder.setSign(self.isNegative)
    }
    
    /// Division
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Dividend
    ///   - y: Divisor
    /// - Returns: x / y
    public static func /(x: BInt, y: BInt) -> BInt {
        return x.quotientAndRemainder(dividingBy: y).quotient
    }
    
    /// Division
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Dividend
    ///   - y: Divisor
    /// - Returns: x / y
    public static func /(x: Int, y: BInt) -> BInt {
        return BInt(x) / y
    }
    
    /// Division
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Dividend
    ///   - y: Divisor
    /// - Returns: x / y
    public static func /(x: BInt, y: Int) -> BInt {
        return x / BInt(y)
    }
    
    /// x = x / y
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Left hand dividend
    ///   - y: Right hand divisor
    public static func /=(x: inout BInt, y: BInt) {
        x = x / y
    }
    
    /// x = x / y
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Left hand dividend
    ///   - y: Right hand divisor
    public static func /=(x: inout BInt, y: Int) {
        x = x / y
    }


    // MARK: Remainder and modulus functions
    
    /// Remainder
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Dividend
    ///   - y: Divisor
    /// - Returns: x % y
    public static func %(x: BInt, y: BInt) -> BInt {
        return x.quotientAndRemainder(dividingBy: y).remainder
    }
    
    /// Remainder
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Dividend
    ///   - y: Divisor
    /// - Returns: x % y
    public static func %(x: Int, y: BInt) -> BInt {
        return BInt(x) % y
    }

    /// Remainder
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Dividend
    ///   - y: Divisor
    /// - Returns: x % y
    public static func %(x: BInt, y: Int) -> BInt {
        return x % BInt(y)
    }

    /// x = x % y
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Dividend
    ///   - y: Divisor
    public static func %=(x: inout BInt,y: BInt) {
        x = x % y
    }

    /// x = x % y
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameters:
    ///   - x: Dividend
    ///   - y: Divisor
    public static func %=(x: inout BInt, y: Int) {
        x = x % y
    }
    
    /// Modulus
    ///
    /// - Precondition: Divisor is not zero
    /// - Parameter x: Divisor
    /// - Returns: *self* *mod* x, a non-negative value
    public func mod(_ x: BInt) -> BInt {
        let r = self % x
        if x.isNegative {
            return r.isNegative ? r - x : r
        } else {
            return r.isNegative ? r + x : r
        }
    }

    /*
     * [CRANDALL] - algorithm 2.1.4
     *
     * Return self modinverse m
     */
    /// Inverse modulus
    ///
    /// - Precondition: *self* and modulus are coprime, modulus is positive
    /// - Parameter m: Modulus
    /// - Returns: If *self* and m are coprime, x such that (*self* * x) mod m = 1
    public func modInverse(_ m: BInt) -> BInt {
        precondition(m.isPositive, "Modulus must be positive")
        var a = BInt.ONE
        var b = BInt.ZERO
        var g = self.mod(m)
        var u = BInt.ZERO
        var v = BInt.ONE
        var w = m
        while w.isPositive {
            let q = g / w
            (a, b, g, u, v, w) = (u, v, w, a - q * u, b - q * v, g - q * w)
        }
        precondition(g.isOne, "Modulus and self are not coprime")
        return a.isNegative ? a + m : a
    }


    // MARK: Exponentiation functions

    /// Exponentiation
    ///
    /// - Precondition: Exponent is non-negative
    /// - Parameters:
    ///   - a: Operand
    ///   - x: Non-negative exponent
    /// - Returns: a^x
    public static func **(a: BInt, x: Int) -> BInt {
        precondition(x >= 0, "Exponent must be non-negative")
        return x == 2 ? a * a : BInt(a.magnitude.raisedTo(x), a.isNegative && (x & 1 == 1))
    }

    /*
     * Return (self ** x) mod m
     *
     * Use Barrett reduction algorithm for x.bitWidth < 2048, else use Montgomery reduction algorithm
     */
    /// Modular exponentiation
    ///
    /// - Precondition: Modulus is positive
    /// - Parameters:
    ///   - x: The exponent
    ///   - m: The modulus, a positive number
    /// - Returns: (*self*^x) mod m for positive x, ((*self*^-x) mod m) modInverse m for negative x
    public func expMod(_ x: BInt, _ m: BInt) -> BInt {
        precondition(m.isPositive, "Modulus must be positive")
        if m.isOne {
            return BInt.ZERO
        }
        let exponent = x.isNegative ? -x : x
        var result: BInt
        if exponent.magnitude.count <= 32 {
            result = BarrettModulus(self, m).expMod(exponent)
        } else if m.isOdd {
            result = MontgomeryModulus(self, m).expMod(exponent)
        } else {
            
            // Split the modulus into an odd part and a power of 2 part
            
            let trailing = m.trailingZeroBitCount
            let oddModulus = m >> trailing
            let pow2Modulus = BInt.ONE << trailing
            let a1 = MontgomeryModulus(self, oddModulus).expMod(exponent)
            let a2 = Pow2Modulus(self, pow2Modulus).expMod(exponent)
            let y1 = pow2Modulus.modInverse(oddModulus)
            let y2 = oddModulus.modInverse(pow2Modulus)
            result = (a1 * pow2Modulus * y1 + a2 * oddModulus * y2).mod(m)
        }
        if x.isNegative {
            result = result.modInverse(m)
        }
        if self.isNegative {
            return x.isEven || result.isZero ? result : m - result
        } else {
            return result
        }
    }


    // MARK: Comparison functions
    
    /// Equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x = y, *false* otherwise
    public static func ==(x: BInt, y: BInt) -> Bool {
        return x.magnitude == y.magnitude && x.isNegative == y.isNegative
    }
    
    /// Equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x = y, *false* otherwise
    public static func ==(x: BInt, y: Int) -> Bool {
        return x == BInt(y)
    }
    
    /// Equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x = y, *false* otherwise
    public static func ==(x: Int, y: BInt) -> Bool {
        return BInt(x) == y
    }
    
    /// Not equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x != y, *false* otherwise
    public static func !=(x: BInt, y: BInt) -> Bool {
        return x.magnitude != y.magnitude || x.isNegative != y.isNegative
    }
    
    /// Not equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x != y, *false* otherwise
    public static func !=(x: BInt, y: Int) -> Bool {
        return x != BInt(y)
   }
    
    /// Not equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x != y, *false* otherwise
    public static func !=(x: Int, y: BInt) -> Bool {
        return BInt(x) != y
    }
    
    /// Less then
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x < y, *false* otherwise
    public static func <(x: BInt, y: BInt) -> Bool {
        if x.isNegative && y.isNegative {
            return y.magnitude.lessThan(x.magnitude)
        } else if !x.isNegative && y.isNegative {
            return false
        } else if x.isNegative && !y.isNegative {
            return true
        } else {
            return x.magnitude.lessThan(y.magnitude)
        }
    }
    
    /// Less than
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x < y, *false* otherwise
    public static func <(x: BInt, y: Int) -> Bool {
        return x < BInt(y)
    }
    
    /// Less than
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x < y, *false* otherwise
    public static func <(x: Int, y: BInt) -> Bool {
        return BInt(x) < y
    }
    
    /// Greater than
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x > y, *false* otherwise
    public static func >(x: BInt, y: BInt) -> Bool {
        return y < x
    }
    
    /// Greater than
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x > y, *false* otherwise
    public static func >(x: Int, y: BInt) -> Bool {
        return y < x
    }
    
    /// Greater than
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x > y, *false* otherwise
    public static func >(x: BInt, y: Int) -> Bool {
        return y < x
    }
    
    /// Less than or equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x <= y, *false* otherwise
    public static func <=(x: BInt, y: BInt) -> Bool {
        return !(y < x)
    }
    
    /// Less than or equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x <= y, *false* otherwise
    public static func <=(x: Int, y: BInt) -> Bool {
        return !(y < x)
    }

    /// Less than or equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x <= y, *false* otherwise
    public static func <=(x: BInt, y: Int) -> Bool {
        return !(y < x)
    }
    
    /// Greater than or equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x >= y, *false* otherwise
    public static func >=(x: BInt, y: BInt) -> Bool {
        return !(x < y)
    }

    /// Greater than or equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x >= y, *false* otherwise
    public static func >=(x: Int, y: BInt) -> Bool {
        return !(x < y)
    }

    /// Greater than or equal
    ///
    /// - Parameters:
    ///   - x: First operand
    ///   - y: Second operand
    /// - Returns: *true* if x >= y, *false* otherwise
    public static func >=(x: BInt, y: Int) -> Bool {
        return !(x < y)
    }


    // MARK: Shift functions

    /// Logical left shift
    ///
    /// - Parameters:
    ///   - x: Operand
    ///   - n: Shift count
    /// - Returns:
    ///   - BInt(x.magnitude << n, x.isNegative) if n > 0
    ///   - BInt(x.magnitude >> -n, x.isNegative) if n < 0
    ///   - x if n = 0
    public static func <<(x: BInt, n: Int) -> BInt {
        if n < 0 {
            return x >> -n
        }
        return BInt(n == 1 ? x.magnitude.shifted1Left() : x.magnitude.shiftedLeft(n), x.isNegative)
    }
    
    /// x = x << n
    ///
    /// - Parameters:
    ///   - x: Operand
    ///   - n: Shift count
    public static func <<=(x: inout BInt, n: Int) {
        if n < 0 {
            x.magnitude.shiftRight(-n)
        } else if n == 1 {
            x.magnitude.shift1Left()
        } else {
            x.magnitude.shiftLeft(n)
        }
    }
    
    /// Logical right shift
    ///
    /// - Parameters:
    ///   - x: Operand
    ///   - n: Shift count
    /// - Returns:
    ///   - BInt(x.magnitude >> n, x.isNegative) if n > 0
    ///   - BInt(x.magnitude << -n, x.isNegative) if n < 0
    ///   - x if n = 0
    public static func >>(x: BInt, n: Int) -> BInt {
        if n < 0 {
            return x << -n
        }
        return BInt(n == 1 ? x.magnitude.shifted1Right() : x.magnitude.shiftedRight(n), x.isNegative)
    }
    
    /// x = x >> n
    ///
    /// - Parameters:
    ///   - x: Operand
    ///   - n: Shift count
    public static func >>=(x: inout BInt, n: Int) {
        if n < 0 {
            x.magnitude.shiftLeft(-n)
        } else if n == 1 {
            x.magnitude.shift1Right()
        } else {
            x.magnitude.shiftRight(n)
        }
        if x.isZero {
            x.isNegative = false
        }
    }

    
    // MARK: Prime number functions
    
    static internal var random = SystemRandomNumberGenerator()

    static internal func randomBytes(_ bytes: inout Bytes) {
        for i in 0 ..< bytes.count {
            bytes[i] = BInt.random.next()
        }
    }
        
    static internal func randomLimbs(_ limbs: inout Limbs) {
        for i in 0 ..< limbs.count {
            limbs[i] = BInt.random.next()
        }
    }
        
    // Small prime product
    static let SPP = BInt(3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 37 * 41)

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

    /// Checks whether *self* is prime using the Miller-Rabin algorithm
    ///
    /// - Parameter p: If *true* is returned, *self* is prime with probability > 1-1/2^p
    /// - Returns: *true* if *self* is probably prime, *false* if *self* is definitely not prime
    public func isProbablyPrime(_ p: Int = 30) -> Bool {
        if self < 2 {
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
        rounds = min((p + 1) / 2, rounds)
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
                x = (x * x) % self
            }
        }
        return x == s_1
    }

    /// A probable prime number with a given bitwidth
    ///
    /// - Parameters:
    ///   - bitWidth: The bitWidth
    ///   - p: The returned number is prime with probability > 1-1/2^p, default value is 30
    /// - Returns: A prime number with the specified bitwidth and probability
    public static func probablePrime(_ bitWidth: Int, _ p: Int = 30) -> BInt {
        return bitWidth < 100 ? smallPrime(bitWidth) : largePrime(bitWidth, p)
    }


    // MARK: Miscellaneous functions

    /// Greatest common divisor
    ///
    /// - Parameter x: Operand
    /// - Returns: Greatest common divisor of magnitude of *self* and magnitude of x
    public func gcd(_ x: BInt) -> BInt {
        return BInt(self.magnitude.gcd(x.magnitude))
    }
    
    /*
     * [CRANDALL] - algorithm 2.3.5
     */
    /// Jacobi symbol
    ///
    /// - Parameters:
    ///   - m: An integer value
    /// - Returns: The Jacobi symbol of *self* and m, or 0 if it does not exist
    public func jacobiSymbol(_ m: BInt) -> Int {
        var m1 = m
        var a = self % m1
        var t = 1
        while a.isNotZero {
            var x: BInt
            while a.isEven {
                a >>= 1
                x = m1 % 8
                if x == 3 || x == 5 {
                    t = -t
                }
            }
            x = a
            a = m1
            m1 = x
            if a % 4 == 3 && m1 % 4 == 3 {
                t = -t
            }
            a %= m1
        }
        return m1 == 1 ? t : 0
    }
    
    /// Random value
    ///
    /// - Precondition: *self* is positive
    /// - Returns: A random value < absolute value of *self*
    public func randomLessThan() -> BInt {
        precondition(self.isPositive, "Must be positive")
        return BInt(bitWidth: self.bitWidth) % self
    }

    /*
     * [CRANDALL] - exercise 4.11
     */
    /// n'th root of a non-negative number
    ///
    /// - Precondition:
    ///   - *self* is non-negative
    ///   - n is positive
    /// - Parameter n: The root
    /// - Returns: Largest x such that x^n <= *self*
    public func root(_ n: Int) -> BInt {
        precondition(!self.isNegative, "\(n)'th root of negative number")
        precondition(n > 0, "non-positive root")
        if self.isZero {
            return BInt.ZERO
        }
        let bn = BInt(n)
        let bn1 = bn - 1
        var x = BInt.ONE << (self.bitWidth / n + 1)
        while true {
            let xx = x ** (n - 1)
            let y = (self / xx + x * bn1) / bn
            if y >= x {
                return x
            }
            x = y
        }
    }
        
    /*
     * [CRANDALL] - algorithm 9.2.11
     */
    /// Square root of a non-negative number
    ///
    /// - Precondition: *self* is non-negative
    /// - Returns: Largest x such that x^2 <= *self*
    public func sqrt() -> BInt {
        precondition(!self.isNegative, "Square root of negative number")
        if self.isZero {
            return BInt.ZERO
        }
        var x = BInt.ONE << (self.bitWidth / 2 + 1)
        while true {
            let y = (self / x + x) >> 1
            if y >= x {
                return x
            }
            x = y
        }
    }

    /*
     * [CRANDALL] - algorithm 2.3.8
     */
    /// Square root modulo a prime number
    ///
    /// - Parameter p: An odd prime number
    /// - Returns: x, such that x^2 mod p = *self*, or *nil* if no such x exists
    public func sqrtMod(_ p: BInt) -> BInt? {
        if self.jacobiSymbol(p) != 1 {
            return nil
        }
        let A = self % p
        switch (p % 8).asInt() {
        case 3, 7:
            return A.expMod((p + 1) >> 2, p)
        
        case 5:
            var x = A.expMod((p + 3) >> 3, p)
            if (x * x) % p != A % p {
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
