//
//  ImageSaver.swift
//  Yakudo_For_iOS
//
//  Created by SEED on 2021/04/21.
//
import SwiftUI
import UIKit

class ImageSaver: NSObject {
    @Binding var showAlert: Bool
    
    init(_ showAlert: Binding<Bool>) {
        _showAlert = showAlert
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSavingImage), nil)
    }

    @objc func didFinishSavingImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if error != nil {
            print("保存に失敗しました。")
        } else {
            showAlert = true
        }
    }
}
