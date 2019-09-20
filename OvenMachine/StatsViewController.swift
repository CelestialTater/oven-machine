//
//  StatsViewController.swift
//  OvenMachine
//
//  Created by student on 2019-02-07.
//  Copyright © 2019 Cole Dewis. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    var model: Model!
    var calc: Double = 0

    @IBOutlet weak var clearData: UIButton!
    @IBOutlet weak var statsBox: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var helpButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = Model();
        clearData.isHidden = true
        clearData.isEnabled = false
        statsBox.isUserInteractionEnabled = false
        
        if (Food.totalCooked > 200){
            Model.canRebirth = true
            clearData.isEnabled = true
            clearData.isHidden = false
        }
        
        //Set up view for stats
        statsBox.text = "FOOD STATS:\n"
        statsBox.text = statsBox.text + "Total Items Cooked: \(Food.totalCooked) \nCurrent Items Cooked: \(Model.currentCooked)\n"
        
        //adds a line of text for each food in the cookbook
        for i:Food in Model.cookbook{
        statsBox.text = statsBox.text + "Current \(i.getName()) Cooked: \(i.getAmountCooked())\n"
        }
        
        //adds money line
        statsBox.text = statsBox.text + "\nMISC STATS:\n"
        statsBox.text = statsBox.text + "Money: \(Model.money)\n"
        statsBox.text = statsBox.text + "Oven Shelves: \(UpgradesViewController.shelves)\n"
        
        statsBox.text = statsBox.text + "Disasters Survived: \(Model.disasterCount)\n"
        if Model.attemptCount > 0 {
            calc = Double(Model.successCount) / Double(Model.attemptCount) * 100
            statsBox.text = statsBox.text + "Success Rate: \(calc.rounded())%\n"
        }
        
        statsBox.text = statsBox.text + "\nRAMSAY's REVIEWS:\n"
        //sets ramsay's review and chef rank based on amount of food cooked
        switch Food.totalCooked{
        case 0...25:
            statsBox.text = statsBox.text + "Rank: Bad\nRamsay Says: Absolutely Disgusting"
            break
        case 26...50:
            statsBox.text = statsBox.text + "Rank: Still Bad\nRamsay Says: Horrid"
            break
        case 51...75:
            statsBox.text = statsBox.text + "Rank: Mediocre\nRamsay Says: Where's the Lamb Sauce???"
            break
        case 76...100:
            statsBox.text = statsBox.text + "Rank: Home Cook\nRamsay Says: r o t t e n"
            break
        case 101...125:
            statsBox.text = statsBox.text + "Rank: Sous Chef\nRamsay Says: Is it frozen?"
            break
        case 126...150:
            statsBox.text = statsBox.text + "Rank: Chef\nRamsay Says: It's raW"
            break
        case 151...175:
            statsBox.text = statsBox.text + "Rank: Head Chef\nRamsay Says: Quite nice"
            break
        case 176...200:
            statsBox.text = statsBox.text + "Rank: Master Chef\nRamsay Says: good job"
            break
        default:
            statsBox.text = statsBox.text + "Rank: You beat the game!\nRamsay Says: Congratulations! You now can Rebirth!\n\n"
            //checks if you have purchased all foods and gotten a 10/10 rating on all of them. If so, displays secret ending
                if Model.bananaBreadPurchased && Model.lasagnaPurchased && Model.pizzaPurchased {
                    if Model.cookbook[0].rating == 10 && Model.cookbook[1].rating == 10 && Model.cookbook[2].rating == 10 && Model.cookbook[3].rating == 10 && Model.cookbook[4].rating == 10 && Model.cookbook[5].rating == 10{
                        self.statsBox.text = statsBox.text + "CONGRATULATIONS! YOU REACHED THE SECRET ENDING! Thank you for playing! As reward, your rebirth has been buffed significantly."
                    }
                }
            
            break
            
        }
        //displays help if first load
        if Model.statsFirstLoad == true{
            //creates alert
            let alert = UIAlertController(title: "Welcome!", message: "Welcome to Stats! Here you can view your money, what food you have cooked, and your rank! You can also rebirth here, but only after beating the game.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            //present for user input
            present(alert, animated: true, completion: nil)
            Model.statsFirstLoad = false
            
        }
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //Clears data
    @IBAction func clearDataAction(_ sender: Any) {
        //creates alert
        let alert = UIAlertController(title: "Rebirth", message: "Are you sure you want to reset your game data? Doing this will set you back to the start, but with each food with a higher starting sell price.", preferredStyle: .alert)
        
        //cancel + ok buttons.
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (_)in
            //if all foods purchased and all foods 10/10 rating, increases rebirth count even more.
            if Model.bananaBreadPurchased && Model.lasagnaPurchased && Model.pizzaPurchased {
                if Model.cookbook[0].rating == 10 && Model.cookbook[1].rating == 10 && Model.cookbook[2].rating == 10 && Model.cookbook[3].rating == 10 && Model.cookbook[4].rating == 10 && Model.cookbook[5].rating == 10{
                    Model.rebirthCount += 7
                }
            }
            //resets the amount cooked totals
            for i:Food in Model.cookbook{
                i.setAmountCooked(0)
            }
            
            //initiates rebirth
            Model.canRebirth = false
            Model.rebirthCount += 1
            
            //resets all the values of the foods to default, increasing the sellprice by the rebirth count
            Model.cookbook[0].cookTime = 8
            Model.cookbook[1].cookTime = 5
            Model.cookbook[2].cookTime = 10
            
            Model.cookbook[0].upgradePrice = 7
            Model.cookbook[1].upgradePrice = 5
            Model.cookbook[2].upgradePrice = 9
            
            Model.cookbook[0].sellPrice = 8
            Model.cookbook[0].sellPrice += Model.rebirthCount
            Model.cookbook[1].sellPrice = 3.50
            Model.cookbook[1].sellPrice += Model.rebirthCount
            Model.cookbook[2].sellPrice = 10.25
            Model.cookbook[2].sellPrice += Model.rebirthCount
            
            Model.cookbook[0].defaultSellPrice = 8
            Model.cookbook[0].defaultSellPrice += Model.rebirthCount
            Model.cookbook[1].defaultSellPrice = 3.50
            Model.cookbook[1].defaultSellPrice += Model.rebirthCount
            Model.cookbook[2].defaultSellPrice = 10.25
            Model.cookbook[2].defaultSellPrice += Model.rebirthCount
            
            Model.cookbook[0].rating = 1.0
            Model.cookbook[1].rating = 1.0
            Model.cookbook[2].rating = 1.0
            
            //resets upgrade values
            Model.doGameReset = true
            Model.speedUpgradePrice = 50
            Model.sellUpgradePrice = 75
            Model.shelfUpgradePrice = 300
            Food.totalCooked = 0
            Model.bananaBreadPurchased = false
            Model.lasagnaPurchased = false
            Model.pizzaPurchased = false
            
            //removes foods that must be purchased from cookbook
            switch Model.cookbook.count{
            case 6:
                Model.cookbook.remove(at: 5)
            case 5:
                Model.cookbook.remove(at: 4)
            case 4:
                Model.cookbook.remove(at: 3)
            default:
                break
            }
            
            //resets money
            Model.money = 0
            //dismisses segue
            self.navigationController?.popToRootViewController(animated: true)
        }
        )
        alert.addAction(cancel)
        alert.addAction(ok)
        
        //present for user input
        present(alert, animated: true, completion: nil)
    }
    //dismisses segue
    @IBAction func Dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //displays the help that was present upon first load of each screen
    @IBAction func Help(_ sender: Any) {
        let alert = UIAlertController(title: "Help", message: "Kitchen: Here you can cook food. Press 'info' for information on the food you have selected. Use the picker to select a food, then start cooking by pressing 'cook'. Click the buttons in the corners to navigate to other menus. \n \n Market: Here you can sell your food. The current desired food will sell for more money, and hated food will sell for less. Variety is key if you want to please the buyers! \n Select the food you want to sell with the picker, use + and - to control amount, and then press sell. \n \n Upgrades: Here you can purchase new recipies, and upgrade the ones you already have. The picker at the bottom is for rating upgrades. Select the food you want to upgrade and then press upgrade. \n \n Stats: Here you can view your money, what food you have cooked, and your rank! You can also rebirth here, but only after beating the game.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        //present for user input
        present(alert, animated: true, completion: nil)
    }
}
