//
//  MovingItem.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 9/21/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import Foundation

class MovingItem{
    
    //Member Variables
    var itemCategory : String
    var itemName : String
    var itemID: Int
    var relatedItemsIDs: [Int]?
    var genericName : String?
    
    init(category: String, name: String, ID: Int, relatedItems: [Int]? = nil, generic : String? = nil ){
        
        itemCategory = category
        itemName = name
        itemID = ID
        relatedItemsIDs = relatedItems
        genericName = generic
        
    }
    
}
