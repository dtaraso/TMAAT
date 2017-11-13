//
//  EstimateIDViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/2/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit

class EstimateIDViewController: UIViewController {
    
    //Member Variables

    
    //Outlets
    @IBOutlet weak var ContinueButton: UIButton!
    @IBOutlet weak var estimateText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        estimateText.becomeFirstResponder()
        ContinueButton.layer.cornerRadius = 5
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav"), for: .default)
        // Do any additional setup after loading the view.
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if let welcomeViewController = segue.destination as? WelcomeViewController{
            welcomeViewController.estimateSession = Estimate(ID: estimateText.text!)
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
