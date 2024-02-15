# Chinese Remainder Theorem

## 

The ``BigInt/CRT`` structure implements the Chinese Remainder Theorem. Construct a CRT instance from a given set of moduli,
and then use the `compute` method to compute the CRT value for a given set of residues. The same instance can be reused
for any set of input data, as long as the moduli are the same.
This is relevant because it takes longer time to create the CRT instance than to compute the CRT value.

### Example

```swift
let moduli = [3, 5, 7]
let residues = [2, 2, 6]
let crt = CRT(moduli)!
print("CRT value:", crt.compute(residues))
```

giving:

```swift
CRT value: 62
```
