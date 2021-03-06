//
//  WPTLevelScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import AVFoundation

class WPTLevelScene: WPTScene {
    static let levelNameTag = "_LEVEL"
    static let playerNameTag = "_PLAYER"
    let level: WPTLevel
    public private(set) var puppetMaster: WPTPuppetMaster? = nil
    
    let terrain: WPTTerrainNode
    let player: WPTLevelPlayerNode
//    var touchHandler: WPTLevelTouchHandlerNode! = nil
    var hud: WPTHudNode
    let projectiles: SKNode
    let items: SKNode
    let port: WPTPortNode?
    
    // Calculated from the difficulty
    let meanCoinDrop: Int
    let stddevCoinDrop: Float
    
    // Camera stuff
    var cam: SKCameraNode!
    private var camFollowPlayer: Bool = true
    
    var contactDelegate: WPTLevelPhysicsContactHandler! = nil
    
    var levelPaused: Bool = false {
        didSet { self.pauseChanged() }
    }
    
    var levelBeaten: Bool {
        guard let progress = self.player.player.progress else { return false }
        return progress.completedLevels.contains(self.level.name)
    }
    
    let levelStartMoney: Int
    
    init(player: WPTPlayer, level: WPTLevel) {
        NSLog("------------ STARTING LEVEL \"\(level.name)\" ------------")
        self.levelStartMoney = player.progress!.doubloons
        self.player = WPTLevelPlayerNode(player: player)
        self.level = level
        self.terrain = WPTTerrainNode(level: level, player: self.player)
        self.hud = WPTHudNode(player: self.player, terrain: self.terrain)
        self.projectiles = SKNode()
        self.projectiles.zPosition = WPTZPositions.actors
        self.items = SKNode()
        self.items.zPosition = WPTZPositions.actors
        if let port = level.port {
            self.port = WPTPortNode(port: port)
            self.port!.name = WPTPortNode.nodeNameTag
        } else {
            self.port = nil
        }
        
        self.meanCoinDrop = Int(self.level.goldDrop * CGFloat(WPTValues.defaultCoinDropMean))
        self.stddevCoinDrop = Float(self.level.goldDrop * CGFloat(WPTValues.defaultCoinDropStddev))
        
        super.init(size: CGSize(width: 0, height: 0))
//        self.touchHandler = WPTLevelTouchHandlerNode(self)
        
        self.listener = self.player
        self.scene?.backgroundColor = UIColor.black
        
        // setup the physics behavior
        self.physicsWorld.gravity = CGVector.zero
        self.contactDelegate = WPTLevelPhysicsContactHandler(self)
        self.physicsWorld.contactDelegate = self.contactDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // difficulty
        if self.level.difficulty > self.player.player.difficulty {
            self.player.player.difficulty = self.level.difficulty
            NSLog("Difficulty level increased from \(self.player.player.difficulty) to \(self.level.difficulty)")
        } else {
            NSLog("Scene starting with difficulty \(self.player.player.difficulty)")
        }
        
        // camera
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam)
        cam.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.hud.position = CGPoint(x: -self.cam.frame.midX, y: -self.cam.frame.midY)
        self.cam.setScale(1.0 / WPTValues.levelSceneScale)
        cam.addChild(self.hud)
        self.camera?.position = self.terrain.position + self.level.spawnPoint
        
        // setup the port
        if let port = self.port {
            terrain.addChild(port)
        }
        
        // setup the player
        self.player.name = WPTLevelScene.playerNameTag
        self.player.position = self.terrain.spawnPoint
        self.terrain.addChild(self.player)
        
        // add everything to the scene
        self.addChild(projectiles)
        self.addChild(items)
        self.addChild(self.terrain)
        
        // setup the puppet master
        self.puppetMaster = WPTPuppetMaster(self)
        self.puppetMaster!.setStage(levelBeaten: player.player.completedLevels.contains(level.name))
        
        // touch handler
//        self.addChild(self.touchHandler)
        
        // add spawn volumes?
        if WPTConfig.values.showSpawnVolumesOnMinimap {
            hud.pauseMenu.map.drawSpawnVolumes(self.level.spawnVolumes)
        }
        // show the tutorial (if there is one)
        if (level.hasTutorial && WPTConfig.values.showTutorial && !levelBeaten) {
            self.levelPaused = true
            let tutorial = WPTTutorialNode(hud: hud, onComplete: {
                self.levelPaused = false
                self.levelNameDisplay()
            })
            cam.addChild(tutorial)
        } else {
            levelNameDisplay()
        }
        
        // treasure chest?
        if let treasurePos = self.level.xMarksTheSpot {
            let treasureNode = WPTFinalTreasureNode()
            treasureNode.position = treasurePos
            self.terrain.addChild(treasureNode)
        }
    }
    
    override func getSong() -> String {
        if (self.levelBeaten) {
            return "level_map_theme.wav"
        } else {
            return "waypoint.wav"
        }
    }
    
    private func levelNameDisplay() {
        // breif flash of level name
        let levelName = WPTLabelNode(text: self.level.name, fontSize: WPTValues.fontSizeLarge)
        levelName.name = WPTLevelScene.levelNameTag
        levelName.zPosition = WPTZPositions.touchHandler - 1
        levelName.position.y += 0.2 * WPTValues.screenSize.height
        levelName.alpha = 0
        levelName.fontColor = UIColor.black
        self.cam.addChild(levelName)
        WPTLabelNode.fadeInOut(levelName, 0.5, 2, 2, 2, completion: {
            levelName.removeFromParent()
        })
    }
    
    private var lastCurrentTime: TimeInterval? = nil
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = lastCurrentTime == nil ? 0 : currentTime - lastCurrentTime!
        lastCurrentTime = currentTime

        if self.levelPaused { return } // everything below this is subject to the pause
        
        // puppet master
        self.puppetMaster?.update(deltaTime: deltaTime)
        
        // actors
//        self.touchHandler.update(currentTime, deltaTime)
        self.player.update(currentTime, deltaTime)
        for enemy in self.terrain.enemies {
            enemy.update(currentTime, deltaTime)
        }
        self.terrain.wakeManager.update(currentTime, deltaTime)
        
        // HUD
        self.hud.update(currentTime, deltaTime)
    }
    
    override func didSimulatePhysics() {
        // center camera on player while restricting the camera bounds
        var target = self.terrain.position + self.player.position
        
        // restrict vertical direction
        let sceneHeight = self.scene!.size.height * self.cam.yScale
        let top = target.y + sceneHeight / 2.0
        let bottom = top - sceneHeight
        if top > terrain.size.height {
            target.y = terrain.size.height - sceneHeight / 2.0
        } else if bottom < 0 {
            target.y = sceneHeight / 2.0
        }
        
        // restrict horizontal direction
        let sceneWidth = self.scene!.size.width * self.cam.xScale
        let left = target.x - sceneWidth / 2.0
        let right = left + sceneWidth
        if left < 0 {
            target.x = sceneWidth / 2.0
        } else if right > terrain.size.width {
            target.x = terrain.size.width - sceneWidth / 2.0
        }
        
        // apply the camera position
        if self.camFollowPlayer {
            self.cam.position = target
        }
    }
    
    public func setCameraPosition(_ position: CGPoint? = nil, duration: TimeInterval, then: @escaping () -> Void = {}) {
        if position == nil {
            self.camFollowPlayer = true
        } else {
            self.camFollowPlayer = false
            self.cam.run(SKAction.move(to: position!, duration: duration), completion: then)
        }
    }
        
    private func pauseChanged() {
        if let levelName = self.childNode(withName: WPTLevelScene.levelNameTag) {
            levelName.isPaused = self.levelPaused
        }
        self.physicsWorld.speed = self.levelPaused ? 0.0 : 1.0 // pause physics simulation
        self.terrain.isPaused = self.levelPaused // pause actions that may be running
        self.items.isPaused = self.levelPaused // pause actions on any items in the scene
        if let wave = self.puppetMaster?.currentState as? WPTWaveExecutionPMS {
            wave.wave?.pause(paused: self.levelPaused)
        }
    }
    
    func alert(header: String, desc: String, large: Bool = false) {
        if large {
            self.hud.alert.show(header: header, desc: desc)
        } else {
            self.hud.bottom.alert.show(header: header, desc: desc)
        }
    }
    
    func getSceneFrame() -> CGRect {
        let sceneWidth = self.scene!.size.width * self.cam.xScale
        let sceneHeight = self.scene!.size.height * self.cam.yScale
        
        let origin = CGPoint(x: self.cam.position.x - sceneWidth / 2, y: self.cam.position.y - sceneHeight / 2)
        return CGRect(origin: origin, size: CGSize(width: sceneWidth, height: sceneHeight))
    }
    
    func dropCoins(position: CGPoint, size: CGSize, scale: CGFloat = 1.0) {
        let coins = WPTItemCatalog.randomItemSet(mean: Int(scale * CGFloat(self.meanCoinDrop)), stddev: self.stddevCoinDrop)
        for coin in coins {
            var rand = randomNumber(min: 0, max: 1)
            let xPos = position.x - size.width / 2.0 + rand * size.width
            rand = randomNumber(min: 0, max: 1)
            let yPos = position.y - size.height / 2.0 + rand * size.height
            
            let moneyNode = WPTItemNode(coin, duration: 10)
            moneyNode.position = CGPoint(x: xPos, y: yPos)
            self.items.addChild(moneyNode)
        }
    }
}
