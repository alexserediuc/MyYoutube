//
//  ViewController.swift
//  MyYoutube
//
//  Created by Alex on 13/10/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let safeLayout = view.safeAreaLayoutGuide
        view.backgroundColor = UIColor.systemBackground
        
        let navigationBarView = NavigationBarView()
        view.addSubview(navigationBarView)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            navigationBarView.leftAnchor.constraint(equalTo: safeLayout.leftAnchor),
            navigationBarView.rightAnchor.constraint(equalTo: safeLayout.rightAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let tabBarView = TabBarView()
        view.addSubview(tabBarView)
        NSLayoutConstraint.activate([
            tabBarView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            tabBarView.leftAnchor.constraint(equalTo: safeLayout.leftAnchor),
            tabBarView.rightAnchor.constraint(equalTo: safeLayout.rightAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 50)
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

