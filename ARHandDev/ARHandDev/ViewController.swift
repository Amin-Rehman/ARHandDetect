//
//  ViewController.swift
//  ARHandDev
//
//  Created by Stephanie on 18.11.19.
//  Copyright © 2019 Stephanie. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    var allTasks: [String]?
    var taskIterator = 0

    override func viewDidLoad() {
        // Some mock tasks
        self.allTasks = ["Tomatoes", "Apples", "Cheese"]

        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let todoScene = SKScene(fileNamed: "ToDoScene") {
            sceneView.presentScene(todoScene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let labelNode = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        labelNode.text = allTasks![taskIterator]
        labelNode.fontSize = 45
        labelNode.fontColor = SKColor.green
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        
        let rotateAction = SKAction.rotate(toAngle: .pi / 4, duration: 1)
        let rotateBackAction = SKAction.rotate(toAngle: -(.pi / 4), duration: 1)
        let repeatRotateForever = SKAction.repeatForever(SKAction.sequence([rotateAction, rotateBackAction]))
        labelNode.run(repeatRotateForever)
        
        taskIterator = taskIterator + 1

        return labelNode
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
}
