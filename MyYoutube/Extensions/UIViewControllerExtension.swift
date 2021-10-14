//
//  UIViewExtension.swift
//  MyYoutube
//
//  Created by Alex on 13/10/2021.
//

import UIKit
import SwiftUI

extension UIViewController {
    // enable preview for UIKit
    // source: https://dev.to/gualtierofr/preview-uikit-views-in-xcode-3543
    @available(iOS 13, *)
    private struct Preview: UIViewRepresentable {

        let vc: UIViewController
        func makeUIView(context: Context) -> UIView {
            return vc.view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            //
        }
    }
    
    
    @available(iOS 13, *)
    func showPreview() -> some View{
        // inject self (the current UIView) for the preview
        Preview(vc: self)
    }
}
