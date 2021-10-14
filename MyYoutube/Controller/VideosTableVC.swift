//
//  VideosTableVC.swift
//  MyYoutube
//
//  Created by Alex on 14/10/2021.
//

import UIKit

class VideosTableVC: UIViewController {
    
    lazy var videosTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = view.frame.width * 9/16 + 75
        tableView.separatorStyle = .none
        tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.getIdentifier())
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var videos: [Video] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        videos = fetchDummyVideos()
        
        setTableViewDelegates()
        setVideosTableViewConstraints()
    }
    
    private func setVideosTableViewConstraints() {
        view.addSubview(videosTableView)
        NSLayoutConstraint.activate([
            videosTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            videosTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            videosTableView.topAnchor.constraint(equalTo: view.topAnchor),
            videosTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setTableViewDelegates() {
        videosTableView.delegate = self
        videosTableView.dataSource = self
    }
}

extension VideosTableVC: UITableViewDelegate, UITableViewDataSource {
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
        
        
        print("cell tapped")
    }
}

extension VideosTableVC {
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
