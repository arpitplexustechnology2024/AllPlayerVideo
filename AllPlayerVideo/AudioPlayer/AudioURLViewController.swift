//
//  AudioURLViewController.swift
//  AudioPlayer
//
//  Created by Arpit iOS Dev. on 26/06/24.
//

import UIKit
import AVFoundation

class AudioURLViewController: UIViewController {
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var songLengthLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let audioURL = URL(string: "https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Sevish_-__nbsp_.mp3") {
            downloadAudio(url: audioURL)
        }
    }
    
    func downloadAudio(url: URL) {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) { [weak self] (location, response, error) in
            guard let self = self, let location = location, error == nil else {
                print("Error downloading audio: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let data = try Data(contentsOf: location)
                self.audioPlayer = try AVAudioPlayer(data: data)
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.delegate = self
                
                DispatchQueue.main.async {
                    self.timeSlider.minimumValue = 0
                    self.timeSlider.maximumValue = Float(self.audioPlayer?.duration ?? 0)
                    self.updateCurrentTimeLabel()
                    self.updateSongLengthLabel()
                }
            } catch {
                print("Error initializing AVAudioPlayer: \(error.localizedDescription)")
            }
        }
        downloadTask.resume()
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        if let player = audioPlayer {
            if !isPlaying {
                player.play()
                playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
                startTimer()
            } else {
                player.pause()
                playPauseButton.setImage(UIImage(named: "play"), for: .normal)
                stopTimer()
            }
            isPlaying = !isPlaying
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if let player = audioPlayer {
            player.currentTime = TimeInterval(sender.value)
            updateCurrentTimeLabel()
        }
    }
    
    @IBAction func rewindButtonTapped(_ sender: UIButton) {
        seekAudio(by: -10)
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        seekAudio(by: 10)
    }
    
    func seekAudio(by seconds: TimeInterval) {
        guard let player = audioPlayer else { return }
        var newTime = player.currentTime + seconds
        if newTime < 0 {
            newTime = 0
        } else if newTime > player.duration {
            newTime = player.duration
        }
        player.currentTime = newTime
        updateCurrentTimeLabel()
        timeSlider.value = Float(newTime)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let player = self.audioPlayer {
                self.timeSlider.value = Float(player.currentTime)
                self.updateCurrentTimeLabel()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateCurrentTimeLabel() {
        if let player = audioPlayer {
            currentTimeLabel.text = formatTime(time: player.currentTime)
        }
    }
    
    func updateSongLengthLabel() {
        guard let player = audioPlayer else { return }
        songLengthLabel.text = formatTime(time: player.duration)
    }
    
    func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension AudioURLViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        stopTimer()
    }
}
