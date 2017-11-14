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

class ImageConfirmationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RetakeDelegate {
    
    
    
    //Member Variables
    var estimateSession : Estimate!
    var currentPic : Picture!
    var names = [(name: String, value: Int, movingItem: MovingItem?, index: Int)]()
    var delegate: EditDelegate?
    var observerRegistered : Bool?
    let name = Notification.Name("ImageRequestComplete")
    
    //Outlets
    @IBOutlet weak var furnTableView: UITableView!
    
    
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
        
        createObserver()
        
        
        
        
    
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav"), for: .default)
        
        title = "items"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        setUp()
        
        
 
        
    }
    
    func createObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(ImageConfirmationViewController.refreshTable), name: name, object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    
    func setUp(){
        names = [(name: String, value: Int, movingItem: MovingItem?, index: Int)]()
        var nameToAdd: String
        if !currentPic.doneLoading{
            names.append((name: "Loading...", value: 0, movingItem: nil, index: 0))
        }
        else{
            for (i,item) in currentPic.itemsToMove.enumerated(){
                if (item.genericName != nil){
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
    
    func refresh(pic: Picture) {
        print("test")
        self.currentPic = pic
        
        setUp()
        
        self.furnTableView.reloadData()
    }
    
    func refreshTable(){
        
        setUp()
        self.furnTableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath ) as! FurnitureCell
        let item = names[indexPath.row]
        cell.nameLabel.text = item.name
        cell.incrementButton.tag = indexPath.row
        cell.decrementButton.tag = indexPath.row
        cell.countLabel.text = String(item.value)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Detected Items"
    }
    
    
    
    
    @IBAction func ConfirmChanges(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)
        delegate?.refresh()
    }
    
    
    
    @IBAction func incrementCount(_ sender: UIButton) {
 
        let old = names[sender.tag].movingItem
        let new = old?.copy() as! MovingItem
        currentPic.itemsToMove.append(new)
        names[sender.tag].value = names[sender.tag].value + 1
        self.furnTableView.reloadData()
        
        
        
    }
    
    @IBAction func decrementCount(_ sender: UIButton) {
        let toDelete = names[sender.tag].movingItem
        let index = currentPic.itemsToMove.index(of:toDelete!)
        currentPic.itemsToMove.remove(at: index!)
        names[sender.tag].value = names[sender.tag].value - 1
        self.furnTableView.reloadData()
    }
    
    
    @IBAction func deleteImage(_ sender: Any) {
        
        estimateSession.deletePic(pic: currentPic)
        _ = navigationController?.popViewController(animated: true)
        delegate?.refresh()
        
    }
    
    
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if let viewController = segue.destination as? FinalScreenViewController{
            
            
            
            viewController.estimateSession = estimateSession
            
        }
        
        if let viewController = segue.destination as? RetakeViewController{
            
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
