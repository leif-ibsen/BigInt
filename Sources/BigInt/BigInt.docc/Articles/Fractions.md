# Fractions

## 
Fractions are represented as BFraction values consisting of a numerator BInt value and a denominator BInt value. The representation is normalized:
* The numerator and denominator have no common factors except 1
* The denominator is always positive
* Zero is represented as 0/1

### Creating BFraction's
Fractions are created by
* Specifying the numerator and denominator explicitly f.ex. BFraction(17, 4)
* Specifying the decimal value explictly f.ex. BFraction(4.25)
* Using a string representation f.ex. BFraction("4.25")! or equivalently BFraction("425E-2")!
* Specifying a continued fraction like BFraction([3, 4, 12, 4]) equivalent to 649 / 200

Defining a fraction by giving its decimal value (like 4.25) might lead to surprises,
because not all decimal values can be represented exactly as a floating point number.
For example, one might think that BFraction(0.1) would equal 1/10,
but in fact it equals 3602879701896397 / 36028797018963968 = 0.1000000000000000055511151231257827021181583404541015625

### Converting BFraction's
BFraction values can be converted to String values, to decimal String values, to Double values and to Continued Fraction values.
```swift
let x = BFraction(1000, 7)

// To String
let s1 = x.asString() // s1 = "1000 / 7"

// To decimal String
let s1 = x.asDecimalString(precision: 8, exponential: false) // s1 = "142.85714"
let s2 = x.asDecimalString(precision: 8, exponential: true) // s2 = "1.4285714E+2"

// To Double
let d = x.asDouble() // d = 142.8571428571429

// To Continued Fraction
let f = x.asContinuedFraction() // f = [BInt(142), BInt(1), BInt(6)]
```

### Operations
The operations available to fractions are:
* Arithmetic
  + addition
  + subtraction
  + multiplication
  + division
  + modulo an integer
  + exponentiation
* Rounding to an integer
  + round - to nearest integer
  + truncate - towards 0
  + ceil - towards +infinity
  + floor - towards -infinity
* Comparison - the six standard operations == != < <= > >=

### Bernoulli Numbers
The static function
```swift
let bn = BFraction.bernoulli(n)
```
computes the n'th (n >= 0) Bernoulli number, which is a rational number.

For example
```swift
print(BFraction.bernoulli(60))
print(BFraction.bernoulli(60).asDecimalString(precision: 20, exponential: true))
```
would print<br/>
```swift
-1215233140483755572040304994079820246041491 / 56786730
-2.1399949257225333665E+34
```
The static function
```swift
let x = BFraction.bernoulliSequence(n)
```
computes the n even numbered Bernoulli numbers B(0), B(2) ... B(2 * n - 2).

### Harmonic Numbers

The static function
```swift
let Hn = BFraction.harmonic(n)
```
computes the n'th harmonic number, that is, 1 + 1/2 + ... + 1/n

The static function
```swift    
let x = BFraction.harmonicSequence(n)
```
returns an array containing the first n harmonic numbers.
