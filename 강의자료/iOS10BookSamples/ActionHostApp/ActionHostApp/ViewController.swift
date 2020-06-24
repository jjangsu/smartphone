//
//  ViewController.swift
//  ActionHostApp
//
//  Created by Neil Smyth on 10/10/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {

    @IBOutlet weak var myTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showActionView(_ sender: AnyObject) {
        let activityViewController =
            UIActivityViewController(activityItems:
                [myTextView.text], applicationActivities: nil)
        
        self.present(activityViewController,
                     animated:true, completion: nil)
        
        activityViewController.completionWithItemsHandler =
            { (activityType, completed, returnedItems, error) in
                if returnedItems!.count > 0 {
                
                let textItem: NSExtensionItem =
                    returnedItems![0] as! NSExtensionItem
                
                
                let textItemProvider =
                    textItem.attachments![0] as! NSItemProvider
                
                if textItemProvider.hasItemConformingToTypeIdentifier(
                    kUTTypeText as String) {
                    
                    textItemProvider.loadItem(
                        forTypeIdentifier: kUTTypeText as String,
                        options: nil,
                        completionHandler: {(string, error) -> Void in
                            let newtext = string as! String
                            self.myTextView.text = newtext
                    })
                }
            }
        }
    }

    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

