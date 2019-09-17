<h3><b>Description</b></h3>

The BigInt package provides arbitrary-precision integer arithmetic in Swift.
It contains functionality comparable to that of the Java BigInteger class.

BigInt requires Swift 5.0.


<h3><b>Usage</b></h3>
Using Swift Package Manager, in your projects Package.swift file add a dependency like<br>
```
dependencies: [
// Dependencies declare other packages that this package depends on.
.package(url: "https://github.com/leif-ibsen/BigInt", from: "1.0.0"),
],
```

<h3><b>References</b></h3>

Algorithms from the following books have been used in the implementation.
There are references in the source code where appropriate.

<ul>
<li>Donald E. Knuth: Seminumerical Algorithms. Addison-Wesley 1971</li>
<li>Crandall and Pomerance: Prime Numbers - A Computational Perspective. Second Edition, Springer 2005</li>
<li>Henry S. Warren, Jr: Hacker's Delight. Second Edition, Addison-Wesley 2013</li>
<li>Menezes, Oorschot, Vanstone: Handbook of Applied Cryptography. CRC Press 1996</li>
</ul>


<h3><b>Acknowledgement</b></h3>

The BitSieve class used in the implementation is a translation to Swift of the corresponding class from Java BigInteger.
The GCD algorithm and the Karatsuba and ToomCook multiplication algorithms are modelled after the corresponding algorithms in Java BigInteger.

