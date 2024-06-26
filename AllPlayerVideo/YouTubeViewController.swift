//
//  YouTubeViewController.swift
//  AudioPlayer
//
//  Created by Arpit iOS Dev. on 26/06/24.
//

import UIKit

class YouTubeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let videos = [
        ("Video 1", "HrnrqYxYrbk", "https://img.youtube.com/vi/HrnrqYxYrbk/0.jpg"),
        ("Video 2", "kYxt2KJB9EQ", "https://img.youtube.com/vi/kYxt2KJB9EQ/0.jpg"),
        ("Video 3", "EVF_AuhJgLg", "https://img.youtube.com/vi/EVF_AuhJgLg/0.jpg"),
        ("Video 4", "ZmcBC9-wAXM", "https://img.youtube.com/vi/ZmcBC9-wAXM/0.jpg"),
        ("Video 5", "5zI_NseGp9k", "https://img.youtube.com/vi/5zI_NseGp9k/0.jpg"),
        ("Video 6", "B_6d3RBiEN0", "https://img.youtube.com/vi/B_6d3RBiEN0/0.jpg"),
        ("Video 7", "KUpwupYj_tY", "https://img.youtube.com/vi/KUpwupYj_tY/0.jpg"),
        ("Video 8", "yZomIAahIZc", "https://img.youtube.com/vi/yZomIAahIZc/0.jpg"),
        ("Video 9", "w3OmUdpewOw", "https://img.youtube.com/vi/w3OmUdpewOw/0.jpg"),
        ("Video 10", "iraezTzB938", "https://img.youtube.com/vi/iraezTzB938/0.jpg"),
        // Add more videos here
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Video List"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as! VideoTableViewCell
        let video = videos[indexPath.row]
        
        // Load thumbnail image
        if let url = URL(string: video.2) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
        detailVC.videoID = video.1
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 211
    }
}
