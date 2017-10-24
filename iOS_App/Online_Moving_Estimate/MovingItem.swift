//
//  MovingItem.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 9/21/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import Foundation

class MovingItem: NSCopying{
    
    //Member Variables
    var itemCategory : String
    var itemName : String
    var itemID: Int
    var relatedItemsIDs: [Int]
    var genericName : String?
    var needSpecification : Bool
    
    init(category: String, name: String, ID: Int, relatedItems: [Int], generic : String? = nil ){
        
        itemCategory = category
        itemName = name
        itemID = ID
        relatedItemsIDs = relatedItems
        genericName = generic?.capitalizingFirstLetter()
        
        relatedItemsIDs.append(itemID)
        
        if relatedItemsIDs.count > 1{
            needSpecification = true
        }else{
            needSpecification = false
        }
        
    }
    
    init(category: String, name: String, ID: Int, secondRelatedItems: [Int], generic : String? = nil ){
        
        itemCategory = category
        itemName = name
        itemID = ID
        relatedItemsIDs = secondRelatedItems
        genericName = generic
        
        if relatedItemsIDs.count > 1{
            needSpecification = true
        }else{
            needSpecification = false
        }
        
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let item = MovingItem(category: itemCategory, name: itemName, ID: itemID, secondRelatedItems: relatedItemsIDs, generic: genericName)
        return item
    }
    
    
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
