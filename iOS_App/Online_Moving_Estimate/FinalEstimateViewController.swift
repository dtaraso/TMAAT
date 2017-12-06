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
    var estimateCost : Float?
    @IBOutlet weak var estimateAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        estimateAmount.text = "Loading..."
        performFinalEstimate()
        
        // Do any additional setup after loading the view.
    }
    
    
    func performFinalEstimate(){
        let request = estimateSession.getFinalEstimateRequest()
        
        let task =  URLSession.shared.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                
                let finalEsimateCost = json!["totalCost"] as! Float
                self.estimateCost = finalEsimateCost
                
                DispatchQueue.main.async {
                    self.estimateAmount.text = "$" + "56"
                }
            }catch{
                
                print("Whoops with the JSON")
                self.estimateCost = nil
                
            }
            
        })
        task.resume()
        
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewController = segue.destination as? RoomSelectorViewController{
            estimateSession.resetExceptID()
            viewController.estimateSession = estimateSession
            
            var imageSet = [UIImage]()
            for room in estimateSession.ImageNames{
                print(room)
                let image = UIImage(named: room)
                imageSet.append(image!)
                
            }
            
            viewController.imageSet = imageSet
            
            
            
            
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
