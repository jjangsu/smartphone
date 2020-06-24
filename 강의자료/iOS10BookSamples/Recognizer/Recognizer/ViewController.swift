//
//  ViewController.swift
//  Recognizer
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func tapDetected(_ sender: UITapGestureRecognizer) {
        statusLabel.text = "Double Tap"
    }
    
    @IBAction func pinchDetected(_ sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let velocity = sender.velocity
        let resultString =
            "Pinch - scale = \(scale), velocity = \(velocity)"

        statusLabel.text = resultString

    }
    
    @IBAction func rotationDetected(_ sender: UIRotationGestureRecognizer) {
        let radians = sender.rotation
        let velocity = sender.velocity
        let resultString =
            "Rotation - Radians = \(radians), velocity = \(velocity)"

        statusLabel.text = resultString

    }
    
    @IBAction func swipeDetected(_ sender: AnyObject) {
        statusLabel.text = "Right swipe"
    }
    
    @IBAction func longPressDetected(_ sender: AnyObject) {
        statusLabel.text = "Long Press"
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

