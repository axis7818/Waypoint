//
//  GameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/16/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTSplashScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "worldmap")
    
    let titleNode = WPTLabelNode(text: gameName, fontSize: fontSizeTitle)
    let tapToCont = WPTLabelNode(text: "Tap to continue...", fontSize: fontSizeSmall)
    let fadeIn = SKAction.fadeIn(withDuration: 3.0)
    
    var canProceed = false
    
    override func didMove(to view: SKView) {
        // add the map to the background
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.zPosition = -1
        addChild(background)
        
        // setup the title
        titleNode.alpha = 0
        titleNode.fontColor = .black
        titleNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(titleNode)
        
        // tap to continue...
        tapToCont.alpha = 0
        tapToCont.fontColor = .black
        tapToCont.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        addChild(tapToCont)
        
        // fade in all fancy
        titleNode.run(.fadeIn(withDuration: 2.0)) {
            self.canProceed = true
            self.tapToCont.run(.fadeIn(withDuration: 0.4))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!self.canProceed) {
            return
        }
        
        let homeScene = WPTHomeScene()
        homeScene.scaleMode = .resizeFill
        self.scene?.view?.presentScene(homeScene)
    }

}
