//
//  TouchNode.swift
//  ARML
//
//  Created by Stephanie on 18.11.19.
//  Copyright © 2019 Stephanie. All rights reserved.
//

import SceneKit

public class PlaneNode: SCNNode {

    // MARK: - Lifecycle

    public override init() {
        super.init()
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // Touch node configuration
        let box = SCNBox(width: 1.5, height: 0.001, length: 0.3, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red

        geometry = box        
        box.materials = [material]

        let boxShape = SCNPhysicsShape(geometry: box, options: nil)
        
        physicsBody = SCNPhysicsBody(type: .static, shape: boxShape)
    }
}
