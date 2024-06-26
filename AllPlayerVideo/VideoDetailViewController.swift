//
//  VideoDetailViewController.swift
//  AllPlayerVideo
//
//  Created by Arpit iOS Dev. on 26/06/24.
//

import UIKit
import youtube_ios_player_helper

class VideoDetailViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    var videoID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let videoID = videoID {
            playerView.load(withVideoId: videoID)
        }
        self.title = "Video Player"
    }
}
