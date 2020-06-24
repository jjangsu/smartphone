//
//  ViewController.swift
//  AutoLayoutCode
//
//  Created by Neil Smyth on 10/5/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let superview = self.view

        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.text = "My Label"

        let myButton = UIButton()

        myButton.setTitle("My Button", for: UIControlState.normal)
        myButton.backgroundColor = UIColor.blue
        myButton.translatesAutoresizingMaskIntoConstraints = false

        superview?.addSubview(myLabel)
        superview?.addSubview(myButton)

        var myConstraint =
                NSLayoutConstraint(item: myLabel,
                    attribute: NSLayoutAttribute.centerY,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: superview,
                    attribute: NSLayoutAttribute.centerY,
                    multiplier: 1.0,
                    constant: 0)

        superview?.addConstraint(myConstraint)

        myConstraint =
            NSLayoutConstraint(item: myLabel,
                attribute: NSLayoutAttribute.centerX,
                relatedBy: NSLayoutRelation.equal,
                toItem: superview,
                attribute: NSLayoutAttribute.centerX,
                multiplier: 1.0,
                constant: 0)

        superview?.addConstraint(myConstraint)

        myConstraint =
            NSLayoutConstraint(item: myButton,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: myLabel,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1.0,
                constant: -10)

        superview?.addConstraint(myConstraint)

        myConstraint =
            NSLayoutConstraint(item: myButton,
                attribute: NSLayoutAttribute.lastBaseline,
                relatedBy: NSLayoutRelation.equal,
                toItem: myLabel,
                attribute: NSLayoutAttribute.lastBaseline,
                multiplier: 1.0,
                constant: 0)

        superview?.addConstraint(myConstraint)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

