//
//  WelcomeViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/2/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //Member Variables
    var estimateSession : Estimate!
    
    @IBOutlet weak var gotIT: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Grab list of all items from our server
        estimateSession.getFullList()
        
        gotIT.layer.cornerRadius = 5
        title = "Weclome!"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
        
        
        
    }
    
    //Send data forward when we move to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? RoomSelectorViewController{
            viewController.estimateSession = estimateSession
            
            var imageSet = [UIImage]()
            //Set up images for list of rooms
            for room in estimateSession.ImageNames{
                print(room)
                let image = UIImage(named: room)
                imageSet.append(image!)
                
            }
            
            viewController.imageSet = imageSet
            

        }
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
