//
//  TileView.swift
//  Anagrams
//
//  Created by kpugame on 2020/05/27.
//  Copyright © 2020 Caroline. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

protocol TileDragDelegateProtocol {
    func tileView(tileView: TileView, didDragToPoint: CGPoint)
}

class TileView: UIImageView {
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0
    
    var dragDelegate: TileDragDelegateProtocol?
    
    var tempTransfrom: CGAffineTransform = CGAffineTransform.identity
    
    var letter : Character
    
    var isMatched : Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(letter:, sideLength:")
    }
    
    init(letter: Character, sideLength: CGFloat) {
        self.letter = letter
        
        let image = UIImage(named: "tile")!
        
        super.init(image: image)
        
        let scale = sideLength / image.size.width
        self.frame = CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale)
        
        
        let letterLabel = UILabel(frame: self.bounds)
        letterLabel.textAlignment = NSTextAlignment.center
        letterLabel.textColor = UIColor.white
        letterLabel.backgroundColor = UIColor.clear
        letterLabel.text = String(letter).uppercased()
        letterLabel.font = UIFont(name: "Verdana-Bold", size: 78 * scale)
        self.addSubview(letterLabel)
        
        self.isUserInteractionEnabled = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        self.layer.shadowRadius = 15.0
        self.layer.masksToBounds = false
        
        let path = UIBezierPath(rect: self.bounds)
        self.layer.shadowPath = path.cgPath
        
    }
    
    func randomize() {
        let rotation = CGFloat(randomNumber(minX: 0, maxX: 50)) / 100 - 0.2
        
        self.transform = CGAffineTransform(rotationAngle: rotation)
        
        let yOffset = CGFloat(randomNumber(minX: 0, maxX: 10) - 10)
        self.center = CGPoint(x: self.center.x, y: self.center.y + yOffset)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint = touch.location(in: self.superview)
            xOffset = touchPoint.x - self.center.x
            yOffset = touchPoint.y - self.center.y
        }
        
        self.layer.shadowOpacity = 0.8
        
        tempTransfrom = self.transform
        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.superview?.bringSubviewToFront(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint = touch.location(in: self.superview)
            self.center = CGPoint(x: touchPoint.x - xOffset, y: touchPoint.y - yOffset)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesMoved(touches, with: event)
        self.dragDelegate?.tileView(tileView: self, didDragToPoint: self.center)
        self.layer.shadowOpacity = 0
        
        self.transform = tempTransfrom
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = tempTransfrom
        self.layer.shadowOpacity = 0
    }
}
