//
//  ViewController.swift
//  Record
//
//  Created by Neil Smyth on 10/10/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false
        stopButton.isEnabled = false

        let fileMgr = FileManager.default

        let dirPaths = fileMgr.urls(for: .documentDirectory, 
                        in: .userDomainMask)

        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")

        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                    AVEncoderBitRateKey: 16,
                    AVNumberOfChannelsKey: 2,
                    AVSampleRateKey: 44100.0] as [String : Any]

        let audioSession = AVAudioSession.sharedInstance()

        do {
                try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }

        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        authorizeSR()
    }

    @IBAction func transcribeAudio(_ sender: AnyObject) {
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(
                    url: (audioRecorder?.url)!)
        recognizer?.recognitionTask(with: request, resultHandler: { 
        (result, error) in
             self.textView.text = result?.bestTranscription.formattedString
        })

    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        if audioRecorder?.isRecording == false {
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }

    }
    
    @IBAction func stopAudio(_ sender: AnyObject) {
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.isEnabled = true

        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }

    }
    
    @IBAction func playAudio(_ sender: AnyObject) {
        if audioRecorder?.isRecording == false {
            stopButton.isEnabled = true
            recordButton.isEnabled = false

            do {
                try audioPlayer = AVAudioPlayer(contentsOf: 
                        (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }

    func authorizeSR() {
        SFSpeechRecognizer.requestAuthorization { authStatus in

            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.transcribeButton.isEnabled = true

                case .denied:
                    self.transcribeButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition access denied by user", for: .disabled)

                case .restricted:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition restricted on device", for: .disabled)

                case .notDetermined:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition not authorized", for: .disabled)
                }
            }
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

