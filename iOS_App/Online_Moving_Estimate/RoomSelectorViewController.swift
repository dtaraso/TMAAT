//
//  RoomSelectorViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 10/8/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit

class roomCell: UICollectionViewCell {
    
    @IBOutlet weak var theImage: UIImageView!
    
    @IBOutlet weak var roomName: UILabel!
    
}


class RoomSelectorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return estimateSession.ActualRoomNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = roomCollectionView.dequeueReusableCell(withReuseIdentifier: "room", for: indexPath) as! roomCell
        
        cell.theImage.image = imageSet![indexPath.item]
        cell.theImage.layer.cornerRadius = cell.theImage.frame.size.width / 2
        cell.theImage.clipsToBounds = true
        cell.roomName.text = estimateSession.RoomNames[indexPath.item]
        
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = self.roomCollectionView.cellForItem(at: indexPath)
        
        let room = estimateSession.RoomNames[indexPath.item]
        selected = room
        self.roomCollectionView.reloadData()
        performSegue(withIdentifier: "room", sender: Any?.self)
        cell?.layer.borderWidth = 0.0
        
        
    }
    
    
    
    
    //Member Variables
    var estimateSession : Estimate!
    var imageSet : [UIImage]?
    var selected : String?
    
    @IBOutlet weak var roomCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav"), for: .default)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let viewController = segue.destination as? CameraViewController{
            
            
            
            let roomSelection = selected
            
            // Set index of the selected room
            estimateSession.currentRoom = estimateSession.RoomNames.index(of: roomSelection!)!
            
            viewController.estimateSession = estimateSession
            viewController.roomName = roomSelection
            

            
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
