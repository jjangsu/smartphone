//
//  Draw2D.swift
//  Draw2D
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class Draw2D: UIView {

    override func draw(_ rect: CGRect) {
    let myimage = UIImage(named: "tree.jpg")
    let cimage = CIImage(image: myimage!)

    let sepiaFilter = CIFilter(name: "CISepiaTone")
    sepiaFilter!.setDefaults()
    sepiaFilter!.setValue(cimage, forKey: "inputImage")
    sepiaFilter!.setValue(NSNumber(value: 0.8 as Float),
                forKey: "inputIntensity")

    let image = sepiaFilter!.outputImage

    let context = CIContext(options: nil)

    let cgImage = context.createCGImage(image!,
                from: image!.extent)

    let resultImage = UIImage(cgImage: cgImage!)
    let imageRect = UIScreen.main.bounds
    resultImage.draw(in: imageRect)

    }

}
