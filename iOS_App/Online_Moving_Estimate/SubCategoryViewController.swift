//
//  SubCategoryViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/20/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit

protocol SubCategoryDelegate {
    func refresh()
}

class SubCategoryCell: UITableViewCell{
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var chooseButton: UIButton!
    
}

class SubCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Member Variables
    var estimateSession : Estimate!
    var selected : MovingItem!
    var delegate: SubCategoryDelegate?
    var names = [Int : String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Select a subcategory and update the movingItem data memebers
    @IBAction func chooseCategory(_ sender: UIButton) {
        
        selected.genericName = names[sender.tag]
        selected.itemName = names[sender.tag]!
        selected.itemID = sender.tag
        selected.needSpecification = false
        
        //Refresh the view we are moving to
        delegate?.refresh()
        dismiss(animated: true, completion:nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Determine number of rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return (selected?.relatedItemsIDs.count)!
    }
    
    //Define data for rows in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Sub", for: indexPath ) as! SubCategoryCell

        let fullList = estimateSession.fullList
        let related = selected?.relatedItemsIDs[indexPath.row]
        for item in fullList!{
            
            // Only display items that are part of the set of related items associated with the item
            let ID = item["id"] as! Int
            if ID == related{
                cell.Name.text = item["name"] as! String
                names[ID] = item["name"] as! String
                cell.chooseButton.tag = ID
            }
            
            
            
            
        }
        
        
        
        return cell
    }
    
    //Define number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    //Define title header for the one section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Please Select an Item"
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
