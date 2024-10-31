# About BInt

Signed integers of unbounded size

## Overview

``BInt`` values are represented with magnitude and sign:

* The magnitude is an array of unsigned 64 bit integers (a.k.a. Limbs)
* The sign is a boolean value, `true` means value < 0, `false` means value >= 0
* The representation is little-endian, least significant Limb has index 0
* The representation is minimal, there is no leading zero Limbs. The exception is that the value 0 is represented as a single 64 bit zero Limb and sign `false`

### Creating BInt's

```swift
// From an integer
let a = BInt(27)

// From a decimal value
let x = BInt(1.12345e30) // x = 1123450000000000064996914495488

// From string literals
let b = BInt("123456789012345678901234567890")!
let c = BInt("1234567890abcdef1234567890abcdef", radix: 16)!

// From magnitude and sign
let m: Limbs = [1, 2, 3]
let d = BInt(m) // d = 1020847100762815390427017310442723737601
let e = BInt(m, true) // e = -1020847100762815390427017310442723737601

// From a big-endian 2's complement byte array
let f = BInt(signed: [255, 255, 127]) // f = -129

// From a big-endian magnitude byte array
let g = BInt(magnitude: [255, 255, 127]) // g = 16777087

// Random value with specified bitwidth
let h = BInt(bitWidth: 43) // For example h = 3965245974702 (=0b111001101100111011000100111110100010101110)

// Random value less than a given value
let i = h.randomLessThan() // For example i = 583464003284
```

### Converting BInt's

```swift
let x = BInt(16777087)

// To double
let d = x.asDouble() // d = 16777087.0

// To strings
let s1 = x.asString() // s1 = "16777087"
let s2 = x.asString(radix: 16) // s2 = "ffff7f"

// To big-endian magnitude byte array
let b1 = x.asMagnitudeBytes() // b1 = [255, 255, 127]

// To big-endian 2's complement byte array
let b2 = x.asSignedBytes() // b2 = [0, 255, 255, 127]
```

### Operations

The operations available to ``BInt`` are:

* **Arithmetic:** addition, subtraction, multiplication, division, exponentiation, remainder and modulus, gcd and lcm
* **Comparison:** the six standard operations ==  !=  <  <=  >  >=
* **Shift Operations:** logical left- and right shifts
* **Bit Operations:** logical and, or, xor, not, bit manipulation
* **Root Extraction:** sqrt, sqrtMod, sqrtRemainder, isPerfectSquare, root, rootRemainder, isPerfectRoot
* **Prime Number:** probablePrime, nextPrime, isProbablyPrime, primorial
* **Miscellaneous:** randomLessThan, binomial, factorial, fibonacci, jacobiSymbol, kroneckerSymbol, lucas
