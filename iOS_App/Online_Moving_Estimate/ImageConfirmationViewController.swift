//
//  ImageConfirmationViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/8/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit

class ImageConfirmationViewController: UIViewController {
    
    //Member Variables
    var estimateSession : Estimate!
    
    
    //Outlets
    @IBOutlet weak var results: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        results.text = ""
        
        var names : [String:Int]
        names = [:]
        var nameToAdd: String
        for item in estimateSession.tempList{
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
        
        
        if (names.count == 0){
            results.text = "No items detected!"
        }
        else{
            for (name, count) in names{
                results.text = results.text + name + " x" + (count as NSNumber).stringValue + "\n"
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Retake(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
    
    
    @IBAction func Confirm(_ sender: Any) {
        
        estimateSession.confirmItems()
        dismiss(animated: true, completion:nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? FinalScreenViewController{
            estimateSession.confirmItems()
            viewController.estimateSession = estimateSession
        }
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
