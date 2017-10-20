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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        estimateSession.getFullList()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? RoomSelectorViewController{
            viewController.estimateSession = estimateSession
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
