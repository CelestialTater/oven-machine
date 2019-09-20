//
//  UpgradesViewController.swift
//  OvenMachine
//
//  Created by student on 2019-04-11.
//  Copyright © 2019 Cole Dewis. All rights reserved.
//

import Foundation
import UIKit

class UpgradesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    public var pickerData: [String] = [String]()
    static var shelves: Int = 1
    static var cookbookIndex:Int = 0
    var checkForReset = Timer()
    var bbPrice: Double = 2.50
    var pizzaPrice: Double = 9.50
    var lasagnaPrice: Double = 12.0

    @IBOutlet weak var Lasagna: UIButton!
    @IBOutlet weak var FoodToUpgrade: UIPickerView!
    @IBOutlet weak var FasterCooking: UIButton!
    @IBOutlet weak var BananaBread: UIButton!
    @IBOutlet weak var BetterSelling: UIButton!
    @IBOutlet weak var Pizza: UIButton!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var Shelf: UIButton!
    
    
    override func viewDidLoad() {
        bbPrice += Model.rebirthCount
        pizzaPrice += Model.rebirthCount
        lasagnaPrice += Model.rebirthCount
        
        money.text = "Money: $\(Model.money)"
        //timer that constantly runs to check if the game should be reset
        checkForReset = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reset), userInfo:nil, repeats: true)
        //adds each food to the pickerData array
        for i:Food in Model.cookbook{
            pickerData.append(i.getName())
        }
        //disables the buttons to buy foods you already possess
        if(Model.bananaBreadPurchased == true){
            BananaBread.isEnabled = false
        }
        if(Model.pizzaPurchased == true){
            Pizza.isEnabled = false
        }
        if(Model.lasagnaPurchased == true){
            Lasagna.isEnabled = false
        }
        self.FoodToUpgrade.delegate = self
        self.FoodToUpgrade.dataSource = self
        UpgradesViewController.cookbookIndex = 0
        //upon first load, display help
        if Model.upgradesFirstLoad == true{
            //creates alert
            let alert = UIAlertController(title: "Welcome!", message: "Welcome to Upgrades! Here you can purchase new recipies, and upgrade the ones you already have. The picker at the bottom is for rating upgrades. Select the food you want to upgrade and then press upgrade.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            //present for user input
            present(alert, animated: true, completion: nil)
            Model.upgradesFirstLoad = false
            
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
        UpgradesViewController.cookbookIndex = row
    }
    
    //Banana Bread Purchase
    @IBAction func buyBananaBread(_ sender: Any) {
        //creates alert
        let alert = UIAlertController(title: "Banana Bread Recipie", message: "Variety will help your sales! Purchase Banana Bread Recipie. Price: 20", preferredStyle: .alert)
        
        //cancel + ok buttons.
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if Model.money >= 20{
            let ok = UIAlertAction(title: "Yes", style: .default, handler: { (_)in
                
                //Adds Banana Bread to picker, removes money spent
                Model.cookbook.append(Food( "Banana Bread",  cookTime: 3,  rating: 1.0,  description: "somehow worse than bread", sellPrice: self.bbPrice, defaultSellPrice: self.bbPrice, upgradePrice: 3))
                Model.pickerData.append("Banana Bread")
                Model.money -= 20
                self.BananaBread.isEnabled = false
                Model.bananaBreadPurchased = true
                //dismisses segue
                self.navigationController?.popToRootViewController(animated: true)
                self.money.text = "Money: $\(Model.money)"
            }
            )
            alert.addAction(ok)
        }
        alert.addAction(cancel)
        
        //present for user input
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func buyLasanga(_ sender: Any) {
        //creates alert
        let alert = UIAlertController(title: "Lasagna Recipie", message: "Variety will help your sales! Purchase Lasagna Recipie. Price: 80", preferredStyle: .alert)
        
        //cancel + ok buttons.
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if Model.money >= 80{
            let ok = UIAlertAction(title: "Yes", style: .default, handler: { (_)in
                
                //Adds Lasagna to picker, removes money spent
                Model.cookbook.append(Food( "Lasagna",  cookTime: 10,  rating: 1.0,  description: "garfield likes this", sellPrice: self.lasagnaPrice, defaultSellPrice: self.lasagnaPrice, upgradePrice: 12))
                Model.pickerData.append("Lasagna")
                Model.money -= 80
                self.Lasagna.isEnabled = false
                Model.lasagnaPurchased = true
                self.navigationController?.popToRootViewController(animated: true)
                self.money.text = "Money: $\(Model.money)"
            }
            )
            alert.addAction(ok)
        }
        alert.addAction(cancel)
        
        //present for user input
        present(alert, animated: true, completion: nil)
        
    }
    //Pizza Purchase
    @IBAction func buyPizza(_ sender: Any) {
        //creates alert
        let alert = UIAlertController(title: "Pizza Recipie", message: "Variety will help your sales! Purchase Pizza Recipie. Price: 40", preferredStyle: .alert)
        
        //cancel + ok buttons.
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if Model.money >= 40{
            let ok = UIAlertAction(title: "Yes", style: .default, handler: { (_)in
                
                //Adds Pizza to picker, removes money spent
                Model.cookbook.append(Food( "Pizza",  cookTime: 7,  rating: 1.0,  description: "ye ol bread-sauce disk", sellPrice: self.pizzaPrice, defaultSellPrice: self.pizzaPrice, upgradePrice: 10))
                Model.pickerData.append("Pizza")
                Model.money -= 40
                self.Pizza.isEnabled = false
                Model.pizzaPurchased = true
                self.navigationController?.popToRootViewController(animated: true)
                self.money.text = "Money: $\(Model.money)"
            }
            )
            alert.addAction(ok)
        }
        alert.addAction(cancel)
        
        //present for user input
        present(alert, animated: true, completion: nil)
        
    }
    //speed upgrade
    @IBAction func cookSpeedUpgrade(_ sender: Any) {
        //creates alert
        let alert = UIAlertController(title: "Oven Upgrade", message: "Speed up your production speed! Upgrade your oven to decrease cook time for all foods by 1 second. Price: \(Model.speedUpgradePrice.rounded()) \n (Note: Cook times cannot go below 1 second. This will do nothing if all cook times are at 1 second)", preferredStyle: .alert)
        
        //cancel + ok buttons.
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if Model.money >= Model.speedUpgradePrice{
            let ok = UIAlertAction(title: "Yes", style: .default, handler: { (_)in
                
                //lowers cook times
                for i:Food in Model.cookbook{
                    if i.cookTime > 1 {
                        i.cookTime -= 1
                    }
                }
                //subtracts money and increases the price for the next speed upgrade
                Model.money -= Model.speedUpgradePrice
                Model.speedUpgradePrice += 25
                self.money.text = "Money: $\(Model.money)"

            }
            )
            alert.addAction(ok)
            
        }
        alert.addAction(cancel)
        
        //present for user input
        present(alert, animated: true, completion: nil)
        
    }
    //sell price upgrade
    @IBAction func sellPriceUpgrade(_ sender: Any) {
        //creates alert
        if Model.cookbook[UpgradesViewController.cookbookIndex].rating < 10.0 {
            let alert = UIAlertController(title: "Rating Upgrade", message: "Higher ratings mean better sales! Increase the rating for \(Model.cookbook[UpgradesViewController.cookbookIndex].name) by 0.5. Price: \(Model.cookbook[UpgradesViewController.cookbookIndex].upgradePrice.rounded())", preferredStyle: .alert)
            
            //cancel + ok buttons.
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            if Model.money >= Model.cookbook[UpgradesViewController.cookbookIndex].upgradePrice && Model.cookbook[UpgradesViewController.cookbookIndex].rating < 10{
                let ok = UIAlertAction(title: "Yes", style: .default, handler: { (_)in
                    
                    Model.money -= Model.cookbook[UpgradesViewController.cookbookIndex].upgradePrice.rounded()
                    Model.cookbook[UpgradesViewController.cookbookIndex].rating += 0.5
                    Model.cookbook[UpgradesViewController.cookbookIndex].defaultSellPrice += 1.0
                    Model.cookbook[UpgradesViewController.cookbookIndex].sellPrice += 1.0
                    Model.cookbook[UpgradesViewController.cookbookIndex].upgradePrice *= 1.35
                    self.money.text = "Money: $\(Model.money)"
                }
                )
                alert.addAction(ok)
                
            }
            alert.addAction(cancel)
            //present for user input
            present(alert, animated: true, completion: nil)
        }else{
            let alert2 = UIAlertController(title: "Rating Upgrade", message: "This food already has a rating of 10.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert2.addAction(cancel)
            present(alert2, animated: true, completion: nil)
        }

    }
    @IBAction func addShelf(_ sender: Any) {
        //creates alert
            let alert = UIAlertController(title: "Shelf Upgrade", message: "Increase your production speed! Adding a shelf will increase your production speed. Price: \(Model.shelfUpgradePrice.rounded())", preferredStyle: .alert)
            //cancel + ok buttons.
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            if Model.money >= Model.shelfUpgradePrice{
                let ok = UIAlertAction(title: "Yes", style: .default, handler: { (_)in
                    UpgradesViewController.shelves += 1
                    Model.money -= Model.shelfUpgradePrice
                    Model.shelfUpgradePrice *= 5
                    self.money.text = "Money: $\(Model.money)"
                    Model.newShelf = true
                }
                )
                alert.addAction(ok)
                
            }
            alert.addAction(cancel)
            //present for user input
            present(alert, animated: true, completion: nil)
        
    }
    @objc func reset(){
        //checks if the game is to be reset
        if (Model.doGameReset == true){
            Pizza.isEnabled = true
            Lasagna.isEnabled = true
            BananaBread.isEnabled = true
            UpgradesViewController.shelves = 1
            Model.doGameReset = false
            
        }
    }


}
