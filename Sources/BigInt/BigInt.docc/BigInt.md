# ``BigInt``

Signed integers and fractions of unbounded size

## 

> Important:
**Please note:** Due to a bug in GitHub Pages,
> clicking on certain `BInt` and `BFraction` operators in GitHub Pages (f.ex. < and | ) will show the message
>
>    The page you're looking for can't be found.
>   
> The *BigInt.doccarchive* file contains the correct documentation.
> It is emphasized that it is only the documentation that's in error.
> The operators themselves work correctly.

## Overview

The BigInt package provides arbitrary-precision integer and fraction arithmetic in Swift:

* **Integer arithmetic and functions**

    Please, see <doc:AboutBInt>

* **Fraction arithmetic and functions**

    Please, see <doc:AboutBFraction>

* **Chinese Remainder Theorem**

    Please, see <doc:AboutCRT>

### Usage

To use BigInt, in your project Package.swift file add a dependency like

```swift
dependencies: [
  package(url: "https://github.com/leif-ibsen/BigInt", from: "1.20.0"),
]
```

BigInt itself does not depend on other packages.

> Important:
BigInt requires Swift 5.0. It also requires that the `Int` and `UInt` types be 64 bit types.

## Topics

### Structures

- ``BigInt/BInt``
- ``BigInt/BFraction``
- ``BigInt/CRT``

### Type Aliases

- ``BigInt/Byte``
- ``BigInt/Bytes``
- ``BigInt/Limb``
- ``BigInt/Limbs``

### Articles

- <doc:AboutBInt>
- <doc:AboutBFraction>
- <doc:AboutCRT>
- <doc:Performance>
- <doc:References>
- <doc:Algorithms>
