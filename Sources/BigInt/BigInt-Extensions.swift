//
//  BigInt-Extensions.swift
//
//  Created by Mike Griebling on 13.07.2023.
//
///  Added `SignedInteger`, `BinaryInteger`, and `Numeric` protocol compliance.
///  Optional support for `StaticBigInt`.  Note: These extensions require
///  renaming `magnitude` to `words` to avoid conflict with the
///  `Numeric` protocol variable also called `magnitude`.
///
///  Why support protocols? By supporting them you have the ability to
///  formulate generic algorithms and make use of algorithms from others
///  that use the protocol type(s) you support. For example, `Strideable`
///  compliance is free (with `BinaryInteger`) and lets you do things like
///
///  ```swift
///  for i in BInt(1)...10 {
///     print(i.words)
///  }
///  ```
///
///  The main header also
///  includes `Codable` compliance conformity (for free).  `Codable`
///  compliance allows `BInt`s to be distributed/received or stored/read as
///  JSONs.
///
///  Protocols mean you can support generic arguments:
///  (e.g., `func * <T:BinaryInteger>(_ lhs: Self, rhs: T) -> Self`)
///  which works with all `BinaryIntegers`, including `BigInt`s instead of
///  just `Int`s or a single integer type.
///

extension BInt : SignedInteger {
    public static var isSigned: Bool { true }
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    public init<T>(_ source: T) where T : BinaryInteger {
        if let int = BInt(exactly: source) {
            self = int
        } else {
            self.init(0)
        }
    }
    
    public init<T>(clamping source: T) where T : BinaryInteger {
        self.init(source)
    }
    
    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        self.init(source)
    }
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        var isNegative = false
        if source.signum() < 0 {
            isNegative = true
        }
        let words = source.words
        var bwords = Limbs()
        for word in words {
            if isNegative { bwords.append(UInt(~word)) }
            else { bwords.append(UInt(word)) }
        }
        self.init(bwords, false)
        if isNegative { self += 1; self.negate() }
    }
    
    public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        guard source.isFinite else { return nil }
        if source.rounded() != source { return nil }
        if source.isZero { self.init(0); return }
        self.init(source)
    }
    
    public init<T>(_ source: T) where T : BinaryFloatingPoint {
        // FIXME: - Support other types of BinaryFloatingPoint
        if let bint = BInt(Double(source)) {
            self = bint
        } else {
            self.init(0)
        }
    }
}

extension BInt : Numeric {
    public var magnitude: BInt { BInt(words) }
}

extension BInt : BinaryInteger {
    public static func <<= <RHS:BinaryInteger>(lhs: inout BInt, rhs: RHS) {
        lhs = lhs << Int(rhs)
    }
    
    public static func >>= <RHS:BinaryInteger>(lhs: inout BInt, rhs: RHS) {
        lhs = lhs >> Int(rhs)
    }
}

/// Add support for `StaticBigInt` - 24 Jun 2023 - MG
/// Currently disabled due to Swift Playground incompatiblity
/// Uncomment to enable `StaticBigInt` support (i.e., huge integer literals).
//@available(macOS 13.3, *)
//extension BInt : ExpressibleByIntegerLiteral {
//    public init(integerLiteral value: StaticBigInt) {
//        let isNegative = value.signum() < 0
//        let bitWidth = value.bitWidth
//        if bitWidth < Int.bitWidth {
//            self.init(Int(bitPattern: value[0]))
//        } else {
//            precondition(value[0].bitWidth == 64, "Requires 64-bit Ints!")
//            let noOfWords = (bitWidth / 64) + 1 // must be 64-bit system
//            var words = Limbs()
//            for index in 0..<noOfWords {
//                // StaticBigInt words are 2's complement so negative
//                // values needed to be inverted and have one added
//                if isNegative { words.append(UInt64(~value[index])) }
//                else { words.append(UInt64(value[index])) }
//            }
//            self.init(words, false)
//            if isNegative { self += 1; self.negate() }
//        }
//    }
//}
