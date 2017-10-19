//
//  FinalScreenViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/12/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit

class FinalScreenViewController: UIViewController {
    
    //Member Variables
    var estimateSession : Estimate!
    
    //Outlets
    @IBOutlet weak var results: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        results.text = ""
        var restultsString = ""
        let rooms = estimateSession.rooms
        for room in rooms{
            if (room.itemsToMove.count != 0){
                restultsString = restultsString + room.Name + "\n\n"
            
                var names : [String:Int]
                names = [:]
                var nameToAdd: String
                for item in room.itemsToMove{
                    if (item.genericName != nil){
                        nameToAdd = item.genericName!
                    }
                    else{
                        nameToAdd = item.itemName
                    }
                    
                    if (names[nameToAdd] == nil){
                        names[nameToAdd] = 1
                    }
                    else{
                        names[nameToAdd] = names[nameToAdd]! + 1
                    }
                }
                print(names)
                for (name, count) in names{
                    restultsString =  restultsString + "\t"  + name + " x" + (count as NSNumber).stringValue + "\n\n"
                }
            
        }
            
        }
        print(restultsString)
        results.text = restultsString
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
