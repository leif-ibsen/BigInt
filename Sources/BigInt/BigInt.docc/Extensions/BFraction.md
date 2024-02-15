# ``BigInt/BFraction``

## Overview

A signed fraction with numerator and denominator of unbounded size.

A BFraction value is represented by a ``BigInt/BInt`` numerator and a ``BigInt/BInt`` denominator.  
The representation is normalized:

* The numerator and denominator have no common divisors except 1
* The denominator is always positive
* Zero is represented as 0/1

## Topics

### Constants

- ``ZERO``
- ``ONE``

### Properties

- ``abs``
- ``denominator``
- ``description``
- ``isInteger``
- ``isNegative``
- ``isPositive``
- ``isZero``
- ``numerator``
- ``signum``

### Constructors

- ``init(_:_:)-7sb75``
- ``init(_:_:)-7j7w1``
- ``init(_:_:)-1eivz``
- ``init(_:_:)-q5rn``
- ``init(_:)-7fk0z``
- ``init(_:)-8d7x``
- ``init(_:)-1nf7w``
- ``init(_:)-3gknk``

### Conversion

- ``asString()``
- ``asDecimalString(precision:exponential:)``
- ``asDouble()``
- ``asContinuedFraction()``

### Addition

- ``+(_:)``
- ``+(_:_:)-8h9j5``
- ``+(_:_:)-2s0hx``
- ``+(_:_:)-2ifyp``
- ``+(_:_:)-6y32m``
- ``+(_:_:)-2jkh4``
- ``+=(_:_:)-91tnu``
- ``+=(_:_:)-4dmlm``
- ``+=(_:_:)-8z5h1``

### Subtraction

- ``-(_:_:)-7wxxx``
- ``-(_:_:)-6t2so``
- ``-(_:_:)-1789v``
- ``-(_:_:)-7ge79``
- ``-(_:_:)-3751b``
- ``-=(_:_:)-8nvxh``
- ``-=(_:_:)-11vza``
- ``-=(_:_:)-6s118``

### Negation

- ``-(_:)``
- ``negate()``

### Multiplication

- ``*(_:_:)-42r5a``
- ``*(_:_:)-1m8z9``
- ``*(_:_:)-5fsb0``
- ``*(_:_:)-97qba``
- ``*(_:_:)-9pekq``
- ``*=(_:_:)-1b305``
- ``*=(_:_:)-7engg``
- ``*=(_:_:)-9rhyz``

### Division

- ``/(_:_:)-3syd2``
- ``/(_:_:)-36e09``
- ``/(_:_:)-f4k1``
- ``/(_:_:)-nbpu``
- ``/(_:_:)-6s4x9``
- ``/=(_:_:)-5kwdi``
- ``/=(_:_:)-9882z``
- ``/=(_:_:)-an0e``
- ``invert()``

### Exponentiation

- ``**(_:_:)``

### Modulus

- ``mod(_:)-2n1yz``
- ``mod(_:)-3uydm``

### Comparison

- ``==(_:_:)-76frx``
- ``==(_:_:)-5uozb``
- ``==(_:_:)-57efs``
- ``==(_:_:)-8pm8k``
- ``==(_:_:)-iccd``
- ``!=(_:_:)-21ytn``
- ``!=(_:_:)-6d0go``
- ``!=(_:_:)-1yd5f``
- ``!=(_:_:)-7obdp``
- ``!=(_:_:)-25fz4``
- ``<(_:_:)-61olb``
- ``<(_:_:)-co3``
- ``<(_:_:)-4hmme``
- ``<(_:_:)-64cso``
- ``<(_:_:)-4tyit``
- ``>(_:_:)-v3rz``
- ``>(_:_:)-79llm``
- ``>(_:_:)-4lokn``
- ``>(_:_:)-8yu93``
- ``>(_:_:)-9xtvu``
- ``<=(_:_:)-65hym``
- ``<=(_:_:)-8xefd``
- ``<=(_:_:)-7mj6q``
- ``<=(_:_:)-44c69``
- ``<=(_:_:)-5zk4n``
- ``>=(_:_:)-6uyhl``
- ``>=(_:_:)-v34i``
- ``>=(_:_:)-9fdw7``
- ``>=(_:_:)-24s7g``
- ``>=(_:_:)-4xk0g``

### Rounding

- ``round()``
- ``truncate()``
- ``ceil()``
- ``floor()``

### Miscellaneous

- ``bernoulli(_:)``
- ``bernoulliSequence(_:)``
- ``harmonic(_:)``
- ``harmonicSequence(_:)``

