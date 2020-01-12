//
//  ViewController.swift
//  OvenMachine
//
//  Created by student on 2018-11-22.
//  Copyright © 2018 Cole Dewis. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    var model: Model!
    var timer = Timer()
    var sleeping = Timer()
    var cookbookIndex:Int = 0
    var marketReset = Timer()
    var disasterTimer = Timer()
    var disasterList: [String] = [String]()
    var disasterChosen: Int = 0
    var disasterWait: Double = 0
    var negativeWaitTimer = Timer()
    var negativeWaitTimer2 = Timer()
    var failInt: Int = 0
    
    @IBOutlet weak var marketButton: UIBarButtonItem!
    @IBOutlet weak var upgradesButton: UIBarButtonItem!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var ovenImage: UIImageView!
    @IBOutlet weak var statsButton: UIBarButtonItem!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    
    @IBOutlet weak var shelfCount: UILabel!
    @IBOutlet weak var pickFood: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickFood.delegate = self
        self.pickFood.dataSource = self
        Model.pickerData = []
        shelfCount.text = "Shelves: \(UpgradesViewController.shelves)"
        
        //calculates randomly the wait for the first disaster
        disasterWait = Double(arc4random_uniform(UInt32(5)))
        disasterWait *= 60
        //starts timer for disasters
        disasterTimer = Timer.scheduledTimer(timeInterval: disasterWait, target: self, selector: #selector(naturalDisaster), userInfo:nil, repeats: true)
        
        //adds each food to the pickerData array
        for i:Food in Model.cookbook{
            Model.pickerData.append(i.getName())
        }
        //creates timers to run in background and check for reloads or if the market should reset
        sleeping = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(pickerReloadChecks), userInfo:nil, repeats: true)
        marketReset = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(doResetBool), userInfo:nil, repeats: true)
        
        //help shows up on first load
        if Model.firstLoad == true{
            //creates alert
            let alert = UIAlertController(title: "Welcome!", message: "Welcome to your kitchen! Here you can cook food. Press 'info' for information on the food you have selected. Use the picker to select a food, then start cooking by pressing 'cook'. Click the buttons in the corners to navigate to different menus. Be sure to use your resources wisely. Be careful, as things can get a bit disasterous in this kitchen...", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            //present for user input
            present(alert, animated: true, completion: nil)
            Model.firstLoad = false
            
        }
        
    }
    
    //TODO: Possibly add sound when food is done
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UIPickerView functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Model.pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Model.pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cookbookIndex = row
    }
    
    @IBAction func infoAction(_ sender: Any) {
        // Create alert + add text
        let alert = UIAlertController(title: "Information", message: "\(Model.cookbook[cookbookIndex].getName()): \(Model.cookbook[cookbookIndex].rating)/10.0 \nDescription: \(Model.cookbook[cookbookIndex].description)\nCooktime: \(Model.cookbook[cookbookIndex].cookTime) seconds\nSell Price: $\(Model.cookbook[cookbookIndex].defaultSellPrice)", preferredStyle: .alert)
        
        // cancel button
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        
        // present for user input
        present(alert, animated: true, completion: nil)
    }
    //Starts cooking
    @IBAction func buttonAction(_ sender: Any) {
        //creates an integer randomly. if this integer is 1, the food will fail to cook
        failInt = Int(arc4random_uniform(UInt32(33)))
        clickButton.isEnabled = false
        pickFood.isUserInteractionEnabled = false
        infoButton.isEnabled = false
        statsButton.isEnabled = false
        marketButton.isEnabled = false
        upgradesButton.isEnabled = false
        Model.isCooking = true
        Model.counter = Model.cookbook[cookbookIndex].cookTime
        ovenImage.image = #imageLiteral(resourceName: "newOven")
        
        //resets timer
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo:nil, repeats: true)
    }
    
    
    ///timer count method, updates values at 0
    @objc func timerAction() {
        //timer countdown
        if Model.counter>1 {
            Model.counter -= 1
            timerLabel.text = "\(Model.counter)"
            
            //updates values when timer is done counting down
        }else{
            timer.invalidate()
            //checks if the food fails.
            if failInt == 1{
                timerLabel.text = "Your \(Model.cookbook[cookbookIndex].getName()) did not turn out!"
                
                ovenImage.image = #imageLiteral(resourceName: "Failed food")
                Model.attemptCount += 1
                Model.isCooking = false
                clickButton.isEnabled = true
                pickFood.isUserInteractionEnabled = true
                infoButton.isEnabled = true
                statsButton.isEnabled = true
                if (Model.marketDisabled == false) {
                    marketButton.isEnabled = true
                }
                if (Model.upgradesDisabled == false) {
                    upgradesButton.isEnabled = true
                }
                
            }else{
                //Displays message and adds food to the foodcooked
                timerLabel.text = "Your \(Model.cookbook[cookbookIndex].getName()) is done!"
                Model.cookbook[cookbookIndex].setAmountCooked(Model.cookbook[cookbookIndex].getAmountCooked() + UpgradesViewController.shelves)
                Food.totalCooked += UpgradesViewController.shelves
                Model.successCount += 1
                Model.attemptCount += 1
                
                //sets image and re-enables buttons
                switch Model.cookbook[cookbookIndex].name {
                case "Cake":
                    ovenImage.image = #imageLiteral(resourceName: "cakeCooked")
                    break
                case "Bread":
                    ovenImage.image = #imageLiteral(resourceName: "breadCooked")
                    break
                case "Mac n Cheese":
                    ovenImage.image = #imageLiteral(resourceName: "macNCheese")
                    break
                case "Banana Bread":
                    ovenImage.image = #imageLiteral(resourceName: "bbCooked")
                    break
                case "Pizza":
                    ovenImage.image = #imageLiteral(resourceName: "pizzaCooked")
                    break
                case "Lasagna":
                    ovenImage.image = #imageLiteral(resourceName: "lasagnaCooked")
                    break
                default:
                    break
                }
                
                Model.isCooking = false
                clickButton.isEnabled = true
                pickFood.isUserInteractionEnabled = true
                infoButton.isEnabled = true
                statsButton.isEnabled = true
                //check if a disaster makes it so that a button should not be re-enabled
                if (Model.marketDisabled == false) {
                    marketButton.isEnabled = true
                }
                if (Model.upgradesDisabled == false) {
                    upgradesButton.isEnabled = true
                }
            }
        }
    }
    
    //error creation
    enum NoFoodPresentError: Error{
        case onlyThreeFoods
    }
    
    ///function to remove foods that must be purchased from the picker when game is reset
    func resetFoodList() throws {
        if (Model.pickerData.count == 6){
            Model.pickerData.remove(at: 5)
            Model.pickerData.remove(at: 4)
            Model.pickerData.remove(at: 3)
            pickFood.reloadAllComponents()
        }else if (Model.pickerData.count == 5){
            Model.pickerData.remove(at: 4)
            Model.pickerData.remove(at: 3)
            pickFood.reloadAllComponents()
        }else if (Model.pickerData.count == 4){
            Model.pickerData.remove(at: 3)
            pickFood.reloadAllComponents()
        }else{
            throw NoFoodPresentError.onlyThreeFoods
        }
    }
    ///Reloads pickerView if a new food is purchased or if the game is reset
    @objc func pickerReloadChecks(){
        if(Model.bananaBreadPurchased){
            pickFood.reloadAllComponents()
        }
        if(Model.pizzaPurchased){
            pickFood.reloadAllComponents()
        }
        if(Model.lasagnaPurchased){
            pickFood.reloadAllComponents()
        }
        if(Model.newShelf){
            shelfCount.text = "Shelves: \(UpgradesViewController.shelves)"
            Model.newShelf = false
        }
        if(Model.doGameReset == true){
            shelfCount.text = "Shelves: \(UpgradesViewController.shelves)"
            do {
                try resetFoodList()
            }catch let error{
                print("Error: \(error)")
            }
            pickFood.reloadAllComponents()
            
        }
    }
    ///Sets the boolean to reset the market every 30 seconds
    @objc func doResetBool(){
        Model.doReset = true
    }
    ///function to create natural disasters
    @objc func naturalDisaster(){
        //randomly selects a disaster
        disasterChosen = Int(arc4random_uniform(UInt32(Model.disasterList.count)))
        //invalidates the timer
        disasterTimer.invalidate()
        //switch statement to run different code depending on the category of the disaster
        switch Model.disasterList[disasterChosen].category {
        case 1:
            //creates alert
            let alert = UIAlertController(title: "Disaster!", message: "\(Model.disasterList[disasterChosen].name)! All of your food is gone!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (_)in
                //this category removes all food that you have cooked
                for i:Food in Model.cookbook{
                    i.setAmountCooked(0)
                }
                Model.disasterCount += 1
                
            }
            )
            alert.addAction(ok)
            //recreates values for a new timer for the next disaster
            disasterWait = Double(arc4random_uniform(UInt32(5)))
            disasterWait *= 60
            //starts timer
            disasterTimer = Timer.scheduledTimer(timeInterval: self.disasterWait, target: self, selector: #selector(self.naturalDisaster), userInfo:nil, repeats: true)
            
            present(alert, animated: true, completion: nil)
            break
        case 2:
            //creates alert
            let alert = UIAlertController(title: "Disaster!", message: "\(Model.disasterList[disasterChosen].name)! Your upgrades are disabled for 60 seconds!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (_)in
                //segue back
                self.navigationController?.popToRootViewController(animated: true)
                //disables upgrades and starts a 60 second timer until it is reenabled
                self.upgradesButton.isEnabled = false
                self.negativeWaitTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.reEnableUpgrades), userInfo:nil, repeats: true)
                Model.upgradesDisabled = true
                Model.disasterCount += 1
                
            }
            )
            alert.addAction(ok)
            //recreates values for a new timer for the next disaster
            disasterWait = Double(arc4random_uniform(UInt32(5)))
            disasterWait *= 60
            //starts timer
            disasterTimer = Timer.scheduledTimer(timeInterval: self.disasterWait, target: self, selector: #selector(self.naturalDisaster), userInfo:nil, repeats: true)
            
            present(alert, animated: true, completion: nil)
            
            break
        case 3:
            //creates alert
            let alert = UIAlertController(title: "Disaster!", message: "\(Model.disasterList[disasterChosen].name)! A random food will now take longer to cook!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (_)in
                //increases the cooking time for a random food
                let slowFood = Int(arc4random_uniform(UInt32(Model.cookbook.count)))
                Model.cookbook[slowFood].cookTime += 1
                Model.disasterCount += 1
                
            }
            )
            alert.addAction(ok)
            //recreates values for a new timer for the next disaster
            disasterWait = Double(arc4random_uniform(UInt32(5)))
            disasterWait *= 60
            //starts timer
            disasterTimer = Timer.scheduledTimer(timeInterval: self.disasterWait, target: self, selector: #selector(self.naturalDisaster), userInfo:nil, repeats: true)
            
            present(alert, animated: true, completion: nil)
            
            break
        case 4:
            //creates alert
            let alert = UIAlertController(title: "Disaster!", message: "\(Model.disasterList[disasterChosen].name)! Half your money is gone!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (_)in
                //removes half of your money and then rounds your money.
                Model.money *= 0.5
                Model.money.round()
                Model.disasterCount += 1
            }
            )
            alert.addAction(ok)
            //recreates values for a new timer for the next disaster
            disasterWait = Double(arc4random_uniform(UInt32(5)))
            disasterWait *= 60
            //starts timer
            disasterTimer = Timer.scheduledTimer(timeInterval: self.disasterWait, target: self, selector: #selector(self.naturalDisaster), userInfo:nil, repeats: true)
            
            present(alert, animated: true, completion: nil)
            break
        case 5:
            //creates alert
            let alert = UIAlertController(title: "Disaster!", message: "\(Model.disasterList[disasterChosen].name)! Your market is disabled for 60 seconds!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (_)in
                //segue back
                self.navigationController?.popToRootViewController(animated: true)
                //disables marketplace and starts timer for it to last 60s
                self.marketButton.isEnabled = false
                self.negativeWaitTimer2 = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.reEnableMarket), userInfo:nil, repeats: true)
                Model.marketDisabled = true
                Model.disasterCount += 1
                
            }
            )
            alert.addAction(ok)
            //recreates values for a new timer for the next disaster
            disasterWait = Double(arc4random_uniform(UInt32(5)))
            disasterWait *= 60
            //starts timer
            disasterTimer = Timer.scheduledTimer(timeInterval: self.disasterWait, target: self, selector: #selector(self.naturalDisaster), userInfo:nil, repeats: true)
            
            present(alert, animated: true, completion: nil)
            break
        default:
            break
        }
        
    }
    ///function to re enable upgrades if it was disabled from a disaster
    @objc func reEnableUpgrades(){
        Model.upgradesDisabled = false
        if (Model.isCooking == false){
            upgradesButton.isEnabled = true
        }
        
    }
    ///function to re enable the market if it was disabled from a disaster
    @objc func reEnableMarket(){
        Model.marketDisabled = false
        if (Model.isCooking == false){
            marketButton.isEnabled = true
        }
    }
    
}


