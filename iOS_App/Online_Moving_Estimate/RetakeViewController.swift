//
//  RetakeViewController.swift
//  Online_Moving_Estimate
//
//  Created by Team Two Men And A Truck on 11/9/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit
import AVFoundation

protocol RetakeDelegate {
    func refresh(pic: Picture)
}

class RetakeViewController: UIViewController {
    
    //Members
    var estimateSession : Estimate!
    var currentPic : Picture!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var delegate: RetakeDelegate?
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var takePhoto: UIButton!
    

    override func viewWillAppear(_ animated: Bool) {
        
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        

        // Use default camera (back camera)
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            //create capture session and sepcialize the device
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            // Set up preview layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            
            //let orientation = UIDevice.current.orientation
            //videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue)!
            
            cameraView.layer.addSublayer(videoPreviewLayer!)
            
            //begin capture session
            captureSession?.startRunning()
            
            //setup camera output
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = false
            
            captureSession?.addOutput(capturePhotoOutput)
            
            
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = false
        photoSettings.flashMode = .auto
        
        // Call capturePhoto method by passing our photo settings and a
        // delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            print("Landscape")
            takePhoto.transform = self.takePhoto.transform.rotated(by: CGFloat(Double.pi/2))
            
            
        }

        self.navigationItem.hidesBackButton = true
        
  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func deviceRotated(){
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            print("Landscape")
            takePhoto.transform = self.takePhoto.transform.rotated(by: CGFloat(Double.pi/2))
            
            
        }
        else if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            print("Portrait")
            takePhoto.transform = self.takePhoto.transform.rotated(by: CGFloat(-Double.pi/2))
            
        }
        
    }
    
    
    
    func classifyImage(image: Data){
        
        
        
        let request = estimateSession.postImage(image: image)
        
        let pic = estimateSession.replacePic(pic: currentPic)
        self.currentPic = pic
        print("heyaljdfhasljkfha")
        delegate?.refresh(pic: currentPic)
        _ = navigationController?.popViewController(animated: true)
        
        
        let task =  URLSession.shared.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            pic.doneLoading = true
            do{
                
                let json = try JSONSerialization.jsonObject(with: data!) as! [[String: Any]]
                
                
                self.estimateSession.parseJson(json: json, pic: pic)
                
                
                DispatchQueue.main.async {
                    
                    let name = Notification.Name("ImageRequestComplete")
                    NotificationCenter.default.post(name: name, object: nil)
                    
                    
                }
                
                
            }catch{
                print("Whoops with the JSON")
                
                
            }
            
            
        })
        task.resume()
        
        
        
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

extension RetakeViewController : AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        // get captured image
        
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard var imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        
        if UIDevice.current.orientation.isPortrait{
            print("portrait photo!!")
            
            let image_before_rotate = UIImage(data: imageData)
            let rotatedImage = image_before_rotate?.rotated(by: Measurement(value: 90.0, unit: .degrees))
            imageData = UIImageJPEGRepresentation(rotatedImage!, 0.9)!
            
        }
        
        // Send Image to server for classifcation
        classifyImage(image: imageData)
        
    }
    
}


