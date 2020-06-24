//
//  ViewController.swift
//  StoreKitDemo
//
//  Created by Neil Smyth on 10/10/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController,	SKStoreProductViewControllerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showStoreView(_ sender: AnyObject) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self

        let parameters = [SKStoreProductParameterITunesItemIdentifier :
                            NSNumber(value: 676059878)]

        storeViewController.loadProduct(withParameters: parameters,
                    completionBlock: {result, error in
            if result {
                self.present(storeViewController,
                            animated: true, completion: nil)
            }
        })

    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

