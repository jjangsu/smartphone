//
//  ViewController.swift
//  InAppDemo
//
//  Created by Neil Smyth on 10/11/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    @IBOutlet weak var level2Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegate = UIApplication.shared.delegate
                            as! AppDelegate
        appdelegate.homeViewController = self
    }

    func enableLevel2() {
        level2Button.isEnabled = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

