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
        
        view.backgroundColor = UIColor.gray
        view.isUserInteractionEnabled = true
        let theSelector : Selector = #selector(ViewController.tapFunc)
        let tapGesture = UITapGestureRecognizer(target: self, action: theSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
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
                
                // Game Data
                self.inningLabel.text = todaysMatchup.inning
                
                self.gameDate.text = todaysMatchup.game_date
                
                
                self.resultLabel.text = self.removeSpecialCharsFromString(text: todaysMatchup.result!)
                
                // Pitcher Data
                self.pitcherLabel.text = todaysMatchup.pitcher
                self.pitcherTeamID.text = todaysMatchup.pitcher_team_abbrev
                
                // Batter Data
                self.batterLabel.text = todaysMatchup.batter
                self.batterTeamId.text = todaysMatchup.batter_team_abbrev
                
                self.returnedData.append(todaysMatchup)
                
                
                
            }
            
        })
        
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set <Character> = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ 1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0 ) })
    }
    
        
        
    }
    
}





