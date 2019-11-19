////
////  Scene.swift
////  ARHandDev
////
////  Created by Stephanie on 18.11.19.
////  Copyright © 2019 Stephanie. All rights reserved.
////
//
//import SpriteKit
//import ARKit
//
//class ToDoScene: SKScene {
//    var isWorldSetUp = false
//    var alreadyGenerated = [ToDoARCoordinates]()
//
//    var todoCoordinateMaker = ToDoARCoordinatesMaker()
//    var allAnchors: [ARAnchor]?
//    
//    var spriteKitSceneView: ARSKView {
//      return view as! ARSKView
//    }
//    
//    override func didMove(to view: SKView) {
//        // Setup your scene here
//    }
//    
//    override func sceneDidLoad() {
//        // Create anchor using the camera's current position
//    }
//
//    public func setupWorld() {
//        guard let currentFrame = spriteKitSceneView.session.currentFrame else {
//            return
//        }
//        
//        // Create a transform with a translation of 0.3 meters in front of the camera
//        let transform1 = currentFrame.camera.transform * makeTranslation()
//        let transform2 = currentFrame.camera.transform * makeTranslation()
//        let transform3 = currentFrame.camera.transform * makeTranslation()
//
//        let anchor1 = ARAnchor(transform: transform1)
//        let anchor2 = ARAnchor(transform: transform2)
//        let anchor3 = ARAnchor(transform: transform3)
//        
//        allAnchors = [anchor1, anchor2, anchor3]
//
//        for anchor in allAnchors! {
//            spriteKitSceneView.session.add(anchor: anchor)
//        }
//
//        isWorldSetUp = true
//    }
//
//    private func makeTranslation() -> simd_float4x4 {
//        var translation = matrix_identity_float4x4
//        translation.columns.3.z = -1.5
//        let coordinates = todoCoordinateMaker.makeCoordinate(excludingCoordinates: alreadyGenerated)
//        alreadyGenerated.append(coordinates)
//        translation.columns.3.y = coordinates.y
//        translation.columns.3.x = coordinates.x
//        return translation
//    }
//    
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//        if !isWorldSetUp {
//            setupWorld()
//        }
//    }
//}
//
//// MARK: -
//struct ToDoARCoordinates {
//    let x: Float
//    let y: Float
//
//    let threshold:Float = 0.25
//
//    func isWithInThreshold(of coordinates: ToDoARCoordinates) -> Bool {
//        var xDiff: Float
//        var yDiff: Float
//
//        if self.x < coordinates.x {
//            xDiff = coordinates.x - self.x
//        } else {
//            xDiff = self.x - coordinates.x
//        }
//
//        if self.y < coordinates.y {
//            yDiff = coordinates.y - self.y
//        } else {
//            yDiff = self.y - coordinates.y
//        }
//
//        print("xDiff: \(xDiff)")
//        print("yDiff: \(yDiff)")
//        return xDiff > threshold && yDiff > threshold
//    }
//}
//
//struct ToDoARCoordinatesMaker {
//    func makeCoordinate(excludingCoordinates: [ToDoARCoordinates]) -> ToDoARCoordinates {
//        let x = Float(drand48() - 0.5)
//        let y = Float(drand48() - 0.5)
//
//        let candidateCoordinate = ToDoARCoordinates(x: x, y: y)
//        var thresholdResults = [Bool]()
//
//        for excluding in excludingCoordinates {
//            let isWithinThreshHold = excluding.isWithInThreshold(of: candidateCoordinate)
//            thresholdResults.append(isWithinThreshHold)
//        }
//
//        if thresholdResults.contains(true) {
//            return makeCoordinate(excludingCoordinates: excludingCoordinates)
//        } else {
//            return candidateCoordinate
//        }
//    }
//}
