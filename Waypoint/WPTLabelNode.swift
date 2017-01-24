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
        super.init(fontNamed: booter)
        
        self.text = text
        self.fontSize = fontSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}