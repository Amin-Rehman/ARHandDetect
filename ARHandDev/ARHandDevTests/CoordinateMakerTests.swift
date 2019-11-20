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

    func testMakeCoordinateSimple() {
        let coordinate1 = Coordinate(x: 0.5, y: 0.5)
        let coordinate2 = Coordinate(x: 0.65, y: 0.75)
        let coordinate3 = Coordinate(x: -0.75, y: -0.75)

        let coordinateList = [coordinate1, coordinate2, coordinate3]

        let generatedCoordinates = CoordinateMaker.makeCoordinate(vicinityCoordinates: coordinateList)
        XCTAssertGreaterThan(generatedCoordinates.distanceTo(coordinate: coordinate1),
                             CoordinateMaker.globalDistanceThreshold)

        XCTAssertGreaterThan(generatedCoordinates.distanceTo(coordinate: coordinate2),
                             CoordinateMaker.globalDistanceThreshold)

        XCTAssertGreaterThan(generatedCoordinates.distanceTo(coordinate: coordinate3),
                             CoordinateMaker.globalDistanceThreshold)



    }

}
