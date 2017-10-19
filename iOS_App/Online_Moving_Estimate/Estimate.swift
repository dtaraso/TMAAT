//
//  Estimate.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 9/21/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import Foundation

class Estimate{
    
    //Member Variables
    var estimateID : String
    var rooms : [Room]
    var currentRoom: Int
    var tempList : [MovingItem]
    var RoomNames = ["Living Room", "Bedroom", "Dining Room", "Home Office", "Garage", "Patio", "Business Office", "Business File Room", "Business Reception"]
    var ActualRoomNames = ["LivingRoom", "Bedroom", "DiningRoom", "Office", "Garage", "Patio", "BusinessOffice", "BusinessFileRoom", "BusinessReception"]
    
    init(ID: String){
        estimateID = ID
        rooms = [Room]()
        tempList = [MovingItem]()
        currentRoom = -1
        
        for name in ActualRoomNames{
            let newRoom = Room(name: name)
            rooms.append(newRoom)
        }
        
    }
    
    func confirmItems(){
        
        for item in tempList{
            addItem(item: item)
        }
        tempList = []
    }
    
    func postImage(image: Data) -> URLRequest{
        
        let URI = "http://35.9.22.105:8555/api/uploadImage" + "?room=" + getRoomName()
        
        let serverURL = URL(string: URI)
        
        
        var request = URLRequest(url:serverURL!)
        request.httpMethod = "POST"
        
        // Set boundary for multipart request
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithParameters(filePathKey: "file", imageDataKey: image, boundary: boundary)
        
        
        return request
        
        
    }
    
    func parseJson(json: [[String: Any]]){
        
        if (json.count == 0){
            return
        }
        else{
            print(json)
            for item in json{
                let newItem : MovingItem?
                let category = item["category"] as! String
                let name = item["name"] as! String
                let ID = item["id"] as! Int
                
                
                if (item["related"] != nil && item["generic"] != nil){
                    let related = nil as [Int]?
                    let generic = item["generic"] as! String?
                    newItem = MovingItem(category: category, name: name, ID: ID, relatedItems: related, generic: generic)
                }
                else{
                    newItem = MovingItem(category: category, name: name, ID: ID)
                }
                
                
                tempList.append(newItem!)
                
            }
        }
        
    }
    
    func createBodyWithParameters(filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData();
        
        let filename = "furnatureImage.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body as Data
    }
    
    func addItem(item : MovingItem){
        rooms[currentRoom].addItem(item: item)
    }
    
    func addRoom(room: Room){
        rooms.append(room)
        currentRoom = currentRoom + 1
    }
    
    func getRoomName() -> String{
        return rooms[currentRoom].Name
    }
    
    func getRoom() -> Room{
        return rooms[currentRoom]
    }
    
    func getRoomNames() -> [String]{
        return RoomNames
    }
    
    
    
    
    
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
