//
//  SecondViewController.swift
//  StateApp
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var myTextView: UITextView!
    var thirdViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thirdViewController = ThirdViewController(nibName: 
				"ThirdViewController", bundle: nil)
    }

    @IBAction func displayVC3(_ sender: AnyObject) {
        self.navigationController?.pushViewController(
                thirdViewController!, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(myTextView.text, forKey:"UnsavedText")
        super.encodeRestorableState(with: coder)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        if let decodedObj = coder.decodeObject(forKey: "UnsavedText") {
            myTextView.text = decodedObj as! String
        }
        super.decodeRestorableState(with: coder)
    }


}

