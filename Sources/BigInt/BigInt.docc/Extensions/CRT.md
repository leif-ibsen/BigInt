# ``BigInt/CRT``

## Overview

CRT instances implement the Chinese Remainder Theorem.

Create an instance from a given set of moduli which fullfill the following conditions:

* at least two moduli
* all moduli are positive
* the moduli are pairwise coprime

Then use the `compute` method to compute the CRT value for a given set of residues.

The same CRT instance can be used for different inputs, as long as the moduli are the same.

## Topics

### Constructors

- ``init(_:)-2467``
- ``init(_:)-6ke5h``

### Methods

- ``compute(_:)-9xjvk``
- ``compute(_:)-5qe04``
