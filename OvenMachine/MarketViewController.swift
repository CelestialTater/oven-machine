//
//  MarketViewController.swift
//  OvenMachine
//
//  Created by student on 2019-02-28.
//  Copyright © 2019 Cole Dewis. All rights reserved.
//

import UIKit

class MarketViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var model: Model!
    var cookbookIndex:Int = 0
    static var goodFood: Int = 0
    static var badFood: Int = 0
    var refreshTimer = Timer()
    public var pickerData: [String] = [String]()
    
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var marketImage: UIImageView!
    @IBOutlet weak var itemToSell: UIPickerView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var sellStepper: UIStepper!
    @IBOutlet weak var desiredFood: UILabel!
    @IBOutlet weak var hatedFood: UILabel!
    @IBOutlet weak var money: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //initiates view
        money.text = "Money: $\(Model.money)"
        self.itemToSell.delegate = self
        self.itemToSell.dataSource = self
        pickerData = []
        sellStepper.maximumValue = Double(Model.cookbook[cookbookIndex].amountCooked)
        sellStepper.minimumValue = 0.0
        
        //adds each food to the pickerData array
        for i:Food in Model.cookbook{
            pickerData.append(i.getName())
        }
        
        //if market should reset, resets
        if Model.doReset == true{
            for i:Food in Model.cookbook{
                //resets all prices to default
                i.sellPrice = i.defaultSellPrice
            }
            //picks random good food and bad food
            MarketViewController.goodFood = Int(arc4random_uniform(UInt32(Model.cookbook.count)))
            MarketViewController.badFood = Int(arc4random_uniform(UInt32(Model.cookbook.count)))
            
            //checks to ensure the goodfood cannot be bad food, then changes the value of bad food
            if (MarketViewController.goodFood == MarketViewController.badFood) {
                if(MarketViewController.badFood == 0){
                    MarketViewController.badFood += 1
                }else{
                    MarketViewController.badFood -= 1
                }
            }
            //changes sell prices for foods
            Model.cookbook[MarketViewController.badFood].sellPrice *= 0.5
            Model.cookbook[MarketViewController.goodFood].sellPrice += 3.00
            //reset is false
            Model.doReset = false
        }
        //sets labels
        desiredFood.text = "Current Desired Food: " + "\(Model.cookbook[MarketViewController.goodFood].name)"
        hatedFood.text = "Current Hated Food: " + "\(Model.cookbook[MarketViewController.badFood].name)"
        
        //displays help if first load
        if Model.marketFirstLoad == true{
            //creates alert
            let alert = UIAlertController(title: "Welcome!", message: "Welcome to the Marketplace! Here you can sell your food. The current desired food will sell for more money, and hated food will sell for less. Variety is key if you want to please the buyers! \n Select the food you want to sell with the picker, use + and - to control amount, and then press sell.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            //present for user input
            present(alert, animated: true, completion: nil)
            Model.marketFirstLoad = false
 
        }
    }
    //UIPickerView functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cookbookIndex = row
        sellStepper.maximumValue = Double(Model.cookbook[cookbookIndex].amountCooked)
        sellStepper.value = Double(Model.cookbook[cookbookIndex].quantity)
        count.text = "\(Model.cookbook[cookbookIndex].quantity)"
        
    }
    //selling func
    @IBAction func sellFood(_ sender: Any) {
        var message:String = "Are you sure you want to sell the following items: "
        var totalValue: Double = 0
        
        //adds lines to display how much of each food you have selected to sell
        for i:Food in Model.cookbook{
            message.append("\(i.name): \(i.quantity) \n")
            totalValue += Double(i.quantity) * i.sellPrice
        }
        message.append("Sell Price: \(totalValue)")
        //creates alert
        let alert = UIAlertController(title: "Sell Items", message: message, preferredStyle: .alert)
        
        //cancel + ok buttons.
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (_)in
            
            //subtracts the amount sold & adds money you have earned
            for i:Food in Model.cookbook{
                i.amountCooked -= i.quantity
                Model.money += i.sellPrice * Double(i.quantity)
                i.quantity = 0
                self.sellStepper.maximumValue = Double(Model.cookbook[self.cookbookIndex].amountCooked)
                self.sellStepper.value = Double(Model.cookbook[self.cookbookIndex].quantity)
                self.count.text = "\(Model.cookbook[self.cookbookIndex].quantity)"
            }
            self.money.text = "Money: $\(Model.money)"

        }
        )
        alert.addAction(cancel)
        alert.addAction(ok)
        
        //present for user input
        present(alert, animated: true, completion: nil)
        
    }
    //stepper control
    @IBAction func controlAmount(_ sender: UIStepper) {
        count.text = Int(sender.value).description
        Model.cookbook[cookbookIndex].quantity = Int(sender.value)
    }

    
}
