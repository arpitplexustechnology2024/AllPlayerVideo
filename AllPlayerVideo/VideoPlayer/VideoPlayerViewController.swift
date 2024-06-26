//
//  VideoPlayerViewController.swift
//  AudioPlayer
//
//  Created by Arpit iOS Dev. on 26/06/24.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    var player: AVPlayer?
    var playerViewController: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let videoURL = Bundle.main.url(forResource: "videoplayback", withExtension: "mp4") {
            player = AVPlayer(url: videoURL)
            playerViewController = AVPlayerViewController()
            playerViewController?.player = player
            playerViewController?.showsPlaybackControls = true
            
            if let playerViewController = playerViewController {
                self.addChild(playerViewController)
                self.view.addSubview(playerViewController.view)
                playerViewController.view.frame = self.view.frame
                playerViewController.didMove(toParent: self)
            }
            
            player?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        } else {
            print("Video file not found")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if player?.status == .readyToPlay {
                player?.play()
            } else if player?.status == .failed {
                print("Failed to load video")
            }
        }
    }
}
