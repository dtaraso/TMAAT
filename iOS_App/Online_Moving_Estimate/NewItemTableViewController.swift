//
//  NewItemTableViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 11/27/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit

class newItemCell: UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!
    
}

protocol NewItemDelegate {
    func refreshTable()
}

class NewItemTableViewController: UITableViewController {
    
    //Member Variables
    var estimateSession : Estimate!
    var currentPic : Picture!
    var delegate: NewItemDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return estimateSession.fullList!.count
    }

    //Define data for each row in table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "new", for: indexPath ) as! newItemCell
        let item = estimateSession.fullList![indexPath.row]
        cell.name.text = item["name"] as! String
        cell.selectButton.tag = indexPath.row
        cell.selectButton.layer.cornerRadius = 5
        

        return cell
    }
    
    // Create new movingItem based on user selection
    @IBAction func addItemToList(_ sender: UIButton) {
        
        let itemElements = estimateSession.fullList![sender.tag] 
        
        let newItem = MovingItem(category: (itemElements["category"] as! String?)!, name: (itemElements["name"] as! String?)!, ID: itemElements["id"] as! Int, relatedItems: itemElements["relatedInCategory"] as! [Int], generic: (itemElements["generic"] as! String?)!)
        newItem.needSpecification = false
        currentPic.addItem(item: newItem)
        
        
        _ = navigationController?.popViewController(animated: true)
        delegate?.refreshTable()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
