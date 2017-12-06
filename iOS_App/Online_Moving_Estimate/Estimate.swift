//
//  Estimate.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 9/21/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import Foundation

class Estimate: NSObject{
    
    //Member Variables
    var estimateID : String
    var rooms : [Room]
    var currentRoom: Int
    var tempList : [MovingItem]
    var picCount : Int
    var pictures : [Picture]
    var RoomNames = ["Living Room", "Bedroom", "Kitchen", "Dining Room", "Home Office", "Garage", "Patio", "Business Office", "Business File Room", "Business Reception"]
    var ActualRoomNames = ["LivingRoom", "Bedroom", "Kitchen" , "DiningRoom", "Office", "Garage", "Patio", "BusinessOffice", "BusinessFileRoom", "BusinessReception"]
    var ImageNames = ["LivingRoom", "Bedroom", "Kitchen", "DiningRoom", "Office", "Garage", "Patio", "BusinessOffice", "BusinessFileRoom", "BusinessReception"]
    var RoomIDs = ["3", "1", "2", "8", "9", "4", "17", "12", "13", "22"]
    var fullList : [[String: Any]]?
    var finalEstimate : String?
    
    //Initilize estimate class
    init(ID: String){
        
        
        estimateID = ID
        rooms = [Room]()
        pictures = [Picture]()
        tempList = [MovingItem]()
        currentRoom = -1
        picCount = 0
        
        //generate all rooms
        for name in ActualRoomNames{
            let newRoom = Room(name: name)
            rooms.append(newRoom)
        }
        
        super.init()
    
        self.getFullList()
        
    }
    
    // Send image to image recognition service to get item contents
    func postImage(image: Data) -> URLRequest{
        
        let URI = "http://35.9.22.105:1234/api/uploadImage" + "?room=" + getRoomName()
        
        let serverURL = URL(string: URI)
        
        
        var request = URLRequest(url:serverURL!)
        request.httpMethod = "POST"
        
        // Set boundary for multipart request
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithParameters(filePathKey: "file", imageDataKey: image, boundary: boundary)
        
        
        return request
        
        
    }
    
    // Get list of all items from API (for later use)
    func getFullList(){
        let URI = "http://35.9.22.105:1234/api/getItems"
        let serverURL = URL(string: URI)
        var request = URLRequest(url:serverURL!)
        request.httpMethod = "GET"
        
        let task =  URLSession.shared.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            
            do{
                
                let json = try JSONSerialization.jsonObject(with: data!) as! [[String: Any]]
                
               self.fullList = json
                
            }catch{
                print("Whoops with the JSON")

            }

        })
        task.resume()
        
    }
    
    // Parse the JSON recieved from image recogntion service
    func parseJson(json: [[String: Any]], pic: Picture){
        
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
                
                
                
                let related = item["relatedInCategory"] as! [Int]
                let generic = item["generic"] as! String?
                
                //Create moving items based on JSON results
                newItem = MovingItem(category: category, name: name, ID: ID, relatedItems: related, generic: generic)
                pic.addItem(item: newItem!)
                

                
            }
        }
        
    }
    
    //Create the body of image data for image recogntion request
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
    

    //When an image is captured, create a picture object to hold data
    func createPicture() -> Picture{
        let room = getRoom()
        let pic = room.addPicture(count: picCount)
        pictures.append(pic)
        picCount = picCount + 1
        return pic
    }
    
    // For retaking a picture, replace a picture the contents of a new picture
    func replacePic(pic: Picture) -> Picture{
        let room = pic.room
        let new_pic = Picture(number: pic.number!, room: room)
        let pic_index_in_room = room.pictures.index(of: pic)
        let pic_index_in_estimate = pictures.index(of: pic)
        
        pictures[pic_index_in_estimate!] = new_pic
        room.pictures[pic_index_in_room!] = new_pic
        
        return new_pic
    }
    
    // Delete a picture from the estimate picture list
    func deletePic(pic: Picture){
        let room = pic.room
        let pic_index_in_room = room.pictures.index(of: pic)
        let pic_index_in_estimate = pictures.index(of: pic)
        
        pictures.remove(at: pic_index_in_estimate!)
        room.pictures.remove(at: pic_index_in_room!)
    }
    
    
    func getPicure(count: Int) -> Picture{
        return pictures[count]
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
    
    //Reset the estimateSession, but leave the estimate ID in tact
    func resetExceptID(){
        rooms = [Room]()
        tempList = [MovingItem]()
        picCount = 0
        pictures = [Picture]()
        
        currentRoom = -1
        
        
        for name in ActualRoomNames{
            let newRoom = Room(name: name)
            rooms.append(newRoom)
        }
    }
    
    
    // Get a final estimate from TWO MEN AND A TRUCK'S API
    func getFinalEstimateRequest() -> URLRequest{
        
        let URI = "https://mwc.test.twomen.com/mwcwebapi/estimate/addInventoryToEstimate"
        let serverURL = URL(string: URI)
        var request = URLRequest(url:serverURL!)
        request.httpMethod = "POST"
        
        let username = "twomen\\msucapstone"
        let password = "Vf@tN7Ck"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = createEstimateBody()
        
        return request
        
        
        
    }
    
    
    
    // Create the body that lists rooms and moving items for the final estimate API request
    func createEstimateBody() -> Data?{
        
        
        var rooms_body = [[String: Any]]()
        
        for (idx, room) in rooms.enumerated(){
            
            for pic in room.pictures{
                
                if pic.itemsToMove.count < 1{
                    continue
                }
                var items_body = [[String: Int]]()
                
                for item in pic.itemsToMove{
                    
                    updateQuant(items: &items_body, itemID: item.itemID)
                    
                    
                }
                
                let room_entry = ["id": RoomIDs[idx], "name": ActualRoomNames[idx], "items": items_body] as [String : Any]
                rooms_body.append(room_entry)
                
                
            }
            

            
        }
        
        let body = ["estimateid": self.estimateID, "rooms":rooms_body] as [String : Any]
        print(body)
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            return jsonData
        }catch{
            print("could not create estimate body")
            return nil
        }
        
     
    }
    
    //Helper function to createEstimateBody() that handles updating the counts if items in the JSON
    func updateQuant(items: inout [[String:Int]], itemID: Int){
        var found = false
        
        for (idx,item) in items.enumerated(){
            let id = item["id"]
            
            if id == itemID{
                items[idx]["quantity"] = items[idx]["quantity"]! + 1
                found = true
            }
        }
        
        if (!found){
            let entry = ["id":itemID, "quantity": 1]
            items.append(entry)
        }
     
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
