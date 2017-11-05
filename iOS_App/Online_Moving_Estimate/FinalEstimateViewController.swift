//
//  FinalEstimateViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 11/3/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit

class FinalEstimateViewController: UIViewController {
    
    //Member Variables
    var estimateSession : Estimate!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("test")
        estimateSession.getFinalEstimate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
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
