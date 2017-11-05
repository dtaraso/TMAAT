//
//  Shared.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/2/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import Foundation

final class Shared {
    static let shared = Shared() //lazy init, and it only runs once
    
    var stringValue : Estimate?
}
