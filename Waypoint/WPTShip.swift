//
//  WPTShip.swift
//  Waypoint
//
//  Created by Hilary Schulz on 1/26/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTShip {
    let previewImage: String
    let inGameImage: String
    
    // TODO: finalize these values
    static let minSpeedScale: Double = 0.4
    static let maxSpeedScale: Double = 2.4
    static let minDamageScale: Double = 0.5
    static let maxDamageScale: Double = 50.0
    static let minHealthScale: Double = 1.0
    static let maxHealthScale: Double = 50.0
    static let minRangeScale: Double = 0.4
    static let maxRangeScale: Double = 15.0
    static let minShotSpeedScale: Double = 0.3
    static let maxShotSpeedScale: Double = 10.0
    static let minSizeScale: Double = 0.5
    static let maxSizeScale: Double = 20
    static let minTurnRateScale: Double = 0.3
    static let maxTurnRateScale: Double = 10
    
    var speedScale: Double = 1.0 {
        didSet { clamp(&speedScale, min: WPTShip.minSpeedScale, max: WPTShip.maxSpeedScale) }
    }
    
    var damageScale = 1.0 {
        didSet { clamp(&damageScale, min: WPTShip.minDamageScale, max: WPTShip.maxDamageScale) }
    }
    
    var healthScale = 1.0 {
        didSet { clamp(&healthScale, min: WPTShip.minHealthScale, max: WPTShip.maxHealthScale) }
    }
    
    var rangeScale = 1.0 {
        didSet { clamp(&rangeScale, min: WPTShip.minRangeScale, max: WPTShip.maxRangeScale) }
    }
    
    var shotSpeedScale = 1.0 {
        didSet { clamp(&shotSpeedScale, min: WPTShip.minShotSpeedScale, max: WPTShip.maxShotSpeedScale) }
    }
    
    var sizeScale = 1.0 {
        didSet { clamp(&sizeScale, min: WPTShip.minSizeScale, max: WPTShip.maxSizeScale) }
    }
    
    var turnRateScale = 1.0 {
        didSet { clamp(&turnRateScale, min: WPTShip.minTurnRateScale, max: WPTShip.maxTurnRateScale) }
    }
    
    init(previewImage: String, inGameImage: String) {
        self.previewImage = previewImage
        self.inGameImage = inGameImage
        self.initStats()
    }
    
    func initStats(speedScale: Double = 1.0, damageScale: Double = 1.0, healthScale: Double = 1.0, rangeScale: Double = 1.0, shotSpeedScale: Double = 1.0) {
        self.speedScale = speedScale
        self.damageScale = damageScale
        self.healthScale = healthScale
        self.rangeScale = rangeScale
        self.shotSpeedScale = shotSpeedScale
    }
    
    func shuffleStats() {
        self.speedScale = WPTShip.randStat(min: WPTShip.minSpeedScale, max: WPTShip.maxSpeedScale)
        self.damageScale = WPTShip.randStat(min: WPTShip.minDamageScale, max: WPTShip.maxDamageScale)
        self.healthScale = WPTShip.randStat(min: WPTShip.minHealthScale, max: WPTShip.maxHealthScale)
        self.rangeScale = WPTShip.randStat(min: WPTShip.minRangeScale, max: WPTShip.maxRangeScale)
        self.shotSpeedScale = WPTShip.randStat(min: WPTShip.minShotSpeedScale, max: WPTShip.maxShotSpeedScale)
    }
    
    static func randStat(min: Double, max: Double) -> Double {
        let rand = Double(arc4random()) / Double(UInt32.max)
        return (max - min) * rand + min
    }
}