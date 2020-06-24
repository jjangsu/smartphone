//
//  ViewController.swift
//  Touch
//
//  Created by Neil Smyth on 10/6/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var methodStatus: UILabel!
    @IBOutlet weak var touchStatus: UILabel!
    @IBOutlet weak var tapStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchCount = touches.count
        let touch = touches.first
        let tapCount = touch!.tapCount

        methodStatus.text = "touchesBegan"
        touchStatus.text = "\(touchCount) touches"
        tapStatus.text = "\(tapCount) taps"
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchCount = touches.count
        let touch = touches.first
        let tapCount = touch!.tapCount

        methodStatus.text = "touchesMoved";
        touchStatus.text = "\(touchCount) touches"
        tapStatus.text = "\(tapCount) taps"

        if let eventObj = event {
           for predictedTouch in eventObj.predictedTouches(for: touch!)! {
               let point = predictedTouch.location(in: self.view)
               print("Predicted location X = \(point.x), Y = \(point.y)")
           }
           print("============")
        }

        if let eventObj = event {
           for coalescedTouch in eventObj.coalescedTouches(for: touch!)! {
                let point = coalescedTouch.location(in: self.view)
                print("Coalesced location X = \(point.x), Y = \(point.y)")
            }
            print("============")
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchCount = touches.count
        let touch = touches.first
        let tapCount = touch!.tapCount

        methodStatus.text = "touchesEnded";
        touchStatus.text = "\(touchCount) touches"
        tapStatus.text = "\(tapCount) taps"
    }


}

