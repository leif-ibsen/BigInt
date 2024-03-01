# Algorithms

Some of the algorithms used in BigInt are described below

## 

### Multiplication
* Schonhage-Strassen FFT based algorithm for numbers above 384000 bits
* ToomCook-3 algorithm for numbers above 12800 bits
* Karatsuba algorithm for numbers above 6400 bits
* Basecase - Knuth algorithm M

### Division and Remainder
* Burnikel-Ziegler algorithm for divisors above 3840 bits provided the dividend has at least 3840 bits more than the divisor
* Basecase - Knuth algorithm D
* Exact Division - Jebelean's exact division algorithm

### Greatest Common Divisor and Extended Greatest Common Divisor
Lehmer's algorithm [KNUTH] chapter 4.5.2, with binary GCD basecase.

### Modular Exponentiation
Sliding window algorithm 14.85 from [HANDBOOK] using Barrett reduction for exponents with fewer than 2048 bits
and Montgomery reduction for larger exponents.

### Inverse Modulus
If the modulus is a (not too large) power of 2, the algorithm from [KOC] section 7.
Else, it is computed via the extended GCD algorithm.

### Square Root
Algorithm 1.12 (SqrtRem) from [BRENT] with algorithm 9.2.11 from [CRANDALL] as basecase.

### Square Root Modulo a Prime Number
Algorithm 2.3.8 from [CRANDALL].

### Prime Number Test
Miller-Rabin test.

### Prime Number Generation
The algorithm from Java BigInteger translated to Swift.

### Factorial
The `SplitRecursive` algorithm from Peter Luschny: [https://www.luschny.de](https://www.luschny.de)

### Fibonacci
The `fastDoubling` algorithm from Project Nayuki: [https://www.nayuki.io](https://www.nayuki.io)

### Jacobi and Kronecker symbols
Algorithm 2.3.5 from [CRANDALL].

### Bernoulli Numbers
Computed via Tangent numbers which is fast because it only involves integer arithmetic
but no fraction arithmetic.

### Chinese Remainder Theorem
The Garner algorithm 2.1.7 from [CRANDALL].
