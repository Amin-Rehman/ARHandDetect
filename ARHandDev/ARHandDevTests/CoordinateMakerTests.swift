//
//  ARHandDevTests.swift
//  ARHandDevTests
//
//  Created by Amin Rehman on 19.11.19.
//  Copyright © 2019 Stephanie. All rights reserved.
//

import XCTest
@testable import ARHandDev

class CoordinateTests: XCTestCase {

    func testDistance5() {
        let coordinate1 = Coordinate(x: -2.0, y: 1.0)
        let coordinate2 = Coordinate(x: 1.0, y: 5.0)

        let distance = coordinate1.distanceTo(coordinate: coordinate2)
        XCTAssertEqual(distance, Float(5.0))
    }

    func testDistance4() {
        let coordinate1 = Coordinate(x: -2.0, y: 1.0)
        let coordinate2 = Coordinate(x: -2.0, y: 5.0)

        let distance = coordinate1.distanceTo(coordinate: coordinate2)
        XCTAssertEqual(distance, Float(4.0))
    }

    func testDistanceLarge() {
        let coordinate1 = Coordinate(x: -2.0, y: -11.0)
        let coordinate2 = Coordinate(x: 22.0, y: 5.0)

        let distance = coordinate1.distanceTo(coordinate: coordinate2)
        XCTAssertEqual(distance, Float(28.84441))
    }
}


class CoordinateMakerTests: XCTestCase {

    func testExample() {
    }

}
