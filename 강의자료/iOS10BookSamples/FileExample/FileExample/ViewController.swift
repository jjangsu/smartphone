//
//  ViewController.swift
//  FileExample
//
//  Created by Neil Smyth on 10/5/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textBox: UITextField!
    
    var fileMgr: FileManager = FileManager.default
    var docsDir: String?
    var dataFile: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let filemgr = FileManager.default

        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)

        dataFile = 
		dirPaths[0].appendingPathComponent("datafile.dat").path

        if fileMgr.fileExists(atPath: dataFile!) {
            let databuffer = fileMgr.contents(atPath: dataFile!)
            let datastring = NSString(data: databuffer!,
                                       encoding: String.Encoding.utf8.rawValue)
            textBox.text = datastring as? String
        }

    }
    
    @IBAction func saveText(_ sender: AnyObject) {
        let databuffer =
              (textBox.text)!.data(using: String.Encoding.utf8)

        fileMgr.createFile(atPath: dataFile!, contents: databuffer,
                                        attributes: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

