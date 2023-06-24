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
        XCTAssertEqual(BInt.zero.lcm(BInt.zero), BInt.zero)
        XCTAssertEqual(BInt.zero.lcm(BInt.one), BInt.zero)
        XCTAssertEqual(BInt.one.lcm(BInt.zero), BInt.zero)
        XCTAssertEqual(BInt(18).lcm(BInt(21)), BInt(126))
        XCTAssertEqual(BInt(-18).lcm(BInt(21)), BInt(126))
        XCTAssertEqual(BInt(18).lcm(BInt(-21)), BInt(126))
        XCTAssertEqual(BInt(-18).lcm(BInt(-21)), BInt(126))
    }

}
