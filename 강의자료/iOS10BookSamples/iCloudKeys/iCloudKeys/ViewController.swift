//
//  ViewController.swift
//  iCloudKeys
//
//  Created by Neil Smyth on 10/5/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var keyStore: NSUbiquitousKeyValueStore?
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyStore = NSUbiquitousKeyValueStore()

        let storedString = keyStore?.string(forKey: "MyString")

        if let stringValue = storedString {
            textField.text = stringValue
        }

        NotificationCenter.default.addObserver(self,
             selector: #selector(
                  ViewController.ubiquitousKeyValueStoreDidChange),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: keyStore)
    }

    func ubiquitousKeyValueStoreDidChange(notification: NSNotification) {

        let alert = UIAlertController(title: "Change detected",
                message: "iCloud key-value-store change detected",
            preferredStyle: UIAlertControllerStyle.alert)

        let cancelAction = UIAlertAction(title: "OK",
                style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        self.present(alert, animated: true,
                    completion: nil)
        textField.text = keyStore?.string(forKey: "MyString")
    }

    
    @IBAction func saveKey(_ sender: AnyObject) {
        keyStore?.set(textField.text, forKey: "MyString")
        keyStore?.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

