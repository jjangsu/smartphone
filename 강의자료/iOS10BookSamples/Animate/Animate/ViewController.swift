//
//  ViewController.swift
//  Animate
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var scaleFactor: CGFloat = 2
    var angle: Double = 180
    var boxView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let frameRect = CGRect(x: 20, y: 20, width: 45, height: 45)

        boxView = UIView(frame: frameRect)
        boxView?.backgroundColor = UIColor.blue
        self.view.addSubview(boxView!)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {
            let location = touch.location(in: self.view)
    //        let timing = UICubicTimingParameters(
    //				animationCurve: .easeInOut)

            let timing = UISpringTimingParameters(mass: 0.5, stiffness: 0.5, damping: 0.3, initialVelocity: CGVector(dx:1.0, dy: 0.0))

            let animator = UIViewPropertyAnimator(duration: 2.0, 
                    timingParameters:timing)

            animator.addAnimations {
                let scaleTrans =
                    CGAffineTransform(scaleX: self.scaleFactor,
                                      y: self.scaleFactor)
                let rotateTrans = CGAffineTransform(
                    rotationAngle: CGFloat(self.angle * M_PI / 180))

                self.boxView!.transform =
                    scaleTrans.concatenating(rotateTrans)

                self.angle = (self.angle == 180 ? 360 : 180)
                self.scaleFactor = (self.scaleFactor == 2 ? 1 : 2)
                self.boxView?.backgroundColor = UIColor.purple
                self.boxView?.center = location
            }

            animator.addCompletion {_ in
                self.boxView?.backgroundColor = UIColor.green
            }
            animator.startAnimation()
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

