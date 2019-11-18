//
//  Scene.swift
//  ARHandDev
//
//  Created by Stephanie on 18.11.19.
//  Copyright © 2019 Stephanie. All rights reserved.
//

import SpriteKit
import ARKit

class ToDoScene: SKScene {
    var isWorldSetUp = false
    var allAnchors: [ARAnchor]?
    
    var spriteKitSceneView: ARSKView {
      return view as! ARSKView
    }
    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func sceneDidLoad() {
        // Create anchor using the camera's current position
    }

    public func setupWorld() {
        guard let currentFrame = spriteKitSceneView.session.currentFrame else {
            return
        }
        
        // Create a transform with a translation of 0.3 meters in front of the camera
        let transform1 = currentFrame.camera.transform * makeTranslation()
        let transform2 = currentFrame.camera.transform * makeTranslation()

        let anchor1 = ARAnchor(transform: transform1)
        let anchor2 = ARAnchor(transform: transform2)
        
        allAnchors = [anchor1, anchor2]

        for anchor in allAnchors! {
            spriteKitSceneView.session.add(anchor: anchor)
        }

        isWorldSetUp = true
    }

    private func makeTranslation() -> simd_float4x4 {
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.5
        translation.columns.3.y = Float(drand48() - 0.5)
        translation.columns.3.x = Float(drand48() - 0.5)
        return translation
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !isWorldSetUp {
            setupWorld()
        }
    }
    
}
