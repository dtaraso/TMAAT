//
//  ViewController.swift
//  TMaaT Quick Estimate
//
//  Created by Team Two Men And A Truck on 9/18/17.
//  Copyright © 2017 Team Two Men And A Truck. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController{
    
    // Outlets
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var tapTakePhoto: UIBarButtonItem!
    @IBOutlet weak var RoomLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    // Member Variables
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var estimateSession : Estimate!
    var roomName: String!


    override func viewWillAppear(_ animated: Bool) {
        
        

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        
        //Set room Label
        RoomLabel.text = estimateSession.getRoomName()
        
        //Hide spinner
        spinner.isHidden = true
        
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
        
        
        
        
        
    }
    

   
    @IBAction func tapTakePhoto(_ sender: Any) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        
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
    

    func classifyImage(image: Data){
        
        let request = estimateSession.postImage(image: image)
        let task =  URLSession.shared.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            
            do{
               
                let json = try JSONSerialization.jsonObject(with: data!) as! [[String: Any]]
                
                
                self.estimateSession.parseJson(json: json)
                
                DispatchQueue.main.async {
                    
                    
                    self.spinner.stopAnimating()
                    self.performSegue(withIdentifier: "ConfirmResults", sender: nil)
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
    
    
    @IBAction func ChangeRoom(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ImageConfirmationViewController{
            spinner.isHidden = true
            viewController.estimateSession = estimateSession
        }
        
    }


}


extension ViewController : AVCapturePhotoCaptureDelegate {
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
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        
        // Send Image to server for classifcation
        classifyImage(image: imageData)
        
    }
    
}


