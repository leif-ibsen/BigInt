//
//  IntMinMaxTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 09/10/2021.
//

import XCTest
@testable import BigInt

class IntMinMaxTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        XCTAssertEqual(BInt(11) + Int.max, BInt(11) + BInt(Int.max))
        XCTAssertEqual(Int.max + BInt(11), BInt(Int.max) + BInt(11))
        var x = BInt(11)
        x += Int.max
        XCTAssertEqual(x, BInt(11) + BInt(Int.max))
        XCTAssertEqual(BInt(11) + Int.min, BInt(11) + BInt(Int.min))
        XCTAssertEqual(Int.min + BInt(11), BInt(Int.min) + BInt(11))
        x = BInt(11)
        x += Int.min
        XCTAssertEqual(x, BInt(11) + BInt(Int.min))
    }

    func test2() {
        XCTAssertEqual(BInt(11) - Int.max, BInt(11) - BInt(Int.max))
        XCTAssertEqual(Int.max - BInt(11), BInt(Int.max) - BInt(11))
        var x = BInt(11)
        x -= Int.max
        XCTAssertEqual(x, BInt(11) - BInt(Int.max))
        XCTAssertEqual(BInt(11) - Int.min, BInt(11) - BInt(Int.min))
        XCTAssertEqual(Int.min - BInt(11), BInt(Int.min) - BInt(11))
        x = BInt(11)
        x -= Int.min
        XCTAssertEqual(x, BInt(11) - BInt(Int.min))
    }

    func test3() {
        XCTAssertEqual(BInt(7) * Int.max, BInt(7) * BInt(Int.max))
        XCTAssertEqual(BInt(7) * Int.min, BInt(7) * BInt(Int.min))
        XCTAssertEqual(BInt(-7) * Int.max, BInt(-7) * BInt(Int.max))
        XCTAssertEqual(BInt(-7) * Int.min, BInt(-7) * BInt(Int.min))
        XCTAssertEqual(BInt(0) * Int.max, BInt(0))
        XCTAssertEqual(BInt(0) * Int.min, BInt(0))
        XCTAssertEqual(Int.max * BInt(7), BInt(7) * BInt(Int.max))
        XCTAssertEqual(Int.min * BInt(7), BInt(7) * BInt(Int.min))
        XCTAssertEqual(Int.max * BInt(-7), BInt(-7) * BInt(Int.max))
        XCTAssertEqual(Int.min * BInt(-7), BInt(-7) * BInt(Int.min))
        XCTAssertEqual(Int.max * BInt(0), BInt(0))
        XCTAssertEqual(Int.min * BInt(0), BInt(0))
    }

    func test4() {
        let x = BInt.one << 1000
        XCTAssertEqual(x / Int.max, x / BInt(Int.max))
        XCTAssertEqual(x / Int.min, x / BInt(Int.min))
        XCTAssertEqual(-x / Int.max, -x / BInt(Int.max))
        XCTAssertEqual(-x / Int.min, -x / BInt(Int.min))
        XCTAssertEqual(BInt(0) / Int.max, BInt(0))
        XCTAssertEqual(BInt(0) / Int.min, BInt(0))
    }

    func test5() {
        XCTAssertEqual(BInt(Int.max) - BInt(Int.max), BInt(0))
        XCTAssertEqual(BInt(Int.max) - Int.max, BInt(0))
        XCTAssertEqual(Int.max - BInt(Int.max), BInt(0))
        XCTAssertEqual(BInt(Int.min) - BInt(Int.min), BInt(0))
        XCTAssertEqual(BInt(Int.min) - Int.min, BInt(0))
        XCTAssertEqual(Int.min - BInt(Int.min), BInt(0))
        XCTAssertEqual(BInt(Int.max) + BInt(Int.min), BInt(-1))
        XCTAssertEqual(BInt(Int.max) + Int.min, BInt(-1))
        XCTAssertEqual(Int.max + BInt(Int.min), BInt(-1))
        XCTAssertEqual(BInt(Int.max).asInt()!, Int.max)
        XCTAssertEqual(BInt(Int.min).asInt()!, Int.min)
    }

}
