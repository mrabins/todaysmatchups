//
//  ViewController.swift
//  Todays Matchups
//
//  Created by Mark Rabins on 10/28/16.
//  Copyright © 2016 self.edu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var returnedData = [DataModel]()
    var matchUps: [DataModel] = []
    
    var currentIndex = 0
    var completionHandler = false
    
    // Pitcher Properties
    @IBOutlet weak var pitcherLabel: UILabel!
    @IBOutlet weak var pitcherTeamID: UILabel!
    
    // Batter Propeties
    @IBOutlet weak var batterLabel: UILabel!
    @IBOutlet weak var batterTeamId: UILabel!
    
    // Game UI Properties
    @IBOutlet weak var inningLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var gameDate: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = FIRDatabase.database().reference()
        fetchData()
        
        view.backgroundColor = UIColor.brown
        
        view.isUserInteractionEnabled = true
        let theSelector : Selector = #selector(ViewController.tapFunc)
        let tapGesture = UITapGestureRecognizer(target: self, action: theSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        if completionHandler == false {
            
            // Game Data
            inningLabel.text = "8"
            resultLabel.text = "Fly Ball"
            gameDate.text = "2015-10-17"
            
            // Pitcher Data
            pitcherLabel.text = "Matt Harvey"
            pitcherTeamID.text = "Mets"
            
            // Batter Data
            batterLabel.text = "Kyle Schwarber"
            batterTeamId.text = "Cubs"
            
        } else {
            self.updateLabels(matchup: matchUps[currentIndex])
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        
        refHandle = ref.child("row").observe(.childAdded, with: {(snapshot) in
            if let todaysDict = snapshot.value as? [String: AnyObject] {
                
                print("I am this data \(todaysDict)")
                let todaysMatchup = DataModel()
                
                todaysMatchup.setValuesForKeys(todaysDict)
                print("I am todays Matchup \(todaysMatchup)")
                self.matchUps.append(todaysMatchup)
            }
            
        })
        if self.matchUps.isEmpty == true {
            completionHandler = false
        } else {
            self.updateLabels(matchup: matchUps[currentIndex])
        }
    }
    
    //TapGestureRecognizer
    func tapFunc() {
        currentIndex += 1
        self.updateLabels(matchup: matchUps[currentIndex])
    }
    
    func updateLabels(matchup: DataModel) {
        
        let todaysMatchUpNextIndex = [matchup]
        
        for item in todaysMatchUpNextIndex.enumerated().reversed() {
            print("I am a new item with \(item) and \(todaysMatchUpNextIndex)")
            
            
            inningLabel.text = item.element.inning
            
            print("NExt value is \(item.element.inning)")
            
            // Game Data
            inningLabel.text = matchup.inning
            gameDate.text = matchup.game_date
            resultLabel.text = self.removeSpecialCharsFromString(text: matchup.result!)
            
            // Pitcher Data
            pitcherLabel.text = matchup.pitcher
            pitcherTeamID.text = matchup.pitcher_team_abbrev
            
            // Batter Data
            batterLabel.text = matchup.batter
            batterTeamId.text = matchup.batter_team_abbrev
            
            returnedData.append(matchup)
            
            print("the next inning is \(matchup.inning)")
            
        }
        
    }
    
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set <Character> = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ 1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0 ) })
    }
    
}
