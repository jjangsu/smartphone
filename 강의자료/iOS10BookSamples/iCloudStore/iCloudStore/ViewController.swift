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
    var ubiquityURL: URL?
    var metaDataQuery: NSMetadataQuery?


    override func viewDidLoad() {
        super.viewDidLoad()
        let filemgr = FileManager.default

        ubiquityURL = filemgr.url(forUbiquityContainerIdentifier: nil)

        guard ubiquityURL != nil else {
            print("Unable to access iCloud Account")
            print("Open the Settings app and enter your Apple ID into iCloud settings")
            return
        }

        ubiquityURL = ubiquityURL?.appendingPathComponent(
                        "Documents/savefile.txt")

        metaDataQuery = NSMetadataQuery()

        metaDataQuery?.predicate =
            NSPredicate(format: "%K like 'savefile.txt'",
                NSMetadataItemFSNameKey)
        metaDataQuery?.searchScopes = 
            [NSMetadataQueryUbiquitousDocumentsScope]

        NotificationCenter.default.addObserver(self,
            selector: #selector(
                   ViewController.metadataQueryDidFinishGathering),
            name: NSNotification.Name.NSMetadataQueryDidFinishGathering,
            object: metaDataQuery!)

        metaDataQuery!.start()
        
    }

    @IBAction func saveDocument(_ sender: AnyObject) {
        document!.userText = textView.text

            document?.save(to: ubiquityURL!,
                           for: .forOverwriting,
                  completionHandler: {(success: Bool) -> Void in
            if success {
                print("Save overwrite OK")
            } else {
                print("Save overwrite failed")
            }
        })
    }
    
    func metadataQueryDidFinishGathering(notification: NSNotification) -> Void
    {
        let query: NSMetadataQuery = notification.object as! NSMetadataQuery
        
        query.disableUpdates()
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSMetadataQueryDidFinishGathering,
                                                  object: query)
        
        query.stop()
        
        let resultURL = query.value(ofAttribute: NSMetadataItemURLKey, forResultAt: 0) as! URL
        print(resultURL.path)
        
        
        if query.resultCount == 1 {
            let resultURL = query.value(ofAttribute: NSMetadataItemURLKey, forResultAt: 0) as! URL
            
            document = MyDocument(fileURL: resultURL as URL)
            
            document?.open(completionHandler: {(success: Bool) -> Void in
                if success {
                    print("iCloud file open OK")
                    self.textView.text = self.document?.userText
                    self.ubiquityURL = resultURL as URL
                } else {
                    print("iCloud file open failed")
                }
            })
        } else {
            document = MyDocument(fileURL: ubiquityURL!)
            
            document?.save(to: ubiquityURL!,
                           for: .forCreating,
                           completionHandler: {(success: Bool) -> Void in
                            if success {
                                print("iCloud create OK")
                            } else {
                                print("iCloud create failed")
                            }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

