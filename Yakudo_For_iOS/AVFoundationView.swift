//
//  AVFoundationView.swift
//  Yakudo_For_iOS
//
//  Created by 多根直輝 on 2021/04/21.
//

import UIKit
import Combine
import AVFoundation


class AVFoundationView: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    ///撮影した画像
    @Published var image: UIImage?
    ///プレビュー用レイヤー
    var previewLayer:AVCaptureVideoPreviewLayer!
    // 回転時に水平に置いた時用
    var previous_orientation: UIDeviceOrientation = .portrait

    ///撮影開始フラグ
    private var _takePhoto:Bool = false
    ///セッション
    private let captureSession = AVCaptureSession()
    ///撮影デバイス
    private var capturepDevice:AVCaptureDevice!

    override init() {
        super.init()

        prepareCamera()
        beginSession()
    }

    func takePhoto() {
        _takePhoto = true
    }

    private func prepareCamera() {
        captureSession.sessionPreset = .photo

        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            capturepDevice = availableDevice
        }
    }

    private func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: capturepDevice)

            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        self.previewLayer = previewLayer
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]

        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }

        captureSession.commitConfiguration()

        let queue = DispatchQueue(label: "FromF.github.com.AVFoundationSwiftUI.AVFoundation")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    func startSession() {
        if captureSession.isRunning {
            return
        }
        captureSession.startRunning()
    }

    func endSession() {
        if !captureSession.isRunning { return }
        captureSession.stopRunning()
    }
    
    func updatePreviewOrientation() {
            switch UIDevice.current.orientation {
            case .portrait:
                self.previous_orientation = .portrait
                self.previewLayer.connection?.videoOrientation = .portrait
            case .landscapeLeft:
                self.previous_orientation = .landscapeLeft
                self.previewLayer.connection?.videoOrientation = .landscapeRight     // !!! left -> right !!!
            case .landscapeRight:
                self.previous_orientation = .landscapeRight
                self.previewLayer.connection?.videoOrientation = .landscapeLeft      // !!! right -> left !!!
            
            default:
                switch self.previous_orientation {
                    case .portrait:
                        self.previewLayer.connection?.videoOrientation = .portrait
                    case .landscapeLeft:
                        self.previewLayer.connection?.videoOrientation = .landscapeRight     // !!! left -> right !!!
                    case .landscapeRight:
                        self.previewLayer.connection?.videoOrientation = .landscapeLeft      // !!! right -> left !!!
                    default:
                        self.previewLayer.connection?.videoOrientation = .portrait
                }
            }
            return
        }

    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if _takePhoto {
            _takePhoto = false
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    switch UIDevice.current.orientation {
                    case .portrait:
                        self.image = UIImage(cgImage: (Yakudo.yakudo(image)!).cgImage!, scale: 0, orientation: image.imageOrientation)
                        print(1)
                    case .portraitUpsideDown:
                        //self.image = UIImage(cgImage: (Yakudo.yakudo(image)!).cgImage!, scale: 0, orientation: UIImage.Orientation(rawValue: 3)!)
                        print(12)
                    case .landscapeLeft:
                        self.image = UIImage(cgImage: (Yakudo.yakudo(image)!).cgImage!, scale: 0, orientation: UIImage.Orientation(rawValue: 0)!)
                        print(3)
                    case .landscapeRight:
                        self.image = UIImage(cgImage: (Yakudo.yakudo(image)!).cgImage!, scale: 0, orientation: UIImage.Orientation(rawValue: 1)!)
                        print(4)
                    default:
                        self.image = UIImage(cgImage: (Yakudo.yakudo(image)!).cgImage!, scale: 0, orientation: image.imageOrientation)
                        print(114)// unknown ....
                    }
                    //self.image = UIImage(cgImage: (Yakudo.yakudo(image)!).cgImage!, scale: 0, orientation: image.imageOrientation)
                }
            }
        }
    }

    private func getImageFromSampleBuffer (buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()

            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))

            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }

        return nil
    }
}
