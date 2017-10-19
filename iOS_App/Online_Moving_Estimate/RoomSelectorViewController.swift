//
//  RoomSelectorViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/8/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit


class RoomSelectorViewController: UIViewController{
    
    //Member Variables
    var estimateSession : Estimate!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let viewController = segue.destination as? ViewController{
            
            print("test")
            let button = sender as! UIButton
            let roomSelection = button.titleLabel?.text
            
            // Set index of the selected room
            estimateSession.currentRoom = estimateSession.RoomNames.index(of: roomSelection!)!
            
            viewController.estimateSession = estimateSession
            viewController.roomName = roomSelection

            
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
