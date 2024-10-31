# Performance

Execution times for certain BigInt operations

## 

To assess the performance of BigInt, the execution times for a number of common operations were measured on an iMac 2021, Apple M1 chip.
The results are shown in the table below. It shows the operation being measured and the time it took (in microseconds or milliseconds).

> Note:
Four large numbers `a1000`, `b1000`, `c2000` and `p1000` were used throughout the measurements. Their actual values are shown below the table.

| Operation | Swift code | Time |
|:----------|:-----------|-----:|
| As string | `c2000.asString()` | 11 uSec |
| As signed bytes | `c2000.asSignedBytes()` | 0.24 uSec |
| Bitwise and | `a1000 & b1000` | 0.065 uSec |
| Bitwise or | `a1000 \| b1000` | 0.065 uSec |
| Bitwise xor | `a1000 ^ b1000` | 0.065 uSec |
| Bitwise not | `~c2000` | 0.092 uSec |
| Test bit | `c2000.testBit(701)` | 0.017 uSec |
| Flip bit | `c2000.flipBit(701)` | 0.018 uSec |
| Set bit | `c2000.setBit(701)` | 0.018 uSec |
| Clear bit | `c2000.clearBit(701)` | 0.018 uSec |
| Addition | `a1000 + b1000` | 0.07 uSec |
| Subtraction | `a1000 - b1000` | 0.08 uSec |
| Multiplication | `a1000 * b1000` | 0.32 uSec |
| Division | `c2000 / a1000` | 2.2 uSec |
| Modulus | `c2000.mod(a1000)` | 2.2 uSec |
| Inverse modulus | `c2000.modInverse(p1000)` | 83 uSec |
| Modular exponentiation | `a1000.expMod(b1000, c2000)` | 3.5 mSec |
| Equal | `c2000 + 1 == c2000` | 0.017 uSec |
| Less than | `b1000 + 1 < b1000` | 0.021 uSec |
| Shift 1 left | `c2000 <<= 1` | 0.05 uSec |
| Shift 1 right | `c2000 >>= 1` | 0.06 uSec |
| Shift 100 left | `c2000 <<= 100` | 0.14 uSec |
| Shift 100 right | `c2000 >>= 100` | 0.11 uSec |
| Is probably prime | `p1000.isProbablyPrime()` | 5.8 mSec |
| Make probable 1000 bit prime | `BInt.probablePrime(1000)` | 60 mSec |
| Next probable prime | `c2000.nextPrime()` | 730 mSec |
| Primorial | `BInt.primorial(100000)` | 3.2 mSec |
| Binomial | `BInt.binomial(100000, 10000)` | 22 mSec |
| Factorial | `BInt.factorial(100000)` | 57 mSec |
| Fibonacci | `BInt.fibonacci(100000)` | 22 mSec |
| Greatest common divisor | `a1000.gcd(b1000)` | 29 uSec |
| Extended gcd | `a1000.gcdExtended(b1000)` | 81 uSec |
| Least common multiple | `a1000.lcm(b1000)` | 32 uSec |
| Make random number | `c2000.randomLessThan()` | 1.2 uSec |
| Square | `c2000 ** 2` | 0.68 uSec |
| Square root | `c2000.sqrt()` | 13 uSec |
| Square root and remainder | `c2000.sqrtRemainder()` | 13 uSec |
| Is perfect square | `(c2000 * c2000).isPerfectSquare()` | 16 uSec |
| Square root modulo | `b1000.sqrtMod(p1000)` | 1.6 mSec |
| Power | `c2000 ** 111` | 1.9 mSec |
| Root | `c2000.root(111)` | 15 uSec |
| Root and remainder | `c2000.rootRemainder(111)` | 17 uSec |
| Is perfect root | `c2000.isPerfectRoot()` | 13 mSec |
| Jacobi symbol | `c2000.jacobiSymbol(p1000)` | 0.15 mSec |
| Kronecker symbol | `c2000.kroneckerSymbol(p1000)` | 0.15 mSec |
| Bernoulli number | `BFraction.bernoulli(1000)` | 83 mSec |

a1000 = 3187705437890850041662973758105262878153514794996698172406519277876060364087986868049465132757493318066301987043192958841748826350731448419937544810921786918975580180410200630645469411588934094075222404396990984350815153163569041641732160380739556436955287671287935796642478260435292021117614349253825

b1000 = 9159373012373110951130589007821321098436345855865428979299172149373720601254669552044211236974571462005332583657082428026625366060511329189733296464187785766230514564038057370938741745651937465362625449921195096442684523511715110908407508139315000469851121118117438147266381183636498494901233452870695

c2000 = 1190583332681083129323588684910845359379915367459759242106618067261956856381281184752008892106576666833853411939711280970145570546868549934865719229538926506588929417873149597614787608112658086250354719939407543740242931571462165384138560315454455247539461818779966171917173966217706187439870264672508450210272481951994459523586160979759782950984370978171111340529321052541588344733968902238813379990628157732181128074253104347868153860527298911917508606081710893794973605227829729403843750412766366804402629686458092685235454222856584200220355212623917637542398554907364450159627359316156463617143173

p1000 (probably a prime) = 7662841304438384296568220077355872003841475576593385710590818274399706072141018649398767137142090308734613594718593893634649122767374115742644499040193270857876678047220373151142747088797516044505739487695946446362769947024029728822155570722524629197074319602110260674029276185098937139753025851896997
