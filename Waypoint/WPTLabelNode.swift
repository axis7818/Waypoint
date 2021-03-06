//
//  WPTLabelNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLabelNode: SKLabelNode {
    
    override init() {
        super.init()
    }
    
    init(text: String, fontSize: CGFloat) {
        super.init(fontNamed: WPTValues.booter)
        
        self.text = text
        self.fontSize = fontSize
        self.zPosition = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func fadeInOut(_ label: WPTLabelNode, _ delayDuration: TimeInterval, _ inDuration: TimeInterval, _ waitDuration: TimeInterval, _ outDuration: TimeInterval, completion: @escaping () -> Void) {
        
        let delay = SKAction.wait(forDuration: delayDuration)
        let fadeIn = SKAction.fadeIn(withDuration: inDuration)
        let wait = SKAction.wait(forDuration: waitDuration)
        let fadeOut = SKAction.fadeOut(withDuration: outDuration)
        
        label.run(SKAction.sequence([delay, fadeIn, wait, fadeOut]), completion: completion)
    }
}
