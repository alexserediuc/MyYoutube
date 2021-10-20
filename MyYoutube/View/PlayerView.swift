//
//  PlayerView.swift
//  MyYoutube
//
//  Created by Alex on 19/10/2021.
//

import Foundation
import UIKit
import AVFoundation

class PlayerView: UIView {
    
    //MARK: - Private Properties
    private var videoUrl: String!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var customConstraints = [NSLayoutConstraint]()
    private var isPlaying = false
    private var isMinimized = false
    private var viewsToHide = [UIView]()
    lazy private var activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = UIColor.white
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    lazy private var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "pause.fill")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        viewsToHide.append(button)
        return button
    }()
    lazy private var videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        viewsToHide.append(label)
        return label
    }()
    lazy private var curretTimelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        viewsToHide.append(label)
        return label
    }()
    lazy private var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        let image = UIImage(named: "circle.fill")
        slider.setThumbImage(image, for: .normal)
        slider.thumbTintColor = .red
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        viewsToHide.append(slider)
        return slider
    }()
    lazy private var minimizeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.down")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleMinimize), for: .touchUpInside)
        viewsToHide.append(button)
        return button
    }()
    @objc private func handleMinimize() {
        NotificationCenter.default.post(name: .minimize, object: nil)
        isMinimized = true
        for v in viewsToHide {
            v.isHidden = true
        }
        videoSlider.setThumbImage(UIImage(), for: .normal)
        videoSlider.isEnabled = false
        setMiniConstraints()
        layoutIfNeeded()
        playerLayer.frame = bounds
    }
    
    //MARK: - Overrident Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func onTap(_ gesture: UITapGestureRecognizer) {
        if isMinimized {
            pausePlayButton.isHidden = false
            handlePause()
        } else {
            showViews()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.hideViews()
        }
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
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                if(seconds > 0){
                    let secondsText = Int(seconds) % 60
                    let minutesText = String(format: "%02d", Int(seconds) / 60)
                    videoLengthLabel.text = "\(minutesText):\(secondsText)"
                }
            }
        }
    }
    
    //MARK: - Public Methods
    public func setup(videoURL: URL) {
        layoutIfNeeded()
        setupPlayer(from: videoURL)
        addSubview(pausePlayButton)
        addSubview(activityIndicatorView)
        addSubview(videoLengthLabel)
        addSubview(curretTimelabel)
        addSubview(videoSlider)
        addSubview(minimizeButton)
        setFullConstraints()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.hideViews()
        }
    }
    
    //MARK: - Private Methods
    private func hideViews() {
        for v in viewsToHide {
            v.isHidden = true
        }
    }
    private func showViews() {
        for v in viewsToHide {
            v.isHidden = false
        }
    }
    private func setFullConstraints() {
        clearConstraints()
        let constraints = [
            pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            curretTimelabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            curretTimelabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            videoLengthLabel.centerYAnchor.constraint(equalTo: curretTimelabel.centerYAnchor),
            videoSlider.leftAnchor.constraint(equalTo: curretTimelabel.rightAnchor),
            videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor),
            videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor),
            videoSlider.centerYAnchor.constraint(equalTo: curretTimelabel.centerYAnchor),
            minimizeButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            minimizeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        ]
        activate(constraints: constraints)
    }
    
    private func setMiniConstraints() {
        clearConstraints()
        let constraints = [
            videoSlider.leftAnchor.constraint(equalTo: leftAnchor),
            videoSlider.rightAnchor.constraint(equalTo: rightAnchor),
            videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        activate(constraints: constraints)
    }
    
    private func setupPlayer(from url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.backgroundColor = UIColor.black.cgColor
        
        layer.addSublayer(playerLayer)
        playerLayer.frame = bounds
        player.play()
        
        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        let interval = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds) % 60)
            let minutesString = String(format: "%02d", Int(seconds) / 60)
            self.curretTimelabel.text = "\(minutesString):\(secondsString)"
            //move the slider
            if let duration = self.player?.currentItem?.duration {
                let durationSconds = CMTimeGetSeconds(duration)
                self.videoSlider.value = Float(seconds / durationSconds)
            }
        }
    }
    
    private func activate(constraints: [NSLayoutConstraint]) {
        customConstraints.append(contentsOf: constraints)
        customConstraints.forEach { $0.isActive = true }
    }
    
    private func clearConstraints() {
        customConstraints.forEach { $0.isActive = false }
        customConstraints.removeAll()
    }
    
    @objc private func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    @objc func handleSliderChange() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //do smth
            })
        }
    }
}
