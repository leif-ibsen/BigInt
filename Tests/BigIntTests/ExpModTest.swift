//
//  ExpModTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 04/02/2019.
//

import XCTest
@testable import BigInt

class ExpModTest: XCTestCase {

    let a1 = BInt("43271512091896741409394736939900206368860872098952555939")!
    let x1 = BInt("42267688843543983783885633938053687583065584419295560555")!
    let m1 = BInt("65559338391610243479024015552681806795487318988418855174")!
    let mp1 = BInt("14708028296754883426561209612579760556999800024666797837")!
    
    let a2 = BInt("9879959622001881798420480569351120749752891168795071469741009590796905186183625061410538508653929799901162907503196502223071902180994253404412067954774342232969326053454779870840130810532326017165678692636647404921424922403748460111140358572478743271512091896741409394736939900206368860872098952555939")!
    let x2 = BInt("4149842346989426807721754542711895351513161856205879655378968612408032038996656528445703209766166328006052965811745650295935314936056815509075542554308409615827636639641110901357012471113482422183741588797481891328204616583065067700486989814417842267688843543983783885633938053687583065584419295560555")!
    let m2 = BInt("10524302966485349118258764179820205386685991992586369700154893101599927732040662774460446149003080427232451962311367600902738242964142492968383265627950930467854069828393051189273332522792516344807937835132537814794042705435787095095919023768140765559338391610243479024015552681806795487318988418855174")!
    let mp2 = BInt("1122200972247120546333043544356752277213829455746835691791369400547247327000588079094470008395425401827849174141816902264513461023891163414270218627387835660351885298195540293936217720560009323739879363833688454142584347044964970051959361123182603999640496505409063560777205949747764493609693376510835")!
    
    let a3 = BInt("2988348162058574136915891421498819466320163312926952423791023078876139")!
    let x3 = BInt("2351399303373464486466122544523690094744975233415544072992656881240319")!
    let m3 = BInt("10000000000000000000000000000000000000000")!
    let mp3 = BInt("1527229998585248450016808958343740453059")!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        XCTAssertEqual(BInt(3).expMod(BInt(7), BInt(1)), BInt(0))
        XCTAssertEqual(BInt(2).expMod(BInt(10), BInt(1000)), BInt(24))
    }
    
    func test2() {
        XCTAssertEqual(a1.expMod(x1, m1), mp1)
        XCTAssertEqual(a1.expMod(-x1, m1), mp1.modInverse(m1))
        XCTAssertEqual((-a1).expMod(x1, m1), m1 - mp1)
        XCTAssertEqual((-a1).expMod(-x1, m1), (m1 - mp1).modInverse(m1))
        XCTAssertEqual(a2.expMod(x2, m2), mp2)
        XCTAssertEqual(a2.expMod(-x2, m2), mp2.modInverse(m2))
        XCTAssertEqual((-a2).expMod(x2, m2), m2 - mp2)
        XCTAssertEqual((-a2).expMod(-x2, m2), (m2 - mp2).modInverse(m2))
        XCTAssertEqual(a3.expMod(x3, m3), mp3)
        XCTAssertEqual(a3.expMod(-x3, m3), mp3.modInverse(m3))
        XCTAssertEqual((-a3).expMod(x3, m3), m3 - mp3)
        XCTAssertEqual((-a3).expMod(-x3, m3), (m3 - mp3).modInverse(m3))
    }

    func test3() {
        XCTAssertEqual(BInt(-2).expMod(BInt(0), BInt(11)), BInt(1))
        XCTAssertEqual(BInt(2).expMod(BInt(0), BInt(11)), BInt(1))
        XCTAssertEqual(BInt(1).expMod(BInt(2), BInt(11)), BInt(1))
        XCTAssertEqual(BInt(1).expMod(BInt(-2), BInt(11)), BInt(1))
        XCTAssertEqual(BInt(-2).expMod(BInt(-3), BInt(11)), BInt(4))
        XCTAssertEqual(BInt(-11).expMod(BInt(2), BInt(11)), BInt(0))
        XCTAssertEqual(BInt(2).expMod(BInt(5), BInt(11)), BInt(10))
        XCTAssertEqual(BInt(2).expMod(BInt(-5), BInt(11)), BInt(10))
        XCTAssertEqual(BInt(2).expMod(BInt(4), BInt(11)), BInt(5))
        XCTAssertEqual(BInt(2).expMod(BInt(-4), BInt(11)), BInt(9))
        XCTAssertEqual(BInt(-2).expMod(BInt(5), BInt(11)), BInt(1))
        XCTAssertEqual(BInt(-2).expMod(BInt(-5), BInt(11)), BInt(1))
        XCTAssertEqual(BInt(-2).expMod(BInt(4), BInt(11)), BInt(5))
        XCTAssertEqual(BInt(-2).expMod(BInt(-4), BInt(11)), BInt(9))
        XCTAssertEqual(BInt(0).expMod(BInt(5), BInt(11)), BInt(0))
        XCTAssertEqual(BInt(0).expMod(BInt(4), BInt(11)), BInt(0))
    }
    
    func test4() {
        doTest4(BInt.ONE, BInt.ONE, BInt.ONE)
        doTest4(BInt.ONE, BInt.ONE, BInt.ONE << 1)
        doTest4(a1, x1, m1)
        doTest4(a2, x2, m2)
        doTest4(a3, x3, m3)
        doTest4(a3, x3, m3 << 200)
        doTest4(a3, x3, BInt.ONE << 200)
        doTest4(a1, BInt.ONE << 5000, m1)
        doTest4(a1, BInt.ONE << 5000, m1 + 1)
        doTest4(a3, x3, BInt.ONE)
    }

    func doTest4(_ a: BInt, _ x: BInt, _ m: BInt) {
        let r1 = a.expMod(x, m)
        
        // Split modulus into an odd part and a power of 2 part
        
        let trailing = m.trailingZeroBitCount
        let pow2Modulus = BInt.ONE << trailing
        let oddModulus = m >> trailing
        let a1 = a.expMod(x, oddModulus)
        let a2 = a.expMod(x, pow2Modulus)
        let y1 = pow2Modulus.modInverse(oddModulus)
        let y2 = oddModulus.modInverse(pow2Modulus)
        let r2 = (a1 * pow2Modulus * y1 + a2 * oddModulus * y2).mod(m)
        
        // r1 = r2 by chinese remainder theorem
        
        XCTAssertEqual(r1, r2)
    }
    
    // Barrett reduction must give same result as Montgomery reduction
    func test5() {
        doTest5(a1, x1, mp1)
        doTest5(a2, x2, mp2)
        doTest5(a3, x3, mp3)
    }

    func doTest5(_ a: BInt, _ x: BInt, _ m: BInt) {
        XCTAssertEqual(basicExpMod(a, x, m), BInt.BarrettModulus(a, m).expMod(x))
    }
    
    // Straight forward (slow) expMod
    func basicExpMod(_ a: BInt, _ x: BInt, _ m: BInt) -> BInt {
        var result = BInt.ONE
        var base = a % m
        var exp = x
        while exp.isPositive {
            if exp.isOdd {
                result = (result * base) % m
            }
            exp >>= 1
            base = (base ** 2) % m
        }
        return result
    }
    
    // expMod with Int modulus must give same result as expMod with BInt modulus
    func test6() {
        doTest6(a1, x1, 1)
        doTest6(a1, x1, 2)
        doTest6(a1, x1, Int.max)
        for _ in 0 ..< 1000 {
            let m = Int.random(in: 1 ..< Int.max)
            doTest6(a1, x1, m)
        }
    }

    func doTest6(_ a: BInt, _ x: BInt, _ m: Int) {
        let x1 = a.expMod(x, m)
        let x2 = a.expMod(x, BInt(m))
        XCTAssertEqual(BInt(x1), x2)
        let x3 = (-a).expMod(x, m)
        let x4 = (-a).expMod(x, BInt(m))
        XCTAssertEqual(BInt(x3), x4)
        if x2.gcd(BInt(m)) == 1 {
            let x5 = a.expMod(-x, m)
            let x6 = a.expMod(-x, BInt(m))
            XCTAssertEqual(BInt(x5), x6)
            let x7 = (-a).expMod(-x, m)
            let x8 = (-a).expMod(-x, BInt(m))
            XCTAssertEqual(BInt(x7), x8)
        }
    }

    // To test a bug in Pow2Modulus
    func test7() {
        XCTAssertEqual(a1.expMod(BInt.ONE, BInt.ONE << 63), basicExpMod(a1, BInt.ONE, BInt.ONE << 63))
        XCTAssertEqual(a1.expMod(BInt.ONE, BInt.ONE << 64), basicExpMod(a1, BInt.ONE, BInt.ONE << 64))
        XCTAssertEqual(a1.expMod(BInt.ONE, BInt.ONE << 65), basicExpMod(a1, BInt.ONE, BInt.ONE << 65))
        XCTAssertEqual(a1.expMod(BInt.ONE, BInt.ONE << 127), basicExpMod(a1, BInt.ONE, BInt.ONE << 127))
        XCTAssertEqual(a1.expMod(BInt.ONE, BInt.ONE << 128), basicExpMod(a1, BInt.ONE, BInt.ONE << 128))
        XCTAssertEqual(a1.expMod(BInt.ONE, BInt.ONE << 129), basicExpMod(a1, BInt.ONE, BInt.ONE << 129))
        XCTAssertEqual(a1.expMod(BInt.ONE, BInt.ONE << 191), basicExpMod(a1, BInt.ONE, BInt.ONE << 191))
        XCTAssertEqual(a1.expMod(BInt.ONE, BInt.ONE << 192), basicExpMod(a1, BInt.ONE, BInt.ONE << 192))
        XCTAssertEqual(a1.expMod(BInt.ONE, BInt.ONE << 193), basicExpMod(a1, BInt.ONE, BInt.ONE << 193))
    }
}
