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
import ReplayKit
import CoreBluetooth

class CameraController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    var times:Int = 0
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        print(central.state)
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for",ParticlePeripheral.particleHM10);
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleHM10], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("before stop scan")
        // We've found it so stop scan
        self.centralManager.stopScan()

        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self

        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)

    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your Particle Board")
            peripheral.discoverServices([ParticlePeripheral.particleHM10])
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("did Discover Services")
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.particleHM10 {
                    print("LED service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics(nil, for: service)
                    return
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("did Discover Characteristics")
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print(characteristic)
                if characteristic.uuid == ParticlePeripheral.particleFFE1 {
                    print("FFE1 characteristic found")
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor charcteristic: CBCharacteristic, error: Error?) {
        print("did Update Value")
        switch charcteristic.uuid {
        case ParticlePeripheral.particleFFE1:
            let readValue = charcteristic.value!
            let buffer = [UInt8](readValue)

            if let string = String(bytes: buffer, encoding: String.Encoding.utf8) {
                print(string)
                times += 1
                ShowMuscle(text: String(format:"Times: %4d \nStrength: %@", arguments:[times, string]))
            } else {
                print("not a valid UTF-8 sequence")
            }
        default:
            return
        }
    }

    func bytes2Int(_ array:[UInt8]) -> Int {
        var value : UInt32 = 0
        let data = NSData(bytes: array, length: array.count)
        data.getBytes(&value, length: array.count)
        value = UInt32(bigEndian: value)
        return Int(value)
    }
    
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    
    let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        playVideo(name: "bicep_curls")
        
        loadGif(name: "bicep_curls_pose-3")
        
        ShowMuscle(text: "Test....")
        
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
    
    func playVideo(name: String) {

        let path = Bundle.main.path(forResource: name, ofType: "MP4")!
        let player = AVPlayer(url: URL(fileURLWithPath: path))

        playerViewController.player = player
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)

        self.present(playerViewController, animated: true) {
            self.playerViewController.player!.play()
        }
    }
    
    func loadGif(name: String) {
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: name, withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        let imageView = UIImageView(image: advTimeGif)
        imageView.frame = CGRect(x: -435.0, y: 0.0, width:
            1280.0, height: 720.0)
        view.addSubview(imageView)
    }
    
    @IBOutlet weak var MuscleText: UITextView!
    func ShowMuscle(text: String) {
//        let popup = UIView(frame: CGRect(x:100,y:200,width:200,height:200))
//        let lb = UILabel(frame: CGRect(x:100,y:200,width:200,height:200))
//        lb.text = "anything"
//        popup.backgroundColor = UIColor.red
        MuscleText.text = text

        view.addSubview(MuscleText)
//        popup.addSubview(lb)
//        lb.center = popup.center
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
            self.playerViewController.dismiss(animated: true)
    }
    
    let recorder = RPScreenRecorder.shared()
        private var isRecording = false
    
    
    @IBAction func recordBtnTapped(_ sender: Any) {
        if !isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    func startRecording() {
        guard recorder.isAvailable else {
            print("Recording is not available at this time.")
            return
        }
        
        let pause = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(recordBtnTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = pause
        
        
        recorder.startRecording{ (error) in
            if let error = error {
                print(error)
            }
            self.isRecording = true
        }
    }
    
    func stopRecording() {
        let play = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(recordBtnTapped(_:)))
        self.navigationItem.rightBarButtonItem = play
        
        recorder.stopRecording{ (previewVC, error) in
            if let previewVC = previewVC {
                previewVC.previewControllerDelegate = self
                self.present(previewVC, animated: true, completion: nil)
            }
            if let error = error {
                print(error)
            }
            self.isRecording = false
        }
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

extension CameraController: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }
}
