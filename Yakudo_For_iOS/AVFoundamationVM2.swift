//
//  AVFoundamationVM2.swift
//  Yakudo_For_iOS
//
//  Created by 多根直輝 on 2021/04/21.
//

import SwiftUI
import AVFoundation

extension AVCaptureDevice.Position: CaseIterable {
   public static var allCases: [AVCaptureDevice.Position] {
       return [.front, .back]
   }
   
   mutating func toggle() {
       self = self == .front ? .back : .front
   }
}
typealias CameraPosition = AVCaptureDevice.Position

class SwitchingCamera: NSObject, AVCapturePhotoCaptureDelegate, ObservableObject {
   @Published var previewLayer:[CameraPosition:AVCaptureVideoPreviewLayer] = [:]
   private var captureDevice:AVCaptureDevice!
   private var captureSession:[CameraPosition:AVCaptureSession] = [:]
   private var dataOutput:[CameraPosition:AVCapturePhotoOutput] = [:]
   private var currentCameraPosition:CameraPosition
   
   override init() {
       currentCameraPosition = .back
       super.init()
       for cameraPosition in CameraPosition.allCases {
           previewLayer[cameraPosition] = AVCaptureVideoPreviewLayer()
           captureSession[cameraPosition] = AVCaptureSession()
           setupSession(cameraPosition: cameraPosition)
       }
       captureSession[currentCameraPosition]?.startRunning()
   }
   
   private func setupDevice(cameraPosition: CameraPosition = .back) {
       if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: cameraPosition).devices.first {
           captureDevice = availableDevice
       }
   }
   
   private func setupSession(cameraPosition: CameraPosition = .back) {
       setupDevice(cameraPosition: cameraPosition)
       
       let captureSession = self.captureSession[cameraPosition]!
       captureSession.beginConfiguration()
       captureSession.sessionPreset = .photo
       
       do {
           let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
           captureSession.addInput(captureDeviceInput)
       } catch {
           print(error.localizedDescription)
       }
       
       let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
       self.previewLayer[cameraPosition] = previewLayer
       
       dataOutput[cameraPosition] = AVCapturePhotoOutput()
       guard let photoOutput = dataOutput[cameraPosition] else { return }
       if captureSession.canAddOutput(photoOutput) {
           captureSession.addOutput(photoOutput)
       }

       captureSession.commitConfiguration()
   }
   
   func switchCamera() {
       captureSession[currentCameraPosition]?.stopRunning()
       currentCameraPosition.toggle()
       captureSession[currentCameraPosition]?.startRunning()
   }
   
   func takePhoto() {
       let settings = AVCapturePhotoSettings()
       dataOutput[currentCameraPosition]?.capturePhoto(with: settings, delegate: self)
   }
   
   // MARK: - AVCapturePhotoCaptureDelegate
   func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
       // TODO: 写真撮影時処理
   }
}

