//
//  ThirdViewController.swift
//  StateApp
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UIViewControllerRestoration {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.restorationIdentifier = "thirdViewController"
        self.restorationClass = ThirdViewController.self
    }

class func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
    let myViewController = ThirdViewController(nibName:
        "ThirdViewController", bundle: nil)
    return myViewController
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
