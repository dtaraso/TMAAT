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
    var rooms : [Room]
    var table : [(room :String, Furniture : [ FurnitureStruct ])]
    
    
    init(rooms : [Room]){
        self.rooms = rooms
        self.table = [(room :String, Furniture : [ FurnitureStruct ])]()
    }
    
    func drawList(){
        
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
                    }
                    else{
                        nameToAdd = item.itemName
                    }
                    
                    
                    table[room_count].Furniture.append(FurnitureStruct(name: nameToAdd, movingItem: item))
                    
                }
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
        return table[section].room
    }
    
    func getFurniture(location: Int) -> FurnitureStruct{
        
        let row = location % 1000
        let section = location / 1000
        
        return table[section].Furniture[row]
        
    }
    
    
    
    
    
    
    
   
    
}
