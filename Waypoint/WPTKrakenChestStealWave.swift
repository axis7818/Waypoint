//
//  WPTKrakenChestStealWave.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTKrakenChestStealWave: WPTLevelWave {
    
    init() {
        super.init([:])
    }
    
    override func setup(scene: WPTLevelScene) {
        
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        // determine if the kraken is beaten
        print("Kraken Takes Chest")
        return true
    }
}

