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
        viewController.view.frame = CGRect(x: 0, y: viewController.view.frame.height*15/100, width: viewController.view.frame.width, height: viewController.view.frame.height*65/100)
        viewController.view.layer.addSublayer(caLayer)
        caLayer.frame = viewController.view.layer.frame

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<PortraitCALayerView>) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}

struct LandscapeLeftCALayerView: UIViewControllerRepresentable {
    var caLayer:CALayer

    func makeUIViewController(context: UIViewControllerRepresentableContext<LandscapeLeftCALayerView>) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.frame = CGRect(x: viewController.view.frame.width*15/100, y: 0, width: viewController.view.frame.width*65/100, height: viewController.view.frame.height)
        viewController.view.layer.addSublayer(caLayer)
        caLayer.frame = viewController.view.layer.frame

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LandscapeLeftCALayerView>) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}

struct LandscapeRightCALayerView: UIViewControllerRepresentable {
    var caLayer:CALayer

    func makeUIViewController(context: UIViewControllerRepresentableContext<LandscapeRightCALayerView>) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.frame = CGRect(x: viewController.view.frame.width*20/100, y: 0, width: viewController.view.frame.width*65/100, height: viewController.view.frame.height)
        viewController.view.layer.addSublayer(caLayer)
        caLayer.frame = viewController.view.layer.frame

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LandscapeRightCALayerView>) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}
