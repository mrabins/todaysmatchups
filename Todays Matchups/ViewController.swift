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

    
    @IBOutlet weak var pitcherImageLabel: UIImageView!
    @IBOutlet weak var batterImageLabel: UIImageView!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = FIRDatabase.database().reference()
        fetchData()
        
        pitcherImageLabel.backgroundColor = UIColor.brown
        batterImageLabel.backgroundColor = UIColor.darkGray
        
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector(("respondToSwipeGesture:")))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
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
                
                self.gameDate.text = todaysMatchup.result
                
                // Pitcher Data
                self.pitcherLabel.text = todaysMatchup.pitcher
                self.pitcherTeamID.text = todaysMatchup.pitcher_team_id
                
                // Batter Data
                self.batterLabel.text = todaysMatchup.batter
                self.batterTeamId.text = todaysMatchup.batter_team_id
                
                self.returnedData.append(todaysMatchup)

            }
            
        })
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        }
            
        
      
        
                

    }

}

