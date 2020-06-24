//
//  MyUIView.swift
//  3DTouchForce
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class MyUIView: UIView {

    var size:CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        let view_width = self.bounds.width
        let view_height = self.bounds.height

        let context = UIGraphicsGetCurrentContext()
        let rectangle = CGRect(x: 0, y: view_height - size,
				width: view_width, height: size)
        context?.addRect(rectangle)
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(rectangle)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
        handleTouch(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
        handleTouch(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
        size = 0
        self.setNeedsDisplay()
    }

    func handleTouch(_ touches:Set<UITouch>) {
        let touch = touches.first
        size = touch!.force * 100
        self.setNeedsDisplay()
    }

}
