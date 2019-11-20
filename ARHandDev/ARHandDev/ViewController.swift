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
import CoreML
import Vision


class ViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    // MARK: - Variables
    var allTasks: [String]?
    var taskIterator = 0
    var currentBuffer: CVPixelBuffer?
    var previewView = UIImageView()
    let planeNode = PlaneNode()
    var coordinateList = [Coordinate]()

    
    // MARK: - Lifecycle
    override public func loadView() {
        super.loadView()

        view = sceneView

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()


        sceneView.autoenablesDefaultLighting = true
        // Disabled because of random crash
        configuration.environmentTexturing = .none

        // We want to receive the frames from the video
        sceneView.session.delegate = self

        // Run the session with the configuration
        sceneView.session.run(configuration)

        // The delegate is used to receive ARAnchors when they are detected.
        sceneView.delegate = self
        
        sceneView.debugOptions = [.showPhysicsShapes]

        view.addSubview(previewView)

        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Some mock tasks
        self.allTasks = ["Tomatoes", "Apples", "Pears", "Dry Ice", "Rubbish"]

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    
        // Set the scene to the view
        for task in allTasks! {
            let text = SCNText(string: task, extrusionDepth: 1)
            let material = SCNMaterial()
            material.diffuse.contents = ColourMaker.makeRandomColor()
            text.materials = [material]

            let textNode = SCNNode()

            // Generate some coordinates and append them to the list held by the view controller
            self.coordinateList.append(textNode.setFunkyAttributes(with: text, coordinateList: self.coordinateList))
            textNode.setFunkyAnimation()
            
            print("BOUNDINGBOX")
            print(textNode.boundingBox)
            // move pivot point to bottom center instead of top left
            let min = textNode.boundingBox.min
            let max = textNode.boundingBox.max

            textNode.pivot = SCNMatrix4MakeTranslation(
                (max.x - min.x)/2,
                (max.y - min.y)/2,
                (max.z - min.z)/2
            )
            
            let shape = SCNPhysicsShape(node: textNode, options: nil)
        

            textNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)

            textNode.physicsBody?.mass = 10
            textNode.physicsBody?.friction = 0
            textNode.physicsBody?.setResting(true)
            
            // Add planeNode that the text rests on cuz gravity
            let planeNode = PlaneNode()
            planeNode.position = textNode.position
            planeNode.position.y -= 0.1
            planeNode.position.x -= 0.6

            // Add planeNode
            sceneView.scene.rootNode.addChildNode(planeNode)
            
            // Add text node
            sceneView.scene.rootNode.addChildNode(textNode)
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
    

    // MARK: - ARSessionDelegate
    public func session(_: ARSession, didUpdate frame: ARFrame) {
        // We return early if currentBuffer is not nil or the tracking state of camera is not normal
        guard currentBuffer == nil, case .normal = frame.camera.trackingState else {
            return
        }

        // Retain the image buffer for Vision processing.
        currentBuffer = frame.capturedImage
        

        startDetection()
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    // MARK: - Private functions
    let handDetector = HandDetector()

    private func startDetection() {
        // To avoid force unwrap in VNImageRequestHandler
        guard let buffer = currentBuffer else { return }

        handDetector.performDetection(inputBuffer: buffer) { outputBuffer, _ in
            // Here we are on a background thread
            var previewImage: UIImage?
            var normalizedFingerTip: CGPoint?

            defer {
                DispatchQueue.main.async {
                    self.previewView.image = previewImage

                    // Release currentBuffer when finished to allow processing next frame
                    self.currentBuffer = nil

                    
                    guard let tipPoint = normalizedFingerTip else {
                        return
                    }
                    

                    // We use a coreVideo function to get the image coordinate from the normalized point
                    let imageFingerPoint = VNImagePointForNormalizedPoint(tipPoint, Int(self.view.bounds.size.width), Int(self.view.bounds.size.height))
                    
                    let hitTestResults = self.sceneView.hitTest(imageFingerPoint, options: nil)
                    guard let hitTestResult = hitTestResults.first else { return }

                    self.punchText(with: hitTestResult.node)
                            
                }
            }

            guard let outBuffer = outputBuffer else {
                return
            }

            // Create UIImage from CVPixelBuffer
            previewImage = UIImage(ciImage: CIImage(cvPixelBuffer: outBuffer))
            normalizedFingerTip = outBuffer.searchTopPoint()
        }
    }
    
    func punchText(with node: SCNNode) {
        let nodeToRemove = node
        nodeToRemove.physicsBody?.setResting(false)
        
        let force = SCNVector3(x: 0, y: 20, z: -200)
        nodeToRemove.physicsBody?.isAffectedByGravity = false
        nodeToRemove.physicsBody?.applyForce(force, asImpulse: true)
        playAudioFromProject()
    }
    
    private func playAudioFromProject() {
        if let soundURL = Bundle.main.url(forResource: "Completed", withExtension: "caf") {
//            let player = try! AVAudioPlayer(contentsOf: soundURL)
//            player.play()
            print("Playing FILE")
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
            // Play
            AudioServicesPlaySystemSound(mySound);
        }
    }
}

extension SCNNode {
    func setFunkyAttributes(with text: SCNText,
                            coordinateList: [Coordinate]) -> Coordinate {
        self.geometry = text
        let geometryWidth = self.geometry!.boundingBox.max.x - self.geometry!.boundingBox.min.x

        let coordinate = CoordinateMaker.makeCoordinate(vicinityCoordinates: coordinateList,
                                                        width: geometryWidth)

        self.position = SCNVector3(x: coordinate.x,
                                   y: coordinate.y,
                                   z: -2.0)
        self.scale = SCNVector3(x: 0.02, y: 0.01, z: 0.01)

        return coordinate
    }


    func setFunkyAnimation() {
        let animation = CABasicAnimation(keyPath: "geometry.extrusionDepth")
        animation.fromValue = 2.0
        animation.toValue = 8.0
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        self.addAnimation(animation, forKey: "extrude")
    }
}
