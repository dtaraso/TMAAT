//
//  Room.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/8/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import Foundation


class Room{
    
    //Member Variables
    var itemsToMove: [MovingItem]
    var Name: String!
    
    init(name: String){
        itemsToMove = [MovingItem]()
        Name = name
    }
    
    func addItem(item : MovingItem){
        itemsToMove.append(item)
    }
    
}