//
//  LcmTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 13/02/2022.
//

import XCTest
@testable import BigInt

class LcmTest: XCTestCase {

    func test1() {
        XCTAssertEqual(BInt.ZERO.lcm(BInt.ZERO), BInt.ZERO)
        XCTAssertEqual(BInt.ZERO.lcm(BInt.ONE), BInt.ZERO)
        XCTAssertEqual(BInt.ONE.lcm(BInt.ZERO), BInt.ZERO)
        XCTAssertEqual(BInt(18).lcm(BInt(21)), BInt(126))
        XCTAssertEqual(BInt(-18).lcm(BInt(21)), BInt(126))
        XCTAssertEqual(BInt(18).lcm(BInt(-21)), BInt(126))
        XCTAssertEqual(BInt(-18).lcm(BInt(-21)), BInt(126))
    }

    func test2() {
        XCTAssertEqual(BInt.ZERO.lcm(0), BInt.ZERO)
        XCTAssertEqual(BInt.ZERO.lcm(1), BInt.ZERO)
        XCTAssertEqual(BInt.ONE.lcm(0), BInt.ZERO)
        XCTAssertEqual(BInt(18).lcm(21), BInt(126))
        XCTAssertEqual(BInt(-18).lcm(21), BInt(126))
        XCTAssertEqual(BInt(18).lcm(-21), BInt(126))
        XCTAssertEqual(BInt(-18).lcm(-21), BInt(126))
    }

}
