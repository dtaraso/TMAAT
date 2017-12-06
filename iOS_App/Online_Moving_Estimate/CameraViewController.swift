//
//  ViewController.swift
//  TMaaT Quick Estimate
//
//  Created by Team Two Men And A Truck on 9/18/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit
import AVFoundation



class CameraViewController: UIViewController{
    
    // Outlets
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var takePhoto: UIButton!
    @IBOutlet weak var checkResults: UIButton!
    
    
    
    
    // Member Variables
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var estimateSession : Estimate!
    var roomName: String!


    override func viewWillAppear(_ animated: Bool) {
        
        
        print(UIDevice.current.orientation.isPortrait)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = roomName
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        deviceRotated()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CameraViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    // Function rotates buttons when device is rotated
    func deviceRotated(){
        
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            let image = UIImage(named: "camera-r")
            let checkImage = UIImage(named: "checkResults-r")
            checkResults.setImage(checkImage, for: .normal)
            takePhoto.setImage(image, for: .normal)
            print("landscape")
        case.landscapeRight:
            let image = UIImage(named: "camera-l")
            let checkImage = UIImage(named: "checkResults-l")
            checkResults.setImage(checkImage, for: .normal)
            takePhoto.setImage(image, for: .normal)
        case .portrait:
            let image = UIImage(named: "camera")
            let checkImage = UIImage(named: "checkResults")
            checkResults.setImage(checkImage, for: .normal)
            takePhoto.setImage(image, for: .normal)
            print("Portrait")
        case .portraitUpsideDown:
            let image = UIImage(named: "camera-u")
            let checkImage = UIImage(named: "checkResults-u")
            checkResults.setImage(checkImage, for: .normal)
            takePhoto.setImage(image, for: .normal)
        default:
            print("other")
        }
        
        
        
        
    }
    
    
    //Overrides back button behavior for camera screen
    func back(sender: UIBarButtonItem) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    

   // When a user takes a photo...
    @IBAction func tapTakePhoto(_ sender: Any) {
        
        
        
        
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
    
    //Takes image data, sends to server, and creates movingItems based on results
    func classifyImage(image: Data){
        
        let request = estimateSession.postImage(image: image)
        
        let pic = estimateSession.createPicture()
        
        let task =  URLSession.shared.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            pic.doneLoading = true
            do{
               
                let json = try JSONSerialization.jsonObject(with: data!) as! [[String: Any]]
                
                
                self.estimateSession.parseJson(json: json, pic: pic)
                
                //Perform image request asyncrounsly.
                DispatchQueue.main.async {
                    
                    print("done")
                    let name = Notification.Name("ImageRequestComplete")
                    NotificationCenter.default.post(name: name, object: nil)
                }
                
                
            }catch{
                print("Whoops with the JSON")
                
                
            }
            
            
        })
        task.resume()
        
        
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Sends user back to previous screen
    @IBAction func ChangeRoom(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ItemCollectionViewController{
            print("Called!")
            viewController.estimateSession = estimateSession
            
            
            
        }
        
    }


}


extension CameraViewController : AVCapturePhotoCaptureDelegate {
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

//Extend image to allow for easy rotations
extension UIImage {
    struct RotationOptions: OptionSet {
        let rawValue: Int
        
        static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
        static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
    }
    
    func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
        let transform = CGAffineTransform(rotationAngle: rotationInRadians)
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero
        
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        return renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: rotationInRadians)
            
            let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
            let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
            renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
            
            let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }
    }
}


