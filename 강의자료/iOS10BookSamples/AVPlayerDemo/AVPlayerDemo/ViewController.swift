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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as!
                                AVPlayerViewController
        let url = URL(string:
                "http://www.ebookfrenzy.com/ios_book/movie/movie.mov")

            if let movieURL = url {
                destination.player = AVPlayer(url: movieURL)
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

