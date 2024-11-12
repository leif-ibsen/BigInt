# Algorithms

Some of the algorithms used in BigInt are described below

## 

### Multiplication
* Schonhage-Strassen FFT based algorithm for numbers with more than 384.000 bits
* ToomCook-3 algorithm for numbers with more than 12.800 bits
* Karatsuba algorithm for numbers with more than 6.400 bits
* Basecase - Knuth algorithm M

### Division and Remainder
* Burnikel-Ziegler algorithm for divisors with more than 3.840 bits provided the dividend has at least 3.840 bits more than the divisor
* Basecase - Knuth algorithm D
* Exact Division - Jebelean's exact division algorithm

### Greatest Common Divisor
* Recursive GCD algorithm 9.4.6 from [CRANDALL] for numbers with more than 128.000 bits
* Lehmer's algorithm [KNUTH] chapter 4.5.2 for smaller numbers, with binary GCD basecase

### Extended Greatest Common Divisor
* Recursive GCD algorithm 9.4.6 from [CRANDALL] for numbers with more than 64.000 bits, with extra logic to track cofactors
* Lehmer's algorithm [KNUTH] chapter 4.5.2 and exercise 18 for smaller numbers

### Modular Exponentiation
Sliding window algorithm 14.85 from [HANDBOOK] using Barrett reduction algorithm 14.42

### Inverse Modulus
If the modulus is a (not too large) power of 2, the algorithm from [KOC] section 7,
else it is computed via the extended GCD algorithm

### Square Root
Algorithm 1.12 (SqrtRem) from [BRENT] with algorithm 9.2.11 from [CRANDALL] as basecase

### Square Root Modulo a Prime Number
Algorithm 2.3.8 from [CRANDALL]

### Random Numbers
Random `BInt` numbers are generated using the cryptographically secure function `SecRandomCopyBytes`

### Prime Number Test
Miller-Rabin test

### Prime Number Generation
The algorithm from Java BigInteger translated to Swift

### Factorial
The `SplitRecursive` algorithm from Peter Luschny: [https://www.luschny.de](https://www.luschny.de)

### Fibonacci
The `fastDoubling` algorithm from Project Nayuki: [https://www.nayuki.io](https://www.nayuki.io)

### Jacobi and Kronecker symbols
Algorithm 2.3.5 from [CRANDALL]

### Bernoulli Numbers
Computed via Tangent numbers which is fast because it only involves integer arithmetic
but no fraction arithmetic

### Chinese Remainder Theorem
The Garner algorithm 2.1.7 from [CRANDALL]
