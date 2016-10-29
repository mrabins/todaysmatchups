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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = FIRDatabase.database().reference()
        fetchData()
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
                
                
                self.returnedData.append(todaysMatchup)

                //            DispatchQueue.main.async {
                //                self.tableView.reloadData()
                //            }
                
            }
            
        })
        
    }

}

