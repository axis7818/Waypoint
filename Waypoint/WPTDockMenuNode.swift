//
//  WPTDockMenuNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/20/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTDockMenuNode: SKNode {
    
    let background: SKSpriteNode
    let dockShroud: SKShapeNode
    let player: WPTLevelPlayerNode
    var itemPicker: WPTItemPickerNode? = nil
    
    var itemNameLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
    var doubloonsLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
    let moneyImage = SKSpriteNode(imageNamed: "doubloons")
    var priceLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
    var descriptionLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeTiny)
    var purchaseLabel = WPTButtonNode(text: "Purchase", fontSize: WPTValues.fontSizeSmall)
    let wahm = WPTButtonNode(text: "Sail >", fontSize: WPTValues.fontSizeSmall)
    
    init(player: WPTLevelPlayerNode) {
        
        self.player = player
        self.background = SKSpriteNode(imageNamed: "pause_scroll")
        self.dockShroud = SKShapeNode(rectOf: WPTValues.screenSize)
        
        super.init()
        self.isUserInteractionEnabled = true
        
        // shroud
        self.dockShroud.fillColor = UIColor.black
        self.dockShroud.strokeColor = UIColor.black
        self.dockShroud.zPosition = WPTValues.pauseShroudZPosition * 2
        self.dockShroud.alpha = 0.6
        self.addChild(self.dockShroud)
        
        // background
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = WPTValues.pauseShroudZPosition * 2
        let width = 0.9 * WPTValues.screenSize.height
        let scale = width / (background.texture?.size().width)!
        background.size = CGSize(width: width, height: 2 * scale * background.texture!.size().height)
        background.zRotation = CGFloat(M_PI) / 2.0
        self.addChild(background)
        
        let titleLabel = WPTLabelNode(text: "Port Shop", fontSize: WPTValues.fontSizeMedium)
        titleLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        titleLabel.fontColor = UIColor.black
        titleLabel.position = CGPoint(x: 0, y: 0.30 * dockShroud.frame.height)
        self.addChild(titleLabel)
        
        var items: [WPTItem] = []
        items.append(WPTItemCatalog.itemsByName["Ship Maintenance"]!)
        items.append(WPTItemCatalog.itemsByName["Cannon"]!)
        for _ in 0..<3 {
            items.append(WPTItemCatalog.randomStatModifier())
        }
        
        itemNameLabel.horizontalAlignmentMode = .center
        itemNameLabel.position = CGPoint(x: -0.12 * dockShroud.frame.size.width, y: 0.15 * dockShroud.frame.height)
        itemNameLabel.fontColor = UIColor.black
        itemNameLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        self.addChild(itemNameLabel)
        
        itemPicker = WPTItemPickerNode(items: items, onChange: updateStats)
        itemPicker!.position = CGPoint(x: -0.12 * dockShroud.frame.size.width, y: -0.05 * dockShroud.frame.height)
        itemPicker!.zPosition = WPTValues.pauseShroudZPosition * 2 + 1
        itemPicker!.setSize(width: 0.7 * background.size.width, height: background.size.height)
        self.addChild(itemPicker!)
        
        descriptionLabel.horizontalAlignmentMode = .center
        descriptionLabel.position = CGPoint(x: -0.12 * dockShroud.frame.size.width, y: -0.29 * dockShroud.frame.height)
        descriptionLabel.fontColor = UIColor.black
        descriptionLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 3
        self.addChild(descriptionLabel)
        
        let moneyImgSize = 1.8 * WPTValues.fontSizeSmall
        self.moneyImage.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        self.moneyImage.position = CGPoint(x: 0.13 * dockShroud.frame.width, y: 0.17 * dockShroud.frame.height)
        self.moneyImage.size = CGSize(width: moneyImgSize, height: moneyImgSize)
        self.addChild(self.moneyImage)
        
        doubloonsLabel.horizontalAlignmentMode = .left
        doubloonsLabel.position = CGPoint(x: 0.17 * dockShroud.frame.width, y: 0.14 * dockShroud.frame.height)
        doubloonsLabel.fontColor = UIColor.black
        doubloonsLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        self.addChild(doubloonsLabel)
        
        priceLabel.horizontalAlignmentMode = .left
        priceLabel.position = CGPoint(x: 0.10 * dockShroud.frame.width, y: 0)
        priceLabel.fontColor = UIColor.black
        priceLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        self.addChild(priceLabel)
        
        purchaseLabel.position = CGPoint(x: 0.185 * dockShroud.frame.width, y: -0.12 * dockShroud.frame.height)
        purchaseLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        self.addChild(purchaseLabel)
        
        wahm.position = CGPoint(x: 0.22 * dockShroud.frame.size.width, y: -0.31 * dockShroud.frame.size.height)
        wahm.zPosition = WPTValues.pauseShroudZPosition * 2 + 3
        self.addChild(wahm)
        
        updateStats(item: (itemPicker?.currentItem)!)
    }
    
    func updateStats(item: ItemWrapper) {
        self.itemNameLabel.text = item.item.name
        self.descriptionLabel.text = item.item.description
        if (player.player.doubloons < item.item.value || item.purchased) {
            self.purchaseLabel.disabled = true
        } else {
            self.purchaseLabel.disabled = false
        }
        if (item.purchased) {
            self.priceLabel.text = "Price: Bought"
            self.itemPicker!.itemImage.alpha = 0.5
        } else {
            self.priceLabel.text = "Price: \(item.item.value)"
            self.itemPicker!.itemImage.alpha = 1.0
        }
    }
    
    func updateDoubloons() {
        self.doubloonsLabel.text = String(player.player.doubloons)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPos = touches.first!.location(in: self)
        
        if !self.background.contains(touchPos) {
            self.removeFromParent()
        } else if self.purchaseLabel.contains(touchPos) && !self.purchaseLabel.disabled {
            purchaseItem()
        } else if self.wahm.contains(touchPos) {
            // update the player's progress
            player.player.health = player.currentHealth
            if let scene = self.scene as? WPTLevelScene {
                player.player.completedLevels.append(scene.level.name)
            }
            
            // save the progress
            player.player.progress = WPTPlayerProgress(player: player.player)
            let storage = WPTStorage()
            storage.savePlayerProgress(player.player.progress!)
            
            // move to the world scene
            self.scene!.view?.presentScene(WPTWorldScene(player: player.player))
        }
    }
    
    private func purchaseItem() {
        player.player.doubloons -= itemPicker!.currentItem.item.value
        assert(player.player.doubloons >= 0)
        updateDoubloons()
        if let hud = (self.scene as? WPTLevelScene)?.hud {
            hud.top.updateMoney()
        }
        self.itemPicker!.itemImage.alpha = 0.5
        self.priceLabel.text = "Price: Bought"
        self.purchaseLabel.disabled = true
        itemPicker!.currentItem.purchased = true
        player.give(item: itemPicker!.currentItem.item)
    }
}