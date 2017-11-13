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

    var pictures: [Picture]
    
    var Name: String!
    
    init(name: String){
        pictures = [Picture]()
        Name = name
        
    }
    
    func addPicture(count: Int) -> Picture{
        let pic = Picture(number: count, room: self)
        pictures.append(pic)
        
        return pic
    }
    
    
    
}
