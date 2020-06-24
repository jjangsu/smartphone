//
//  ViewController.swift
//  CrossView
//
//  Created by Neil Smyth on 10/5/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var viewB: UIView!
    @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
viewB.removeConstraint(centerConstraint)
    let constraint =
        NSLayoutConstraint(item: myLabel,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: myButton,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 1.0,
            constant: 0.0)

    self.view.addConstraint(constraint)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

