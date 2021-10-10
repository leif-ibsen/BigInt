//
//  SubtractionTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 19/01/2019.
//

import XCTest

class SubtractionTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        XCTAssertEqual(BInt(7) - BInt(4), BInt(3))
        XCTAssertEqual(BInt(7) - BInt(-4), BInt(11))
        XCTAssertEqual(BInt(-7) - BInt(4), BInt(-11))
        XCTAssertEqual(BInt(-7) - BInt(-4), BInt(-3))
        XCTAssertEqual(BInt(-7) - BInt(0), BInt(-7))
        XCTAssertEqual(BInt(7) - BInt(0), BInt(7))
        XCTAssertEqual(BInt(7) - 4, BInt(3))
        XCTAssertEqual(BInt(7) - (-4), BInt(11))
        XCTAssertEqual(BInt(-7) - 4, BInt(-11))
        XCTAssertEqual(BInt(-7) - (-4), BInt(-3))
        XCTAssertEqual(BInt(-7) - 0, BInt(-7))
        XCTAssertEqual(BInt(7) - 0, BInt(7))
        XCTAssertEqual(7 - BInt(4), BInt(3))
        XCTAssertEqual(7 - BInt(-4), BInt(11))
        XCTAssertEqual((-7) - BInt(4), BInt(-11))
        XCTAssertEqual((-7) - BInt(-4), BInt(-3))
        XCTAssertEqual((-7) - BInt(0), BInt(-7))
        XCTAssertEqual(7 - BInt(0), BInt(7))
    }
    
    func test2() {
        var x1 = BInt(7)
        x1 -= BInt(4)
        XCTAssertEqual(x1, BInt(3))
        var x2 = BInt(7)
        x2 -= BInt(-4)
        XCTAssertEqual(x2, BInt(11))
        var x3 = BInt(-7)
        x3 -= BInt(4)
        XCTAssertEqual(x3, BInt(-11))
        var x4 = BInt(-7)
        x4 -= BInt(-4)
        XCTAssertEqual(x4, BInt(-3))
        
    }

}
