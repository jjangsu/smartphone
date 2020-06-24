//
//  ViewController.swift
//  AudioDemo
//
//  Created by Neil Smyth on 10/10/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var volumeControl: UISlider!
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL.init(fileURLWithPath: Bundle.main.path(
                        forResource: "Moderato",
                                    ofType: "mp3")!)

        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        } catch let error as NSError {
            print("audioPlayer error \(error.localizedDescription)")
        }

    }

    @IBAction func playAudio(_ sender: AnyObject) {
        if let player = audioPlayer {
            player.play()
        }

    }
    
    @IBAction func stopAudio(_ sender: AnyObject) {
        if let player = audioPlayer {
            player.stop()
        }

    }
    
    @IBAction func adjustAudio(_ sender: AnyObject) {
        if audioPlayer != nil {
            audioPlayer?.volume = volumeControl.value
        }

    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully
                    flag: Bool) {
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer,
                    error: Error?) {
    }

    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
    }

    func audioPlayerEndInterruption(player: AVAudioPlayer) {
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

