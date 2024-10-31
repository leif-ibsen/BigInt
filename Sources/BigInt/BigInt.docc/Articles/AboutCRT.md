# About CRT

Chinese Remainder Theorem

## Overview

Create a ``CRT`` instance from a given set of moduli which fullfill the following conditions:

* at least two moduli
* all moduli are positive
* the moduli are pairwise coprime

Then use the `compute` method to compute the CRT value for a given set of residues.

The same CRT instance can be used for different inputs, as long as the moduli are the same.

### Example

```swift
let moduli = [3, 5, 7]
let crt = CRT(moduli)!

let residues = [2, 2, 6]
print("CRT value:", crt.compute(residues))
```

giving:

```swift
CRT value: 62
```

