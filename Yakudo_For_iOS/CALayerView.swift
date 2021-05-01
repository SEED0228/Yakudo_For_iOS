//
//  CALayerView.swift
//  Yakudo_For_iOS
//
//  Created by SEED on 2021/04/21.
//

import SwiftUI

struct PortraitCALayerView: UIViewControllerRepresentable {
    var caLayer:CALayer

    func makeUIViewController(context: UIViewControllerRepresentableContext<PortraitCALayerView>) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.frame = CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: viewController.view.frame.height*7/10)
        viewController.view.layer.addSublayer(caLayer)
        caLayer.frame = viewController.view.layer.frame

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<PortraitCALayerView>) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}

struct LandscapeCALayerView: UIViewControllerRepresentable {
    var caLayer:CALayer

    func makeUIViewController(context: UIViewControllerRepresentableContext<LandscapeCALayerView>) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.frame = CGRect(x: 0, y: 0, width: viewController.view.frame.width*7/10, height: viewController.view.frame.height)
        viewController.view.layer.addSublayer(caLayer)
        caLayer.frame = viewController.view.layer.frame

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LandscapeCALayerView>) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}
