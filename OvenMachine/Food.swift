//
//  Food.swift
//  OvenMachine
//
//  Created by student on 2019-01-31.
//  Copyright © 2019 Cole Dewis. All rights reserved.
//

import Foundation
//the class for each food item.
class Food {
    var name: String
    var cookTime: Int
    var rating: Double
    var description: String
    var amountCooked:Int = 0
    var sellPrice: Double
    var quantity:Int = 0
    static var totalCooked:Int = 0
    var defaultSellPrice: Double
    var upgradePrice: Double
    
    init(_ name: String, cookTime: Int, rating: Double, description:String, sellPrice: Double, defaultSellPrice:Double, upgradePrice:Double) {
        self.name = name
        self.cookTime = cookTime
        self.rating = rating
        self.description = description
        self.sellPrice = sellPrice
        self.defaultSellPrice = defaultSellPrice
        self.upgradePrice = upgradePrice
        
    }
    
    /// function returns food name as a string
    func getName() -> String{
        if(!name.isEmpty){
            return name
        }
        else {
            return "error"
        }
    }
    
    ///function returns the amount of food cooked
    func getAmountCooked() -> Int{
        return amountCooked
    }
    
    ///function sets amount cooked to i
    func setAmountCooked(_ i:Int){
        amountCooked = i
    }
}

