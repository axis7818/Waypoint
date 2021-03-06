//
//  WPTItemCatalog.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/3/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTItemCatalog {
    
    static let itemsByName: [String:WPTItem] = {
        var items = [String:WPTItem]()
        for itemGroup in [("currency_items", WPTItemTier.currency),
                         ("repair_items", WPTItemTier.repair),
                         ("stat_modifier_items", WPTItemTier.statModifier),
                         ("other_items", WPTItemTier.other)] {
            
            let theFile = Bundle.main.path(forResource: itemGroup.0, ofType: "plist")
            for itemDict in NSArray(contentsOfFile: theFile!) as! [[String:AnyObject]] {
                
                var item: WPTItem! = nil
                switch itemGroup.1 {
                case WPTItemTier.currency:
                    item = WPTItem(asCurrency: itemDict)
                case WPTItemTier.repair:
                    item = WPTItem(asRepair: itemDict)
                case WPTItemTier.statModifier:
                    item = WPTItem(asStatModifier: itemDict)
                case WPTItemTier.other:
                    item = WPTItem(itemDict)
                }
                
                assert(items[item.name] == nil, "An item with the name \(item.name) already exists!")
                items[item.name] = item
            }
            
        }
        return items
    }()
    
    static let allItems = WPTItemCatalog.itemsByName.values
    static let currencyItems: [WPTItem] = allItems.filter { $0.tier == WPTItemTier.currency }
    static let repairItems: [WPTItem] = allItems.filter { $0.tier == WPTItemTier.repair }
    static let statModifierItems: [WPTItem] = allItems.filter { $0.tier == WPTItemTier.statModifier }
    
    private static let currencyPrevalenceMap = PrevalenceMap(for: WPTItemCatalog.currencyItems)
    private static let repairPrevalenceMap = PrevalenceMap(for: WPTItemCatalog.repairItems)
    private static let statModifierPrevalenceMap = PrevalenceMap(for: WPTItemCatalog.statModifierItems)
    
    private class PrevalenceMap {
        private var map = [WPTItem]()
        
        init(for items: [WPTItem]) {
            for item in items {
                for _ in 0..<item.prevalence {
                    map.append(item)
                }
            }
            assert(map.count > 1)
        }
        
        func random() -> WPTItem {
            let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let index = CGFloat(map.count - 1) * rand
            return self.map[Int(index)]
        }
    }
    
    static let randomCurrency = WPTItemCatalog.currencyPrevalenceMap.random
    static let randomRepair = WPTItemCatalog.repairPrevalenceMap.random
    static let randomStatModifier = WPTItemCatalog.statModifierPrevalenceMap.random
    
    private static let sortedCurrency = {
        return WPTItemCatalog.currencyItems.sorted(by: { (a: WPTItem, b: WPTItem) -> Bool in
            return a.value > b.value
        })
    }()
    static func randomItemSet(mean: Int, stddev: Float) -> [WPTItem] {
        var value = max(1, Int(randomNormalSample(mean: Float(mean), stddev: stddev)))
        var result = [WPTItem]()
        
        while (value > 0) {
            for item in WPTItemCatalog.sortedCurrency {
                if item.value <= value {
                    result.append(item)
                    value -= item.value
                    break
                }
            }
        }
        
        assert(value == 0)
        return result
    }
    
    static func getRandomItems(count: Int) -> [WPTItem] {
        var result = [WPTItem]()
        assert(count >= 0)
        for _ in 0..<count {
            result.append(WPTItemCatalog.randomStatModifier())
        }
        return result
    }
}
