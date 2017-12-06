//
//  ImageConfirmationViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/8/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit

class FurnitureCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    
}

protocol EditDelegate {
    func refresh()
}

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RetakeDelegate, NewItemDelegate{
    
    
    
    //Member Variables
    var estimateSession : Estimate!
    var currentPic : Picture!
    var names = [(name: String, value: Int, movingItem: MovingItem?, index: Int)]()
    var delegate: EditDelegate?
    var observerRegistered : Bool?
    let name = Notification.Name("ImageRequestComplete")
    
    //Outlets
    @IBOutlet weak var furnTableView: UITableView!
    
    //Check if item is already in dict of item names
    func checkIfInNames(name: String) -> Int{
        for (i,n) in names.enumerated(){
            if (n.name == name){
                return i
            }
        }
        return -1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Need to set up an observer in case an image recongtion request completes when are on this screen
        createObserver()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav"), for: .default)
        
        title = "items"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        setUp()
        
        
 
        
    }
    
    //Need to update screen when image recognition reuqests come in
    func createObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.refreshTable), name: name, object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    //Generate data stcuture we use to fill the table view with moving items
    func setUp(){
        // Names represents the name and associated data of moving items for the table
        names = [(name: String, value: Int, movingItem: MovingItem?, index: Int)]()
        var nameToAdd: String
        
        // Display loading if the items for the picture have not been reteurned yet
        if !currentPic.doneLoading{
            names.append((name: "Loading...", value: 0, movingItem: nil, index: 0))
        }
        // If there are no items associated with the picture, say no items detected
        else if currentPic.itemsToMove.count == 0{
            names.append((name: "No Items Detected", value: 0, movingItem: nil, index: 0))
        }
        // If there are items, move through items to format data for table
        else{
            for (i,item) in currentPic.itemsToMove.enumerated(){
                if (item.needSpecification){
                    nameToAdd = item.genericName!
                }
                else{
                    nameToAdd = item.itemName
                }
                let index = checkIfInNames(name: nameToAdd)
                if index != -1{
                    names[index].value = names[index].value + 1
                }
                else{
                    names.append((name: nameToAdd, value: 1, movingItem: item, index: i))
                }
            }
        }
    }
    
    //Re-draw the screen
    func refresh(pic: Picture) {
        print("test")
        self.currentPic = pic
        
        setUp()
        
        self.furnTableView.reloadData()
    }
    
    
    //re-draw but don't change the current picture
    func refreshTable(){
        
        setUp()
        self.furnTableView.reloadData()
    }
    
    
    // Determine number of rows in a section for table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    // Determine data for each row in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath ) as! FurnitureCell
        let item = names[indexPath.row]
        cell.nameLabel.text = item.name
        cell.incrementButton.tag = indexPath.row
        cell.decrementButton.tag = indexPath.row
        cell.countLabel.text = String(item.value)
        return cell
    }
    
    //Determine number of sections in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Determine title of sections in table view
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Detected Items"
    }
    
    
    
    //Confirm user changes to editing the image (ie just move to previous screen)
    @IBAction func ConfirmChanges(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)
        delegate?.refresh()
    }
    
    
    //increase the count of the selected item in estimate
    @IBAction func incrementCount(_ sender: UIButton) {
        if checkIfInNames(name: "No Items Detected") == -1{
            let old = names[sender.tag].movingItem
            let new = old?.copy() as! MovingItem
            currentPic.itemsToMove.append(new)
            names[sender.tag].value = names[sender.tag].value + 1
            self.furnTableView.reloadData()
        }
        
        
        
        
    }
    //decrease the count of the selected item in estimate
    @IBAction func decrementCount(_ sender: UIButton) {
        if names[sender.tag].value > 0 && checkIfInNames(name: "No Items Detected") == -1{
            let toDelete = names[sender.tag].movingItem
            let index = currentPic.itemsToMove.index(of:toDelete!)
            currentPic.itemsToMove.remove(at: index!)
            names[sender.tag].value = names[sender.tag].value - 1
            self.furnTableView.reloadData()
        }
        
    }
    
    //Delete the image and all its items. 
    @IBAction func deleteImage(_ sender: Any) {
        
        estimateSession.deletePic(pic: currentPic)
        _ = navigationController?.popViewController(animated: true)
        delegate?.refresh()
        
    }
    
    
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    // Send data forward when moving to another screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if let viewController = segue.destination as? ItemCollectionViewController{
            
            
            
            viewController.estimateSession = estimateSession
            
        }
        
        if let viewController = segue.destination as? RetakeViewController{
            
            viewController.estimateSession = estimateSession
            viewController.currentPic = currentPic
            viewController.delegate = self
            
            
            
            
        }
        
        if let viewController = segue.destination as? NewItemTableViewController{
            viewController.estimateSession = estimateSession
            viewController.currentPic = currentPic
            viewController.delegate = self
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
