//
//  FinalScreenViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/12/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit

class FinalFurnitureCell: UITableViewCell{
    
    @IBOutlet weak var itemLabel: UILabel!

    @IBOutlet weak var subCategorytest: UILabel!
    
    @IBOutlet weak var subcategoryButton: UIButton!
}



class ItemCollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SubCategoryDelegate, EditDelegate {
    
    //Member Variables
    var estimateSession : Estimate!
    var tableController : FurnitureOverviewTableController?
    var selected : MovingItem?
    var needsSelection  = true
    var picToEdit : Picture?
    var observerRegistered = false
    //Outlets
    @IBOutlet weak var finalTableView: UITableView!
    @IBOutlet weak var getEstimateButton: UIButton!
    let name = Notification.Name("ImageRequestComplete")
    
    @IBOutlet weak var startOver: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Need to observer for updates to image recognition calls
        createObserver()
        
        getEstimateButton.layer.cornerRadius = 5
        startOver.layer.cornerRadius = 5
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Camera", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ItemCollectionViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav"), for: .default)
        
        //Set up the tableview data structure
        title = "All Items Captured"
        tableController = FurnitureOverviewTableController(pics: estimateSession.pictures)
        tableController?.drawList()
        self.needsSelection = (tableController?.needsSelection)!
        if self.needsSelection{
            getEstimateButton.isHidden = true
        }
        else{
            getEstimateButton.isHidden = false
        }
            
        }
    
    
    // Go back to the previous view
    func back(sender: UIBarButtonItem) {
        
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    //Set up observer in order to update screen when image recogition request completes
    func createObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(ItemCollectionViewController.refresh), name: name, object: nil)
    }
    
    
    
    // Define the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tableController?.getNumberOfRows(section: section))!
    }
    
    //Define the data for each row in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinalItemCall", for: indexPath ) as! FinalFurnitureCell
        
        //Do some math to store the location of an item when there are boths sections and rows within sections
        let location = (indexPath.section * 1000) + indexPath.row
        
        let furniture = (tableController?.getFurniture(location: location) )!
        
        
        cell.subcategoryButton.isHidden = false
        cell.subCategorytest.isHidden = false
        
        // Only display the subcategory selection buttons when it needs it
        if !(furniture.movingItem.needSpecification) {
          
            cell.subcategoryButton.isHidden = true
            cell.subCategorytest.isHidden = true
        }
        

        cell.itemLabel.text = furniture.name
        
        
        
        cell.subcategoryButton.tag = location
        return cell
    }
    
    //Determine number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return (tableController?.getNumberOfSections())!
    }
    
    //Set the hieght of each row in the table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    
    //Define the data for each section header in the table
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        let button = UIButton(frame: CGRect(x: 330, y: 5, width: 35, height: 35))
        button.tag = section
        button.setTitle("Edit", for: [])
        
        button.addTarget(self, action: #selector(ItemCollectionViewController.editPic(button:)), for: .touchDown)
        
        
        let label = UILabel()
        label.text = tableController?.getTitleForSection(section: section)
        label.textColor = UIColor.white
        label.frame = CGRect(x: 9, y: 5, width: 200, height: 35)
        view.addSubview(label)
        view.addSubview(button)
        
        return view
    }
    
    //When a user selects the edit button on a section header...
    func editPic(button: UIButton) {
        performSegue(withIdentifier: "edit", sender: button)
        
    }
    
    //Set the hieght of section headers
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set the selected item for subcategory selection
    @IBAction func ShowSubCategory(_ sender: UIButton) {
        
        let furniture = tableController?.getFurniture(location: sender.tag)
        
        selected = furniture?.movingItem
        
    }
    
    //Redraw table when image recognition results return
    func refresh() {
        
        print("ayyyy")

        tableController = FurnitureOverviewTableController(pics: estimateSession.pictures)
        tableController?.drawList()
        
        self.needsSelection = (tableController?.needsSelection)!
        if self.needsSelection{
            
            getEstimateButton.isHidden = true
        }
        else{
            
            getEstimateButton.isHidden = false
        }
        self.finalTableView.reloadData()
    }
    
    
    
    
    //Transfer data forward whenever segue to another screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
        if let viewController = segue.destination as? SubCategoryViewController{
            viewController.selected = selected
            viewController.estimateSession = estimateSession
            viewController.delegate = self
        }
        else if let viewController = segue.destination as? FinalEstimateViewController{
            
            
            viewController.estimateSession = estimateSession
            
        }
        else if let viewController = segue.destination as? RoomSelectorViewController{
            
            
            
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
        else if let viewController = segue.destination as? EditViewController{
            
            
            viewController.estimateSession = estimateSession
            viewController.delegate = self
            let button = sender as! UIButton
            viewController.currentPic = estimateSession.getPicure(count: button.tag)
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
