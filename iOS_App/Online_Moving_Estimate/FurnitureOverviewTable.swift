//
//  FurnitureOverviewTable.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/20/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import Foundation

internal struct FurnitureStruct{
    var name: String
    var movingItem : MovingItem
}

class FurnitureOverviewTableController{
    
    //Member Variables
    var pics : [Picture]
    var table : [(pic :String, Furniture : [ FurnitureStruct ])]
    var needsSelection = false
    
    
    init(pics : [Picture]){
        self.pics = pics
        self.table = [(pic :String, Furniture : [ FurnitureStruct ])]()
    }
    
    /*
    func drawList(){
        needsSelection = false
        table = [(room :String, Furniture : [ FurnitureStruct ])]()
        var room_count = -1
        
        
        for room in rooms{
            
            
            
            if room.itemsToMove.count > 0{
                room_count = room_count + 1
                table.append((room: room.Name, Furniture: []))
                var nameToAdd: String
                for (item) in room.itemsToMove{
                    if (item.needSpecification){
                        nameToAdd = item.genericName!
                        self.needsSelection = true
                    }
                    else{
                        nameToAdd = item.itemName
                    }
                    
                    
                    table[room_count].Furniture.append(FurnitureStruct(name: nameToAdd, movingItem: item))
                    
                }
            }
            
            
        }
        
        
    }
    */
    
    func drawList(){
        needsSelection = false
        table = [(pic :String, Furniture : [ FurnitureStruct ])]()
        var pic_count = -1
    
        
            
            for pic in pics{
                
                
                
                pic_count = pic_count + 1
                table.append((pic: "Image " + String(pic.number! + 1) + " - " + pic.room.Name, Furniture: []))
                var nameToAdd: String
                
                if !pic.doneLoading{
                    table[pic_count].Furniture.append(FurnitureStruct(name: "Loading...", movingItem: MovingItem(category: "none", name: "loading...", ID: -1, relatedItems: [Int]())))
                }
                else if pic.itemsToMove.count == 0{
                    table[pic_count].Furniture.append(FurnitureStruct(name: "No Items Detected", movingItem: MovingItem(category: "none", name: "no items detected", ID: -1, relatedItems: [Int]())))
                }
                
                    for item in pic.itemsToMove{
                        if (item.needSpecification){
                            nameToAdd = item.genericName!
                            self.needsSelection = true
                        }
                        else{
                            nameToAdd = item.itemName
                        }
                        
                        table[pic_count].Furniture.append(FurnitureStruct(name: nameToAdd, movingItem: item))
                        
                    }
                
            
    
        }
    
    
    
    }
    
    func getNumberOfRows(section: Int) -> Int{
        return table[section].Furniture.count
    }
    
    func getNumberOfSections() -> Int{
        return table.count
    }
    
    func getTitleForSection(section: Int) -> String{
        return table[section].pic
    }
    
    func getFurniture(location: Int) -> FurnitureStruct{
        
        let row = location % 1000
        let section = location / 1000
        
        return table[section].Furniture[row]
        
    }
    
    
    
    
    
    
    
   
    
}
