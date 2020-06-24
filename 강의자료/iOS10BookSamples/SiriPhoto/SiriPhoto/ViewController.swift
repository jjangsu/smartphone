//
//  ViewController.swift
//  SiriPhoto
//
//  Created by Neil Smyth on 10/11/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import Intents
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        INPreferences.requestSiriAuthorization({status in
            // Handle errors here
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleActivity(_ userActivity: NSUserActivity) {

        let intent = userActivity.interaction?.intent 
                as! INSearchForPhotosIntent

        if (intent.dateCreated?.startDateComponents) != nil {
            let calendar = Calendar(identifier: .gregorian)
            let startDate = calendar.date(from: 
            (intent.dateCreated?.startDateComponents)!)
            let endDate = calendar.date(from: 
            (intent.dateCreated?.endDateComponents)!)
            displayPhoto(startDate!, endDate!)
        }
    }

    func displayPhoto(_ startDate: Date, _ endDate: Date) {

        let fetchOptions = PHFetchOptions()

        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate as CVarArg, endDate as CVarArg)
        let fetchResult = PHAsset.fetchAssets(with: 
            PHAssetMediaType.image, options: fetchOptions)

        let imgManager = PHImageManager.default()

        imgManager.requestImage(for: fetchResult.firstObject! as PHAsset, 
            targetSize: view.frame.size, 
            contentMode: PHImageContentMode.aspectFill, 
            options: nil, 
            resultHandler: { (image, _) in
            self.imageView.image = image
        })
    }


}

