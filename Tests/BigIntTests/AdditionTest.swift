//
//  AdditionTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 17/01/2019.
//

import XCTest

class AdditionTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        XCTAssertEqual(BInt(7) + BInt(4), BInt(11))
        XCTAssertEqual(BInt(7) + BInt(-4), BInt(3))
        XCTAssertEqual(BInt(-7) + BInt(4), BInt(-3))
        XCTAssertEqual(BInt(-7) + BInt(-4), BInt(-11))
        XCTAssertEqual(BInt(-7) + BInt(0), BInt(-7))
        XCTAssertEqual(BInt(7) + BInt(0), BInt(7))
        XCTAssertEqual(BInt(7) + 4, BInt(11))
        XCTAssertEqual(BInt(7) + (-4), BInt(3))
        XCTAssertEqual(BInt(-7) + 4, BInt(-3))
        XCTAssertEqual(BInt(-7) + (-4), BInt(-11))
        XCTAssertEqual(BInt(-7) + 0, BInt(-7))
        XCTAssertEqual(BInt(7) + 0, BInt(7))
        XCTAssertEqual(7 + BInt(4), BInt(11))
        XCTAssertEqual(7 + BInt(-4), BInt(3))
        XCTAssertEqual((-7) + BInt(4), BInt(-3))
        XCTAssertEqual((-7) + BInt(-4), BInt(-11))
        XCTAssertEqual((-7) + BInt(0), BInt(-7))
        XCTAssertEqual(7 + BInt(0), BInt(7))
    }
    
    func test2() {
        var x1 = BInt(7)
        x1 += BInt(4)
        XCTAssertEqual(x1, BInt(11))
        var x2 = BInt(7)
        x2 += BInt(-4)
        XCTAssertEqual(x2, BInt(3))
        var x3 = BInt(-7)
        x3 += BInt(4)
        XCTAssertEqual(x3, BInt(-3))
        var x4 = BInt(-7)
        x4 += BInt(-4)
        XCTAssertEqual(x4, BInt(-11))
    }

    func test3() {
        for i in 0 ..< 1000 {
            let a = i % 2 == 0 ? BInt(bitWidth: 1000) : -BInt(bitWidth: 1000)
            let b = BInt(bitWidth: 800)
            let n = BInt(bitWidth: 500)
            let ab = a + b
            let an = a * n
            XCTAssertEqual(ab - a, b)
            XCTAssertEqual(ab - b, a)
            XCTAssertEqual(an - a, a * (n - 1))
        }
    }

    func test4() {
        for i in 0 ..< 1000 {
            let a = i % 2 == 0 ? BInt(bitWidth: 1000) : -BInt(bitWidth: 1000)
            var b = a
            for _ in 0 ..< 100 {
                b += a
            }
            XCTAssertEqual(b, a * 101)
        }
    }

}
