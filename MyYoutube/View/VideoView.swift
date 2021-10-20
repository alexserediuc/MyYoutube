//
//  VideoView.swift
//  MyYoutube
//
//  Created by Alex on 20/10/2021.
//

import UIKit

class VideoView: UIView {
    
    private lazy var playerView = PlayerView()
    private var customConstraints = [NSLayoutConstraint]()
    private func activate(constraints: [NSLayoutConstraint]) {
        customConstraints.append(contentsOf: constraints)
        customConstraints.forEach { $0.isActive = true }
    }
    private func clearConstraints() {
        customConstraints.forEach { $0.isActive = false }
        customConstraints.removeAll()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup() {
        layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(minimize), name: .minimize, object: nil)
        
        backgroundColor = UIColor.green
        let urlString = "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.mp4"
        guard let url = URL(string: urlString) else { return }

        addSubview(playerView)
        let constraints = [
            playerView.topAnchor.constraint(equalTo: topAnchor),
            playerView.rightAnchor.constraint(equalTo: rightAnchor),
            playerView.leftAnchor.constraint(equalTo: leftAnchor),
            playerView.heightAnchor.constraint(equalToConstant: frame.width * 9/16)

        ]
        activate(constraints: constraints)
        playerView.setup(videoURL: url)
    }
    
    @objc private func minimize() {
        clearConstraints()
        let constraints = [
            playerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            playerView.leftAnchor.constraint(equalTo: leftAnchor),
            playerView.widthAnchor.constraint(equalToConstant: frame.width / 3),
            playerView.heightAnchor.constraint(equalToConstant: frame.width / 3 * 9/16)
        ]
        activate(constraints: constraints)
    }
}
