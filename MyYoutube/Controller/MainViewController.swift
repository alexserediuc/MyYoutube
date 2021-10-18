//
//  ViewController.swift
//  MyYoutube
//
//  Created by Alex on 13/10/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Private Properties
    lazy private var navigationBarView = NavigationBarView()
    lazy private var tabBarView = TabBarView()
    lazy private var videoView = VideoPlayerView()
    lazy private var videosTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = view.frame.width * 9/16 + 75
        tableView.separatorStyle = .none
        tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.getIdentifier())
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var videos: [Video] = []
    private var customConstraints = [NSLayoutConstraint]()
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setConstraints()
        videos = fetchDummyVideos()
        setTableViewDelegates()
        setNotificationObservers()
    }
    
    //MARK: - Private Methods
    private func activate(constraints: [NSLayoutConstraint]) {
        customConstraints.append(contentsOf: constraints)
        customConstraints.forEach { $0.isActive = true }
    }
    
    private func clearConstraints() {
        customConstraints.forEach { $0.isActive = false }
        customConstraints.removeAll()
    }
    
    @objc private func closeVideoPlayer() {
        videoView.removeFromSuperview()
        clearConstraints()
        setVideosTableViewConstraints()
    }
    
    @objc private func minimizeVideoPlayer() {
        setMinimizedVideoConstraints()
    }
    
    private func setNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(minimizeVideoPlayer), name: .minimizeVideoPlayer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeVideoPlayer), name: .closeVideoPlayer, object: nil)
    }
    
    private func setMinimizedVideoConstraints() {
        clearConstraints()
        let constraints = [
            videosTableView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            videosTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            videosTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            videosTableView.bottomAnchor.constraint(equalTo: videoView.topAnchor),
            videoView.heightAnchor.constraint(equalToConstant: view.frame.width/3 * 9/16),
            videoView.bottomAnchor.constraint(equalTo: tabBarView.topAnchor),
            videoView.leftAnchor.constraint(equalTo: view.leftAnchor),
            videoView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        activate(constraints: constraints)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { finished in
            print("done")
        }
    }
    
    private func setVideosTableViewConstraints() {
        let constraints = [
            videosTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            videosTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            videosTableView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            videosTableView.bottomAnchor.constraint(equalTo: tabBarView.topAnchor)
        ]
        activate(constraints: constraints)
    }
    
    private func setFullVideoConstraints() {
        view.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            videoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoView.rightAnchor.constraint(equalTo: view.rightAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ]
        activate(constraints: constraints)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { finished in
            print("done")
        }
    }
    
    private func setTableViewDelegates() {
        videosTableView.delegate = self
        videosTableView.dataSource = self
    }
    
    private func setConstraints() {
        view.addSubview(navigationBarView)
        view.addSubview(tabBarView)
        view.addSubview(videosTableView)
        
        navigationBarView.pin(to: view)
        tabBarView.pin(to: view)
        setVideosTableViewConstraints()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.getIdentifier()) as! VideoCell
        let video = videos[indexPath.row]
        cell.set(video: video)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .closeOtherVideoPlayer, object: nil)
        let startingFrame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 10)
        videoView = VideoPlayerView(frame: startingFrame)
        setFullVideoConstraints()
    }
}

extension MainViewController {
    func fetchDummyVideos() -> [Video] {
        let user = User(uid: "123", username: "Georgel")
        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 7
        let userCalendar = Calendar.current
        let someDate = userCalendar.date(from: dateComponents)
        let video1 = Video(vid: "1234", title: "Ceva titluuuuuuuuuuuuu uuuuuu uuuuuuuuuu", viewsNumber: 1000, uploadDate: someDate!, user: user)
        let video2 = Video(vid: "123", title: "Ceva titlu 2", viewsNumber: 10000, uploadDate: someDate!, user: user)
        return [video1,video2,video1,video2]
    }
}
