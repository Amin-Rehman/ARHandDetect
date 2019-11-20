//
//  CoordinateMaker.swift
//  ARHandDev
//
//  Created by Amin Rehman on 19.11.19.
//  Copyright © 2019 Stephanie. All rights reserved.
//

import Foundation

struct Coordinate {
    let x: Float
    let y: Float

    // Simple Pythagorean Theorem to calculate distance between the two points
    func distanceTo(coordinate: Coordinate) -> Float {
        let x1 = coordinate.x
        let y1 = coordinate.y

        let yDiff = y1 - y
        let xDiff = x1 - x
        let yDiffSquare = pow(yDiff, 2.0)
        let xDiffSquare = pow(xDiff, 2.0)
        let sumOfSquares = yDiffSquare + xDiffSquare

        return sumOfSquares.squareRoot()
    }
}

struct CoordinateMaker {
    // Some Limits
    let minX = Float(-1.0)
    let maxX = Float(1.0)
    let minY = Float(-0.5)
    let maxY = Float(1.0)

    // Threshold
    let globalThreshold = Float(0.05)

//    func makeCoordinate(vicinityCoordinates: [Coordinate]) -> Coordinate {
//        let calculatedX = Float.random(in: minX ... maxX)
//        let calculatedY = Float.random(in : minY ... maxY)
//
//        // Iterate through all coorddinates and
//        let reEvaluate = false
//        for let coordinate in vicinityCoordinates {
//            let vicnityX =
//
//
//        }
//
//        if reEvaluate == true {
//            makeCoordinate(vicinityCoordinates: vicinityCoordinates)
//        } else {
//            return Coordinate(x: calculatedX, y: calculatedY)
//        }
//    }
}
