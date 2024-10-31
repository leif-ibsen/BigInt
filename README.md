## BigInt

The BigInt package provides arbitrary-precision integer arithmetic in Swift.
Its functionality falls in the following categories:

* **Arithmetic:** addition, subtraction, multiplication, division, exponentiation, remainder and modulus, gcd and lcm
* **Comparison:** the six standard operations == != < <= > >=
* **Shifting:** logical left shift and rigth shift
* **Logical:** bitwise and, or, xor, and not
* **Modulo:** normal modulus, inverse modulus, and modular exponentiation
* **Conversion:** to double, to integer, to string, to magnitude byte array, and to 2's complement byte array
* **Primes:** prime number testing, probable prime number generation and primorial
* **Miscellaneous:** random number generation, n-th root, square root modulo an odd prime,
Jacobi symbol, Kronecker symbol, Factorial function, Binomial function, Fibonacci numbers, Lucas numbers and Bernoulli numbers
* **Fractions:** Standard arithmetic on fractions whose numerators and denominators are of unbounded size
* **Chinese Remainder Theorem:** Compute the CRT value from given residues and moduli


BigInt requires Swift 5.0. It also requires that the `Int` and `UInt` types be 64 bit types.

Its documentation is build with the DocC plugin and published on GitHub Pages at this location:

https://leif-ibsen.github.io/BigInt/documentation/bigint

The documentation is also available in the *BigInt.doccarchive* file.

**Please note:** Due to a bug in GitHub Pages, clicking on certain `BInt` and `BFraction` operators (f.ex. < and | ) will show the message

    The page you're looking for can't be found.
    
The *BigInt.doccarchive* file contains the correct documentation.

It is emphasized that it is only the documentation that's in error.
The operators themselves work correctly.
