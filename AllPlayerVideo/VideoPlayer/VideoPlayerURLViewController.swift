//
//  VideoPlayerURLViewController.swift
//  AudioPlayer
//
//  Created by Arpit iOS Dev. on 26/06/24.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerURLViewController: UIViewController {
    
    var playerViewController: AVPlayerViewController!
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "https://live-par-2-abr.livepush.io/vod/bigbuckbunnyclip.mp4") else {
            print("Invalid URL")
            return
        }
        
        player = AVPlayer(url: url)
        
        player.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.addChild(playerViewController)
        self.view.addSubview(playerViewController.view)
        playerViewController.view.frame = self.view.frame
        playerViewController.didMove(toParent: self)
        
        player.play()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if player.status == .readyToPlay {
                print("Player is ready to play")
            } else if player.status == .failed {
                if let error = player.error {
                    print("Player failed with error: \(error.localizedDescription)")
                } else {
                    print("Player failed with unknown error")
                }
            }
        }
    }
    
    deinit {
        player.removeObserver(self, forKeyPath: "status")
    }
}
