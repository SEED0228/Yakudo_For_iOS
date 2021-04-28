//
//  OrientationObserver.swift
//  Yakudo_For_iOS
//
//  Created by 多根直輝 on 2021/04/21.
//

import SwiftUI

class OrientationObserver: ObservableObject {
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self,name: UIDevice.orientationDidChangeNotification,object: nil)
    }
    
    @objc func orientationChange(_ notification: Notification) {
        print("change orientation")
    }
    
}
