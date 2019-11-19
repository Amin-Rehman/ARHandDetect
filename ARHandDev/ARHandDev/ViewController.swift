//
//  ViewController.swift
//  ARHandDev
//
//  Created by Stephanie on 18.11.19.
//  Copyright © 2019 Stephanie. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


  func randomColor() -> UIColor{
    let red = CGFloat(drand48())
    let green = CGFloat(drand48())
    let blue = CGFloat(drand48())
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
  }

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var allTasks: [String]?
    var taskIterator = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Some mock tasks
        self.allTasks = ["Tomatoes", "Apples", "Cheese"]

        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    
        // Set the scene to the view
        for task in allTasks! {
            let text = SCNText(string: task, extrusionDepth: 1)
            let material = SCNMaterial()
            material.diffuse.contents = randomColor()
            text.materials = [material]
            
            let node = SCNNode()
            
            node.position = SCNVector3(x: Float.random(in: -1 ... 1), y: Float.random(in: -0.5 ... 1), z: Float.random(in: -2.0 ... -0.5))
            node.scale = SCNVector3(x: 0.02, y: 0.01, z: 0.01)
            node.geometry = text
            
            let animation = CABasicAnimation(keyPath: "geometry.extrusionDepth")
            animation.fromValue = 2.0
            animation.toValue = 8.0
            animation.duration = 0.5
            animation.autoreverses = true
            animation.repeatCount = .infinity
            node.addAnimation(animation, forKey: "extrude")
            
            sceneView.scene.rootNode.addChildNode(node)
            sceneView.autoenablesDefaultLighting = true
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
    
        // MARK: - ARSCNViewDelegate
        
    /*
        // Override to create and configure nodes for anchors added to the view's session.
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            let node = SCNNode()
         
            return node
        }
    */
    
//    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SCNNode? {
//        // Create and configure a node for the anchor added to the view's session.
//        let labelNode = SCNText(string: allTasks![taskIterator], extrusionDepth: 1)
////
////        labelNode.fontSize = 45
////        labelNode.fontColor = SKColor.green
////        labelNode.horizontalAlignmentMode = .center
////        labelNode.verticalAlignmentMode = .center
//
////        let rotateAction = SKAction.rotate(toAngle: .pi / 4, duration: 1)
////        let rotateBackAction = SKAction.rotate(toAngle: -(.pi / 4), duration: 1)
////        let repeatRotateForever = SKAction.repeatForever(SKAction.sequence([rotateAction, rotateBackAction]))
////        labelNode.run(repeatRotateForever)
//
//        taskIterator = taskIterator + 1
//
//        return labelNode
//    }
    
    
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
