//
//  Model.swift
//  OvenMachine
//
//  Created by student on 2018-11-22.
//  Copyright © 2018 Cole Dewis. All rights reserved.
//

import Foundation

//Model database
//Stores important global variables
class Model {
    //general variables
    static var text: String!
    static var doReset: Bool = true
    static var counter: Int = 6
    static var money: Double = 0
    static var speedUpgradePrice: Double = 50
    static var sellUpgradePrice: Double = 75
    static var shelfUpgradePrice: Double = 300
    static var bananaBreadPurchased: Bool = false
    static var pizzaPurchased: Bool = false
    static var lasagnaPurchased: Bool = false
    static var newShelf: Bool = false
    static var pickerData: [String] = [String]()
    static var attemptCount: Int = 0
    static var successCount: Int = 0
    
    //help related variables
    static var marketFirstLoad: Bool = true
    static var upgradesFirstLoad: Bool = true
    static var statsFirstLoad: Bool = true
    static var firstLoad: Bool = true
    
    //Disaster related variables
    static var marketDisabled: Bool = false
    static var upgradesDisabled: Bool = false
    static var isCooking: Bool = false
    static var disasterCount: Int = 0
    
    //game reset related variables
    static var doGameReset: Bool = false
    static var canRebirth: Bool = false
    static var rebirthCount: Double = 0
    
    //each food item is appended to this cookbook
    static var cookbook = [
        Food( "Cake",  cookTime: 8,  rating: 1.0,  description: "Betty Crocker classic!",  sellPrice: 8.00, defaultSellPrice: 8.00, upgradePrice: 7),
        Food( "Bread",  cookTime: 5,  rating: 1.0,  description: "its bread", sellPrice: 3.50, defaultSellPrice: 3.50, upgradePrice: 5),
        Food( "Mac n Cheese",  cookTime: 10,  rating: 1.0,  description: "KD but worse", sellPrice: 10.25, defaultSellPrice: 10.25, upgradePrice: 9)
    ]
    /*
     1 = All Food gone
     2 = Upgrades disabled
     3 = Oven Slowed
     4 = Half Money gone
     5 = Market closed
     */
    static var disasterList = [
        Disasters("Food walked away", category: 1),
        Disasters("Communism", category: 1),
        Disasters("Tornado", category: 1),
        Disasters("Russian Invasion", category: 2),
        Disasters("Alien Invasion", category: 2),
        Disasters("Zombie Apocalypse", category: 2),
        Disasters("Power Surge", category: 3),
        Disasters("Electromagnetic Pulse", category: 3),
        Disasters("Sun Explodes", category: 3),
        Disasters("Taxes", category: 4),
        Disasters("Economic Downturn", category: 4),
        Disasters("Lawsuit", category: 4),
        Disasters("Nuclear War", category: 5),
        Disasters("Super-Virus", category: 5),
        Disasters("Quarantine", category: 5)
    ]
    
    //Calculates the total amount of food cooked by adding the amount of each food cooked
    static var currentCooked:Int {
        var v = 0
        for i:Food in cookbook{
            v += (i.getAmountCooked())
        }
        return v
    }
    //Calculates the total value of the food you have cooked
    static var totalValue: Double {
        var v = 0.0
        for i:Food in Model.cookbook{
            v += (i.sellPrice * Double(i.getAmountCooked()))
        }
        return v
    }

}
