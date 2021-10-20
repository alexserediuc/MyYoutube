//
//  TestVC.swift
//  MyYoutube
//
//  Created by Alex on 19/10/2021.
//

import UIKit

class TestVC: UIViewController {

    var videoView = VideoView()
    private var customConstraints = [NSLayoutConstraint]()
    private func activate(constraints: [NSLayoutConstraint]) {
        customConstraints.append(contentsOf: constraints)
        customConstraints.forEach { $0.isActive = true }
    }
    
    private func clearConstraints() {
        customConstraints.forEach { $0.isActive = false }
        customConstraints.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(videoView)
        let constraints = [
            videoView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            videoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            videoView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ]
        activate(constraints: constraints)
        videoView.setup()
    }
    
}
