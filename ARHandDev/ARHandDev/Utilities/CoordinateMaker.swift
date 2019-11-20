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
    // Threshold
    public static let globalDistanceThreshold = Float(0.05)

    static func makeCoordinate(vicinityCoordinates: [Coordinate]) -> Coordinate {
        // Some Limits
        let minX = Float(-1.0)
        let maxX = Float(1.0)
        let minY = Float(-0.5)
        let maxY = Float(1.0)

        let calculatedX = Float.random(in: minX ... maxX)
        let calculatedY = Float.random(in : minY ... maxY)
        let calculatedCoordinate = Coordinate(x: calculatedX, y: calculatedY)

        // Iterate through all coorddinates and
        var reEvaluate = false
        for coordinate in vicinityCoordinates {
            let distance  = calculatedCoordinate.distanceTo(coordinate: coordinate)

            if distance > globalDistanceThreshold {
                continue
            } else {
                reEvaluate = true
                break
            }
        }

        if reEvaluate == true {
            return makeCoordinate(vicinityCoordinates: vicinityCoordinates)
        } else {
            return Coordinate(x: calculatedX, y: calculatedY)
        }
    }
}
