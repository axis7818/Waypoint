//
//  GameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/16/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class SplashScene: SKScene {
    
    let fontName = "Zapfino"
    
    let titleNode = SKLabelNode(text: "Waypoint")
    let tapToCont = SKLabelNode(text: "Tap to continue ...")
    let fadeIn = SKAction.fadeIn(withDuration: 3.0)
    
    override func didMove(to view: SKView) {
        
        // setup the title
        setup(label: titleNode)
        titleNode.fontSize = 80
        titleNode.fontColor = .cyan
        titleNode.position = CGPoint(x: frame.midX, y: frame.midY)
        
        // tap to continue...
        setup(label: tapToCont)
        tapToCont.fontSize = 20
        tapToCont.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        
        // fade in all fancy
        titleNode.run(.fadeIn(withDuration: 3.0)) {
            self.tapToCont.run(.fadeIn(withDuration: 1.0))
        }
    }
    
    func setup(label: SKLabelNode) {
        label.zPosition = 1
        label.alpha = 0
        label.fontName = self.fontName
        self.addChild(label)
    }

}
