//
//  VideoView.swift
//  MyYoutube
//
//  Created by Alex on 15/10/2021.
//

import Foundation
import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    //MARK: - Private Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var customConstraints = [NSLayoutConstraint]()
    lazy private var playerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy private var activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = UIColor.white
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    lazy private var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.isHidden = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy private var minimizeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.down")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleMinimize), for: .touchUpInside)
        return button
    }()
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "pause.fill")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var isMinimized = false {
        didSet {
            if isMinimized {
                minimizeButton.isHidden = true
                minimizeButton.isEnabled = false
                closeButton.isHidden = false
                closeButton.isEnabled = true
            } else {
                minimizeButton.isHidden = false
                minimizeButton.isEnabled = true
                closeButton.isHidden = true
                closeButton.isEnabled = false
            }
        }
    }
    private var video: Video?
    private var isPlaying = false
    
    //MARK: - Overriden Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //player ready and going
            if keyPath == "currentItem.loadedTimeRanges" {
                activityIndicatorView.stopAnimating()
                pausePlayButton.isHidden = false
                isPlaying = true
            }
    }
    
    //MARK: - Public Methods
    init (frame: CGRect, video: Video) {
        super.init(frame: frame)
        
        self.video = video
        setupView()
    }
    
    //MARK: - Private Methods
    private func setupView() {
        titleLabel.text = video!.title
        backgroundColor = .systemBackground
        
        setupLayout()
        setupPlayerView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleClose), name: .closeOtherVideoPlayer, object: nil)
    }
    
    private func setupLayout() {
        addSubview(playerContainerView)
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(minimizeButton)
        addSubview(activityIndicatorView)
        addSubview(pausePlayButton)
        setFullConstraints()
        setFullTitle()
    }
    
    private func setFullConstraints() {
        let constraints = [
            playerContainerView.topAnchor.constraint(equalTo: topAnchor),
            playerContainerView.rightAnchor.constraint(equalTo: rightAnchor),
            playerContainerView.leftAnchor.constraint(equalTo: leftAnchor),
            playerContainerView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 9/16),
            minimizeButton.topAnchor.constraint(equalTo: playerContainerView.topAnchor, constant: 10),
            minimizeButton.leftAnchor.constraint(equalTo: playerContainerView.leftAnchor, constant: 10),
            activityIndicatorView.centerXAnchor.constraint(equalTo: playerContainerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: playerContainerView.centerYAnchor),
            pausePlayButton.centerYAnchor.constraint(equalTo: playerContainerView.centerYAnchor),
            pausePlayButton.centerXAnchor.constraint(equalTo: playerContainerView.centerXAnchor),
            pausePlayButton.widthAnchor.constraint(equalToConstant: 50),
            pausePlayButton.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: playerContainerView.bottomAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        activate(constraints: constraints)
        
        setFullTitle()
    }
    
    private func setMinimizedConstraints() {
        clearConstraints()
        playerLayer?.frame = CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height)
        let constraints = [
            playerContainerView.topAnchor.constraint(equalTo: topAnchor),
            playerContainerView.leftAnchor.constraint(equalTo: leftAnchor),
            playerContainerView.widthAnchor.constraint(equalToConstant: playerLayer!.frame.width),
            playerContainerView.heightAnchor.constraint(equalToConstant: playerLayer!.frame.height),
            closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: playerContainerView.rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ]
        activate(constraints: constraints)
        
        setMinTitle()
    }
    
    private func setFullTitle() {
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
    }
    
    private func setMinTitle() {
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .thin)
    }
    
    private func activate(constraints: [NSLayoutConstraint]) {
        customConstraints.append(contentsOf: constraints)
        customConstraints.forEach { $0.isActive = true }
    }
    
    private func clearConstraints() {
        customConstraints.forEach { $0.isActive = false }
        customConstraints.removeAll()
    }
    
    @objc private func handleClose() {
        if player != nil {
            player!.pause()
            player = nil
            playerLayer!.removeFromSuperlayer()
            NotificationCenter.default.post(name: .closeVideoPlayer, object: nil)
        }
    }
    
    @objc private func handleMinimize() {
        isMinimized = true
        NotificationCenter.default.post(name: .minimizeVideoPlayer, object: nil)
        setMinimizedConstraints()
    }
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    private func setupPlayerView() {
        let urlString = "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.mp4"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerContainerView.layer.addSublayer(playerLayer!)
            playerLayer?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width * 9/16)
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
    }
}
