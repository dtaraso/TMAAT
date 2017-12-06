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
        
        // Append self to the list of related items
        relatedItemsIDs.append(itemID)
        
        // If there are not related items, we say this object does not need sub category specfication.
        if relatedItemsIDs.count > 1{
            needSpecification = true
        }else{
            needSpecification = false
        }
        
    }
    
    init(category: String, name: String, ID: Int, secondRelatedItems: [Int], generic : String? = nil, specification: Bool ){
        
        itemCategory = category
        itemName = name
        itemID = ID
        relatedItemsIDs = secondRelatedItems
        genericName = generic
        
        needSpecification = specification
        
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let item = MovingItem(category: itemCategory, name: itemName, ID: itemID, secondRelatedItems: relatedItemsIDs, generic: genericName, specification: needSpecification)
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

extension MovingItem: Equatable {
    static func == (lhs: MovingItem, rhs: MovingItem) -> Bool {
        return
            lhs.itemID == rhs.itemID &&
                lhs.needSpecification == rhs.needSpecification &&
                lhs.genericName == rhs.genericName
    }
}
