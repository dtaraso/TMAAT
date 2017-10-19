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
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var subcategoryButton: UIButton!
}

internal struct FurnitureStruct{
    var name: String
    var value: Int
    var movingItem : MovingItem
    var index : Int
}

class FinalScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Member Variables
    var estimateSession : Estimate!
    var names = [(room: Room, item : FurnitureStruct)]()
    var nonEmptyRooms = [Room]()
    
    //Outlets
    @IBOutlet weak var finalTableView: UITableView!
    
    func checkIfInNames(room: Room, name: String) -> Int{
        for (i,n) in names.enumerated(){
            if (n.room.Name == room.Name && n.item.name == name){
                return i
            }
        }
        return -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rooms = estimateSession.rooms
        for room in rooms{
            if(room.itemsToMove.count > 0){
                nonEmptyRooms.append(room)
            }
        }

        for room in rooms{
            
            var nameToAdd: String
            for (i,item) in room.itemsToMove.enumerated(){
                if (item.genericName != nil){
                    nameToAdd = item.genericName!
                }
                else{
                    nameToAdd = item.itemName
                }
                let index = checkIfInNames(room: room, name: nameToAdd)
                if index != -1{
                    names[index].item.value = names[index].item.value + 1
                }
                else{
                    names.append((room, FurnitureStruct(name: nameToAdd, value: 1, movingItem: item, index: i)))
                }
            }
            
        }
            
        }
    
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rooms = estimateSession.rooms
        let room_name = nonEmptyRooms[section].Name
        var row_number = 0
        for entry in names{
            if entry.room.Name == room_name{
                row_number = row_number + 1
            }
        }
        return row_number
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinalItemCall", for: indexPath ) as! FinalFurnitureCell
        let furniture = names[indexPath.row]
        if (furniture.item.movingItem.genericName == nil){
            cell.subcategoryButton.isHidden = true
        }
        cell.itemLabel.text = furniture.item.name
        cell.countLabel.text = String(furniture.item.value)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return nonEmptyRooms.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nonEmptyRooms[section].Name
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
