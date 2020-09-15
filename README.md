<h2><b>Description</b></h2>

The BigInt package provides arbitrary-precision integer arithmetic in Swift.
Its functionality is comparable to that of the Java BigInteger class. It falls in the following categories:
<ul>
<li>Arithmetic: add, subtract, multiply, divide and remainder</li>
<li>Comparison: the six standard operators == != < <= > >=</li>
<li>Shifting: logical left shift and rigth shift</li>
<li>Logical: bitwise and, or, xor, and not</li>
<li>Modulo: normal modulus, inverse modulus, and modular exponentiation</li>
<li>Conversion: to string, to magnitude byte array, and to 2's complement byte array</li>
<li>Primes: prime number testing and probable prime number generation</li>
<li>Miscellaneous: random number generation, greatest common divisor, n-th root, square root modulo an odd prime, and Jacobi symbol</li>
</ul>

BigInt requires Swift 5.0.

<h2><b>Usage</b></h2>
In your projects Package.swift file add a dependency like<br/>

	  dependencies: [
	  .package(url: "https://github.com/leif-ibsen/BigInt", from: "1.2.1"),
	  ]

<h2><b>Examples</b></h2>
<h3><b>Creating BInt's</b></h3>

	  // From an integer
	  let a = BInt(27)
	  
	  // From string literals
	  let b = BInt("123456789012345678901234567890")!
	  let c = BInt("1234567890abcdef1234567890abcdef", radix: 16)!
	  
	  // From magnitude and sign
	  let m: Limbs = [1, 2, 3]
	  let d = BInt(m) // d = 1020847100762815390427017310442723737601
	  let e = BInt(m, true) // e = -1020847100762815390427017310442723737601
	  
	  // From a big-endian 2's complement byte array
	  let f = BInt(signed: [255, 255, 127]) // f = -129
	  
	  // From a big-endian magnitude byte array
	  let g = BInt(magnitude: [255, 255, 127]) // g = 16777087
	  
	  // Random value with specified bitwidth
	  let h = BInt(bitWidth: 43) // For example h = 3965245974702 (=0b111001101100111011000100111110100010101110)
	  
	  // Random value less than a given value
	  let i = h.randomLessThan() // For example i = 583464003284
	  

<h3><b>Converting BInt's</b></h3>

	  let x = BInt(16777087)
	  
	  // To strings
	  let s1 = x.asString() // s1 = "16777087"
	  let s2 = x.asString(radix: 16) // s2 = "ffff7f"
	  
	  // To big-endian magnitude byte array
	  let b1 = x.asMagnitudeBytes() // b1 = [255, 255, 127]
	  
	  // To big-endian 2's complement byte array
	  let b2 = x.asSignedBytes() // b2 = [0, 255, 255, 127]
	  

<h2><b>Performance</b></h2>

To assess the performance of BigInt, the execution times for a number of common operations were measured on a MacBook Pro 2018, 2,2 GHz 6-Core Intel Core i7.
Each execution time was then compared to the execution time for the same operation in Java using the BigInteger class.
The results are in the table below. It shows the operation being measured and the time it took in Swift and in Java (in microseconds or milliseconds).

Based on these measurements it seems that Java BigInteger is roughly 2-5 times faster than Swift BigInt.

Four large numbers 'a1000', 'b1000', 'c2000' and 'p1000' were used throughout the measurements. Their actual values are shown under the table.

<table width="90%">
<tr><th width="35%" align="left">Operation</th><th width="35%" align="right">Swift code</th><th width="15%" align="right">Swift time</th><th width="15%" align="right">Java time</th></tr>
<tr><td>As string</td><td align="right">c2000.asString()</td><td align="right">89 uSec</td><td align="right">59 uSec</td></tr>
<tr><td>As magnitude bytes</td><td align="right">c2000.asMagnitudeBytes()</td><td align="right">0.42 uSec</td><td align="right">0.45 uSec</td></tr>
<tr><td>Bitwise and</td><td align="right">a1000 & b1000</td><td align="right">0.48 uSec</td><td align="right">0.065 uSec</td></tr>
<tr><td>Bitwise or</td><td align="right">a1000 | b1000</td><td align="right">0.46 uSec</td><td align="right">0.066 uSec</td></tr>
<tr><td>Bitwise xor</td><td align="right">a1000 ^ b1000</td><td align="right">0.47 uSec</td><td align="right">0.088 uSec</td></tr>
<tr><td>Bitwise not</td><td align="right">~c2000</td><td align="right">0.22 uSec</td><td align="right">0.14 uSec</td></tr>
<tr><td>Test bit</td><td align="right">c2000.testBit(701)</td><td align="right">0.0010 uSec</td><td align="right">0.0040 uSec</td></tr>
<tr><td>Flip bit</td><td align="right">c2000.flipBit(701)</td><td align="right">0.0055 uSec</td><td align="right">0.12 uSec</td></tr>
<tr><td>Set bit</td><td align="right">c2000.setBit(701)</td><td align="right">0.0046 uSec</td><td align="right">0.099 uSec</td></tr>
<tr><td>Clear bit</td><td align="right">c2000.clearBit(701)</td><td align="right">0.0043 uSec</td><td align="right">0.092 uSec</td></tr>
<tr><td>Addition</td><td align="right">a1000 + b1000</td><td align="right">0.19 uSec</td><td align="right">0.051 uSec</td></tr>
<tr><td>Subtraction</td><td align="right">a1000 - b1000</td><td align="right">0.26 uSec</td><td align="right">0.077 uSec</td></tr>
<tr><td>Multiplication</td><td align="right">a1000 * b1000</td><td align="right">0.64 uSec</td><td align="right">0.37 uSec</td></tr>
<tr><td>Division</td><td align="right">c2000 / a1000</td><td align="right">8.1 uSec</td><td align="right">2.7 uSec</td></tr>
<tr><td>Modulus</td><td align="right">c2000.mod(a1000)</td><td align="right">8.1 uSec</td><td align="right">2.7 uSec</td></tr>
<tr><td>Inverse modulus</td><td align="right">c2000.modInverse(p1000)</td><td align="right">1.8 mSec</td><td align="right">0.25 mSec</td></tr>
<tr><td>Modular exponentiation</td><td align="right">a1000.expMod(b1000, c2000)</td><td align="right">5.9 mSec</td><td align="right">2.0 mSec</td></tr>
<tr><td>Equal</td><td align="right">c2000 + 1 == c2000</td><td align="right">0.0016 uSec</td><td align="right">0.027 uSec</td></tr>
<tr><td>Less than</td><td align="right">b1000 + 1 < b1000</td><td align="right">0.020 uSec</td><td align="right">0.016 uSec</td></tr>
<tr><td>Shift 1 left</td><td align="right">c2000 <<= 1</td><td align="right">0.22 uSec</td><td align="right">0.076 uSec</td></tr>
<tr><td>Shift 1 right</td><td align="right">c2000 >>= 1</td><td align="right">0.22 uSec</td><td align="right">0.082 uSec</td></tr>
<tr><td>Shift 100 left</td><td align="right">c2000 <<= 100</td><td align="right">0.42 uSec</td><td align="right">0.063 uSec</td></tr>
<tr><td>Shift 100 right</td><td align="right">c2000 >>= 100</td><td align="right">0.26 uSec</td><td align="right">0.067 uSec</td></tr>
<tr><td>Is probably prime</td><td align="right">p1000.isProbablyPrime()</td><td align="right">11 mSec</td><td align="right">10 mSec</td></tr>
<tr><td>Make probable 1000 bit prime</td><td align="right">BInt.probablePrime(1000)</td><td align="right">100 mSec</td><td align="right">42 mSec</td></tr>
<tr><td>Greatest common divisor</td><td align="right">a1000.gcd(b1000)</td><td align="right">0.26 mSec</td><td align="right">0.066 mSec</td></tr>
<tr><td>Make random number</td><td align="right">c2000.randomLessThan()</td><td align="right">9.4 uSec</td><td align="right">0.97 uSec</td></tr>
<tr><td>Square root modulo</td><td align="right">b1000.sqrtMod(p1000)</td><td align="right">4.5 mSec</td><td align="right">n.a.</td></tr>
</table>

a1000 = 3187705437890850041662973758105262878153514794996698172406519277876060364087986868049465132757493318066301987043192958841748826350731448419937544810921786918975580180410200630645469411588934094075222404396990984350815153163569041641732160380739556436955287671287935796642478260435292021117614349253825</br>
b1000 = 9159373012373110951130589007821321098436345855865428979299172149373720601254669552044211236974571462005332583657082428026625366060511329189733296464187785766230514564038057370938741745651937465362625449921195096442684523511715110908407508139315000469851121118117438147266381183636498494901233452870695</br>
c2000 = 1190583332681083129323588684910845359379915367459759242106618067261956856381281184752008892106576666833853411939711280970145570546868549934865719229538926506588929417873149597614787608112658086250354719939407543740242931571462165384138560315454455247539461818779966171917173966217706187439870264672508450210272481951994459523586160979759782950984370978171111340529321052541588344733968902238813379990628157732181128074253104347868153860527298911917508606081710893794973605227829729403843750412766366804402629686458092685235454222856584200220355212623917637542398554907364450159627359316156463617143173</br>
p1000 (probably a prime) = 7662841304438384296568220077355872003841475576593385710590818274399706072141018649398767137142090308734613594718593893634649122767374115742644499040193270857876678047220373151142747088797516044505739487695946446362769947024029728822155570722524629197074319602110260674029276185098937139753025851896997</br>


<h2><b>References</b></h2>

Algorithms from the following books have been used in the implementation.
There are references in the source code where appropriate.

<ul>
<li>[CRANDALL] - Crandall and Pomerance: Prime Numbers - A Computational Perspective. Second Edition, Springer 2005</li>
<li>[HANDBOOK] - Menezes, Oorschot, Vanstone: Handbook of Applied Cryptography. CRC Press 1996</li>
<li>[KNUTH] - Donald E. Knuth: Seminumerical Algorithms. Addison-Wesley 1971</li>
<li>[WARREN] - Henry S. Warren, Jr: Hacker's Delight. Second Edition, Addison-Wesley 2013</li>
</ul>


<h2><b>Acknowledgement</b></h2>

The BitSieve class used in the implementation is a translation to Swift of the corresponding class from Java BigInteger.
The GCD algorithm and the Karatsuba and ToomCook multiplication algorithms are modelled after the corresponding algorithms in Java BigInteger.
