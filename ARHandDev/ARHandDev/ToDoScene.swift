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
    
    var sceneView: ARSKView {
      return view as! ARSKView
    }
    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func sceneDidLoad() {
        // Create anchor using the camera's current position
    }

    public func setupWorld() {
        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }
        
        // Create a transform with a translation of 0.3 meters in front of the camera
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.5
        translation.columns.3.y = Float(drand48() - 0.5)
        let transform = currentFrame.camera.transform * translation
        
        // Add a new anchor to the session
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)

        
        isWorldSetUp = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !isWorldSetUp {
            setupWorld()
        }
    }
    
}
