//
//  ViewController.swift
//  iCloudStore
//
//  Created by Neil Smyth on 10/5/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var document: MyDocument?
    var documentURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        let filemgr = FileManager.default

        let dirPaths = filemgr.urls(for: .documentDirectory,
                                     in: .userDomainMask)

        documentURL = dirPaths[0].appendingPathComponent("savefile.txt")

        document = MyDocument(fileURL: documentURL!)
        document!.userText = ""

        if filemgr.fileExists(atPath: (documentURL?.path)!) {

            document?.open(completionHandler: {(success: Bool) -> Void in
                if success {
                    print("File open OK")
                    self.textView.text = self.document?.userText
                } else {
                    print("Failed to open file")
                }
            })
        } else {
            document?.save(to: documentURL!, for: .forCreating,
                     completionHandler: {(success: Bool) -> Void in
                if success {
                    print("File created OK")
                } else {
                    print("Failed to create file ")
                }
            })
        }

    }

    @IBAction func saveDocument(_ sender: AnyObject) {
        document!.userText = textView.text

            document?.save(to: documentURL!,
                           for: .forOverwriting,
               completionHandler: {(success: Bool) -> Void in
            if success {
                print("File overwrite OK")
            } else {
                print("File overwrite failed")
            }
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

