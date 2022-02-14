//
//  LcmTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 13/02/2022.
//

import XCTest

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

}
