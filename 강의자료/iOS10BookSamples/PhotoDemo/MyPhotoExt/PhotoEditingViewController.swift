//
//  PhotoEditingViewController.swift
//  MyPhotoExt
//
//  Created by Neil Smyth on 10/10/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class PhotoEditingViewController: UIViewController, PHContentEditingController {

    @IBOutlet weak var imageView: UIImageView!
    var input: PHContentEditingInput?
    var displayedImage: UIImage?
    var imageOrientation: Int32?
    var currentFilter = "CIColorInvert"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sepiaSelected(_ sender: AnyObject) {
        currentFilter = "CISepiaTone"

        if displayedImage != nil {
            imageView.image = performFilter(displayedImage!, 
					orientation: nil)
        }

    }
    
    @IBAction func monoSelected(_ sender: AnyObject) {
        currentFilter = "CIPhotoEffectMono"

        if displayedImage != nil {
            imageView.image = performFilter(displayedImage!, 
					orientation: nil)
        }

    }
    
    @IBAction func invertSelected(_ sender: AnyObject) {
        currentFilter = "CIColorInvert"

        if displayedImage != nil {
            imageView.image = performFilter(displayedImage!, 
					orientation: nil)
        }

    }
    
    func performFilter(_ inputImage: UIImage, orientation: Int32?)
                        -> UIImage?
    {
        var resultImage: UIImage?
        var cimage: CIImage
        cimage = CIImage(image: inputImage)!

        if orientation != nil {
            cimage = cimage.applyingOrientation(orientation!)
        }

        if let filter = CIFilter(name: currentFilter) {
            filter.setDefaults()
            filter.setValue(cimage, forKey: "inputImage")

            switch currentFilter {

                case "CISepiaTone", "CIEdges":
                    filter.setValue(0.8, forKey: "inputIntensity")

                case "CIMotionBlur":
                    filter.setValue(25.00, forKey:"inputRadius")
                    filter.setValue(0.00, forKey:"inputAngle")

                default:
                    break
            }
            let ciFilteredImage = filter.outputImage
            let context = CIContext(options: nil)
            let cgImage = context.createCGImage(ciFilteredImage!,
                                      from: ciFilteredImage!.extent)
            resultImage = UIImage(cgImage: cgImage!)
        }
        return resultImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PHContentEditingController
    
    func canHandle(_ adjustmentData: PHAdjustmentData) -> Bool {
        return false
    }
    
    func startContentEditing(with contentEditingInput: PHContentEditingInput, placeholderImage: UIImage) {
        input = contentEditingInput

        if input != nil {
            displayedImage = input!.displaySizeImage
            imageOrientation = input!.fullSizeImageOrientation
            imageView.image = displayedImage
        }
    }
    
    func finishContentEditing(completionHandler: @escaping ((PHContentEditingOutput?) -> Void)) {
        DispatchQueue.global().async {
            let output = PHContentEditingOutput(contentEditingInput: self.input!)
            
        let url = self.input?.fullSizeImageURL

        if let imageUrl = url {
            let fullImage = UIImage(contentsOfFile:
                imageUrl.path)

            let resultImage = self.performFilter(fullImage!,
                orientation: self.imageOrientation)

            if let renderedJPEGData =
                UIImageJPEGRepresentation(resultImage!, 0.9) {
                try! renderedJPEGData.write(to: 
			output.renderedContentURL)
            }
            let archivedData =
                NSKeyedArchiver.archivedData(
                    withRootObject: self.currentFilter)

            let adjustmentData =
            PHAdjustmentData(formatIdentifier:
                        "com.ebookfrenzy.photoext",
                formatVersion: "1.0",
                        data: archivedData)

            output.adjustmentData = adjustmentData
        }

            completionHandler(output)
            
            // Clean up temporary files, etc.
        }
    }
    
    var shouldShowCancelConfirmation: Bool {
        // Determines whether a confirmation to discard changes should be shown to the user on cancel.
        // (Typically, this should be "true" if there are any unsaved changes.)
        return false
    }
    
    func cancelContentEditing() {
        // Clean up temporary files, etc.
        // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
    }

}
