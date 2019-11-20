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
    let width: Float

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

    func doesNotIntersectWith(coordinate: Coordinate) -> Bool {
        let xIntersects = (x + width < coordinate.x) && (coordinate.x + coordinate.width < x)
        let yIntersects = (pow((coordinate.y - y), 2.0)).squareRoot() > 0.35
        return !(xIntersects && yIntersects)
    }
}

struct CoordinateMaker {
    // Threshold
    public static let globalDistanceThreshold = Float(0.5)

    static func makeCoordinate(vicinityCoordinates: [Coordinate],
                               width: Float = 0,
                               attemptCount: Int = 0) -> Coordinate {
        // Some Limits
        let minX = Float(-2.5)
        let maxX = Float(2.5)
        let minY = Float(-0.75)
        let maxY = Float(1.0)

        let calculatedX = Float.random(in: minX ... maxX)
        let calculatedY = Float.random(in : minY ... maxY)
        let calculatedCoordinate = Coordinate(x: calculatedX, y: calculatedY, width: width)

        // Iterate through all coorddinates and
        var reEvaluate = false
        for coordinate in vicinityCoordinates {
            let distance  = calculatedCoordinate.distanceTo(coordinate: coordinate)

            if distance > globalDistanceThreshold &&
                calculatedCoordinate.doesNotIntersectWith(coordinate: coordinate) {
                continue
            } else {
                reEvaluate = true
                break
            }
        }

        if reEvaluate == true && attemptCount < 20 {
            return makeCoordinate(vicinityCoordinates: vicinityCoordinates,
                                  width: width,
                                  attemptCount: attemptCount + 1)
        } else {
            return calculatedCoordinate
        }
    }
}
