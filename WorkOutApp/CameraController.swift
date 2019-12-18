//
//  CameraController.swift
//  WorkOutApp
//
//  Created by Kao Pei-Wei on 2019/12/6.
//  Copyright © 2019 I CHIEN LAI. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CameraController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    
    let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        
        loadGif()
        
        ShowMuscle()
        
        if #available(iOS 10.2, *) {
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            do {
                
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
                
            }
            catch {
                print("Error: Cannot load camera")
            }
        }
    }
    
    func playVideo() {

        let path = Bundle.main.path(forResource: "video1", ofType: "mp4")!
        let player = AVPlayer(url: URL(fileURLWithPath: path))

        playerViewController.player = player
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)

        self.present(playerViewController, animated: true) {
            self.playerViewController.player!.play()
        }
    }
    
    func loadGif() {
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "tenor", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        let imageView = UIImageView(image: advTimeGif)
        imageView.frame = CGRect(x: 20.0, y: 200.0, width:
            self.view.frame.size.width - 40, height: 300.0)
        view.addSubview(imageView)
    }
    
    @IBOutlet weak var MuscleText: UITextView!
    func ShowMuscle() {
//        let popup = UIView(frame: CGRect(x:100,y:200,width:200,height:200))
//        let lb = UILabel(frame: CGRect(x:100,y:200,width:200,height:200))
//        lb.text = "anything"
//        popup.backgroundColor = UIColor.red
        MuscleText.text = "Test...."
        view.addSubview(MuscleText)
//        popup.addSubview(lb)
//        lb.center = popup.center
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
            self.playerViewController.dismiss(animated: true)
           }
    

    @IBAction func imageCapture(_ sender: Any) {
    }
    
    func switchToFrontCamera() {
        if frontCamera?.isConnected == true {
            captureSession?.stopRunning()
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
            }
            catch {
                print("Error")
            }
        }
    }
    
    func switchToBackCamera() {
        if backCamera?.isConnected == true {
            captureSession?.stopRunning()
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
            }
            catch {
                print("Error")
            }
        }
    }
    
    @IBAction func rotateCamera(_ sender: Any) {
        guard let currentCameraInput: AVCaptureInput = captureSession?.inputs.first else {
            return
        }
        
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if input.device.position == .back {
                switchToFrontCamera()
            }
            if input.device.position == .front {
                switchToBackCamera()
            }
        }
    }


}
