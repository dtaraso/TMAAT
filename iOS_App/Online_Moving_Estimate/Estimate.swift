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
    var RoomNames = ["Living Room", "Bedroom", "Kitchen", "Dining Room", "Home Office", "Garage", "Patio", "Business Office", "Business File Room", "Business Reception"]
    var ActualRoomNames = ["LivingRoom", "Bedroom", "Kitchen" , "DiningRoom", "Office", "Garage", "Patio", "BusinessOffice", "BusinessFileRoom", "BusinessReception"]
    var fullList : [[String: Any]]?
    
    init(ID: String){
        estimateID = ID
        rooms = [Room]()
        tempList = [MovingItem]()
        currentRoom = -1
        
        for name in ActualRoomNames{
            let newRoom = Room(name: name)
            rooms.append(newRoom)
        }
        
        self.getFullList()
        
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
    
    func getFullList(){
        let URI = "http://35.9.22.105:8555/api/getItems"
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
                
                
                
                let related = item["relatedInCategory"] as! [Int]
                let generic = item["generic"] as! String?
                newItem = MovingItem(category: category, name: name, ID: ID, relatedItems: related, generic: generic)
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
    
    func resetExceptID(){
        rooms = [Room]()
        tempList = [MovingItem]()
        currentRoom = -1
        
        for name in ActualRoomNames{
            let newRoom = Room(name: name)
            rooms.append(newRoom)
        }
    }
    
    func getFinalEstimate(){
        
        let URI = "https://mwc.test.twomen.com/mwcwebapi/estimate/addInventoryToEstimate"
        let serverURL = URL(string: URI)
        var request = URLRequest(url:serverURL!)
        request.httpMethod = "POST"
        
        let username = "msucapstone"
        let password = "Vf@tN7Ck"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        
        let task =  URLSession.shared.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            
            do{
                
                print(response)
                
            }catch{
                
                print("Whoops with the JSON")
                
            }
            
        })
        task.resume()
        
    }
    
    func createFinalEstimateRequestBody() -> Data{
        
      print("Not implemented")
      return [] as! Data
    }
    
    
    
    
    
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
