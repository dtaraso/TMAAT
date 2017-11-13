//
//  Picture.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 11/9/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import Foundation


class Picture{
    
    var itemsToMove: [MovingItem]
    var number : Int?
    var doneLoading = false;
    var room: Room
    
    init(number: Int, room: Room){
        itemsToMove = [MovingItem]()
        self.number = number
        self.room = room
    }
    
    func addItem(item : MovingItem){
        itemsToMove.append(item)
    }
    
}

extension Picture: Equatable {
    static func == (lhs: Picture, rhs: Picture) -> Bool {
        return
            lhs.number == rhs.number
    }
}
