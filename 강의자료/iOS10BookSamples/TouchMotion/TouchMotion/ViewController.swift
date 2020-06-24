//
//  ViewController.swift
//  TouchMotion
//
//  Created by Neil Smyth on 10/6/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var xCoord: UILabel!
    @IBOutlet weak var yCoord: UILabel!

    var startPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theTouch = touches.first {
            startPoint = theTouch.location(in: self.view)
            let x = startPoint!.x
            let y = startPoint!.y
            xCoord.text = ("x = \(x)")
            yCoord.text = ("y = \(y)")
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theTouch = touches.first {

            let touchLocation = theTouch.location(in: self.view)
            let x = touchLocation.x
            let y = touchLocation.y

            xCoord.text = ("x = \(x)")
            yCoord.text = ("y = \(y)")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theTouch = touches.first {

            let endPoint = theTouch.location(in: self.view)
            let x = endPoint.x
            let y = endPoint.y

            xCoord.text = ("x = \(x)")
            yCoord.text = ("y = \(y)")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

