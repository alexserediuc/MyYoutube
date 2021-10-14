//
//  ViewController.swift
//  MyYoutube
//
//  Created by Alex on 13/10/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var navigationBarView = NavigationBarView()
    lazy var tabBarView = TabBarView()
    lazy var videosTableVC = VideosTableVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setConstraints()
        
    }
    
    private func setConstraints() {
        view.addSubview(navigationBarView)
        navigationBarView.pin(to: view)
        
        view.addSubview(tabBarView)
        tabBarView.pin(to: view)
        
        setVideosTableVCConstraints()
    }
    
    private func setVideosTableVCConstraints() {
        addChild(videosTableVC)
        view.addSubview(videosTableVC.view)
        NSLayoutConstraint.activate([
                videosTableVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                videosTableVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                videosTableVC.view.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
                videosTableVC.view.bottomAnchor.constraint(equalTo: tabBarView.topAnchor)
            ])
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        MainViewController().showPreview()
    }
}
#endif

