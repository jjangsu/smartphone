//
//  ViewController.swift
//  AVPlayerDemo
//
//  Created by Neil Smyth on 10/10/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVPlayerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as!
                                AVPlayerViewController
        let url = URL(string:
                "http://www.ebookfrenzy.com/ios_book/movie/movie.mov")
        
        destination.delegate = self
        
        if let movieURL = url {
            destination.player = AVPlayer(url: movieURL)
        }
    }

    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {

        let currentViewController = 
            navigationController?.visibleViewController

        if currentViewController != playerViewController {
            if let topViewController =
                   navigationController?.topViewController {

                topViewController.present(playerViewController,
                      animated: true, completion: {()
                    completionHandler(true)
                })
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

