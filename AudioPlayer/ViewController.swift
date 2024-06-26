//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Arpit iOS Dev. on 25/06/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var songLengthLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioPlayer()
        
    }
    
    func setupAudioPlayer() {
        guard let audioFileURL = Bundle.main.url(forResource: "ANIMAL", withExtension: "mp3") else {
            fatalError("Audio file not found.")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            
            timeSlider.minimumValue = 0
            timeSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
            
            updateCurrentTimeLabel()
            updateSongLengthLabel()
        } catch {
            print("Error initializing AVAudioPlayer: \(error.localizedDescription)")
        }
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

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        stopTimer()
    }
}
