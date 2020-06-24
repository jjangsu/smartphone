//
//  ViewController.swift
//  MySiriDemo
//
//  Created by Neil Smyth on 10/11/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        INPreferences.requestSiriAuthorization({status in
            // Handle errors here
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

