//
//  WPTWorldScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTWorldScene: WPTScene {
    
    let worldMap = WPTWorldMap()
    
    var player: WPTPlayer
    
    init(player: WPTPlayer) {
        self.player = player
        super.init(size: CGSize(width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        worldMap.position(for: self)
        self.addChild(worldMap)
    }
}
