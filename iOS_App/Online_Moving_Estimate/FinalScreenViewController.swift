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



class FinalScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SubCategoryDelegate, EditDelegate {
    
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
        

        createObserver()
        
        getEstimateButton.layer.cornerRadius = 5
        startOver.layer.cornerRadius = 5
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Camera", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FinalScreenViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav"), for: .default)
        
        
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
    
    
    
    func back(sender: UIBarButtonItem) {
        
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func createObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(FinalScreenViewController.refresh), name: name, object: nil)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tableController?.getNumberOfRows(section: section))!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinalItemCall", for: indexPath ) as! FinalFurnitureCell
        let location = (indexPath.section * 1000) + indexPath.row
        let furniture = (tableController?.getFurniture(location: location) )!
        
        
        cell.subcategoryButton.isHidden = false
        cell.subCategorytest.isHidden = false
        
        if !(furniture.movingItem.needSpecification) {
          
            cell.subcategoryButton.isHidden = true
            cell.subCategorytest.isHidden = true
        }
        

        cell.itemLabel.text = furniture.name
        
        
        
        cell.subcategoryButton.tag = location
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return (tableController?.getNumberOfSections())!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        let button = UIButton(frame: CGRect(x: 330, y: 5, width: 35, height: 35))
        button.tag = section
        button.setTitle("Edit", for: [])
        
        button.addTarget(self, action: #selector(FinalScreenViewController.editPic(button:)), for: .touchDown)
        
        
        let label = UILabel()
        label.text = tableController?.getTitleForSection(section: section)
        label.textColor = UIColor.white
        label.frame = CGRect(x: 9, y: 5, width: 200, height: 35)
        view.addSubview(label)
        view.addSubview(button)
        
        return view
    }
    
    func editPic(button: UIButton) {
        performSegue(withIdentifier: "edit", sender: button)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ShowSubCategory(_ sender: UIButton) {
        
        let furniture = tableController?.getFurniture(location: sender.tag)
        
        selected = furniture?.movingItem
        
    }
    
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
        else if let viewController = segue.destination as? ImageConfirmationViewController{
            
            
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
