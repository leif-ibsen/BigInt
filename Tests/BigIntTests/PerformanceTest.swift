//
//  PerformanceTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 17/01/2019.
//

import XCTest
@testable import BigInt

class PerformanceTest: XCTestCase {
    
    let a1000 = BInt(3187705437890850041662973758105262878153514794996698172406519277876060364087986868049465132757493318066301987043192958841748826350731448419937544810921786918975580180410200630645469411588934094075222404396990984350815153163569041641732160380739556436955287671287935796642478260435292021117614349253825)
    let b1000 = BInt(9159373012373110951130589007821321098436345855865428979299172149373720601254669552044211236974571462005332583657082428026625366060511329189733296464187785766230514564038057370938741745651937465362625449921195096442684523511715110908407508139315000469851121118117438147266381183636498494901233452870695)
    let c2000 = BInt(1190583332681083129323588684910845359379915367459759242106618067261956856381281184752008892106576666833853411939711280970145570546868549934865719229538926506588929417873149597614787608112658086250354719939407543740242931571462165384138560315454455247539461818779966171917173966217706187439870264672508450210272481951994459523586160979759782950984370978171111340529321052541588344733968902238813379990628157732181128074253104347868153860527298911917508606081710893794973605227829729403843750412766366804402629686458092685235454222856584200220355212623917637542398554907364450159627359316156463617143173)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testAddition() {
        let N = 100000
        self.measure {
            for _ in 0 ..< N {
                _ = a1000 + b1000
            }
        }
    }

    func testSubtraction() {
        let N = 100000
        self.measure {
            for _ in 0 ..< N {
                _ = a1000 - b1000
            }
        }
    }

    func testMultiplication() {
        let N = 1000
        self.measure {
            for _ in 0 ..< N {
                _ = a1000 * b1000
            }
        }
    }

    func testSquaring() {
        let N = 1000
        self.measure {
            for _ in 0 ..< N {
                _ = a1000 ** 2
            }
        }
    }

    func testSqrt() {
        let N = 1000
        self.measure {
            for _ in 0 ..< N {
                _ = a1000.sqrt()
            }
        }
    }

    func testDivision() {
        let N = 1000
        self.measure {
            for _ in 0 ..< N {
                (_, _) = c2000.quotientAndRemainder(dividingBy: a1000)
            }
        }
    }

    func testGcd() {
        let N = 10
        self.measure {
            for _ in 0 ..< N {
                _ = a1000.gcd(b1000)
            }
        }
    }

    func testLcm() {
        let N = 10
        self.measure {
            for _ in 0 ..< N {
                _ = a1000.lcm(b1000)
            }
        }
    }

    func testExpMod() {
        let N = 10
        self.measure {
            for _ in 0 ..< N {
                _ = a1000.expMod(b1000, c2000)
            }
        }
    }
    
}
