//
//  WPTHudTopNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHudTopNode: SKNode, WPTUpdatable {
    
    private let player: WPTLevelPlayerNode
    
    let pause = SKSpriteNode(imageNamed: "pause")
    let moneyImage = SKSpriteNode(imageNamed: "doubloons")
    var shipName: WPTLabelNode
    var moneyCount: WPTLabelNode
    var shipHealth: WPTHealthNode
    var shipImage: SKSpriteNode
    
    init(player: WPTLevelPlayerNode) {
        self.player = player
        
        self.shipName = WPTLabelNode(text: player.player.shipName, fontSize: WPTValues.fontSizeSmall)
        let shipNameSize = WPTValues.fontSizeSmall
        let nameOffset = 0.95 * shipNameSize
        self.shipName.position = CGPoint(x: nameOffset, y: WPTValues.screenSize.height - nameOffset)
        self.shipName.fontSize = shipNameSize
        self.shipName.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.shipName.fontColor = UIColor.black
        
        self.shipImage = SKSpriteNode(imageNamed: player.player.ship.previewImage)
        let shipImgSize = 1.15 * WPTValues.fontSizeSmall
        let shipOffset = 1.4 * shipImgSize
        self.shipImage.position = CGPoint(x: shipOffset, y: WPTValues.screenSize.height - shipOffset)
        self.shipImage.size = CGSize(width: shipImgSize, height: shipImgSize)
        
        NSLog("HEALTH: Starting level with \(player.health) out of \(player.player.ship.health)")
        self.shipHealth = WPTHealthNode(maxHealth: player.player.ship.health, curHealth: player.health, persistent: true)
        self.shipHealth.position = CGPoint(x: shipOffset * 2.5, y: WPTValues.screenSize.height - shipOffset * 1.1)
        
        self.moneyCount = WPTLabelNode(text: String(player.doubloons), fontSize: WPTValues.fontSizeSmall)
        
        super.init()
        
        self.addChild(shipName)
        self.addChild(shipImage)
        self.addChild(shipHealth)
        self.addChild(moneyCount)
        
        let moneyImgSize = 1.15 * WPTValues.fontSizeSmall
        let moneyOffset = 1.4 * moneyImgSize
        self.moneyImage.position = CGPoint(x: moneyOffset, y: WPTValues.screenSize.height - moneyOffset*1.7)
        self.moneyImage.size = CGSize(width: moneyImgSize, height: moneyImgSize)
        self.addChild(self.moneyImage)
        
        self.moneyCount.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.moneyCount.fontColor = UIColor.black
        self.moneyCount.position = CGPoint(x: moneyOffset * 1.55, y: WPTValues.screenSize.height - moneyOffset * 1.85)
        
        let pauseSize = 0.8 * WPTValues.fontSizeLarge
        let pauseOffset = 0.7 * pauseSize
        self.pause.position = CGPoint(x: WPTValues.screenSize.width - pauseOffset, y: WPTValues.screenSize.height - pauseOffset)
        self.pause.size = CGSize(width: pauseSize, height: pauseSize)
        self.pause.zPosition = WPTZPositions.touchHandler + 1 - WPTZPositions.hud
        self.addChild(self.pause)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
    }
    
    func updateMoney() {
        self.moneyCount.text = String(player.doubloons)
    }

}
