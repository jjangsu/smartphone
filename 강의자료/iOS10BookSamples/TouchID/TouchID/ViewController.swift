//
//  ViewController.swift
//  TouchID
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func testTouchID(_ sender: AnyObject) {
        
        let context = LAContext()

        var error: NSError?

        if context.canEvaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                        error: &error) {

              // Device can use TouchID
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Access requires authentication",
                        reply: {(success, error) in
                DispatchQueue.main.async {

                    if error != nil {

                        switch error!._code {

                            case LAError.Code.systemCancel.rawValue:
                                self.notifyUser("Session cancelled",
                        err: error?.localizedDescription)

                            case LAError.Code.userCancel.rawValue:
                            self.notifyUser("Please try again",
                          err: error?.localizedDescription)

                            case LAError.Code.userFallback.rawValue:
                                self.notifyUser("Authentication",
                        err: "Password option selected")
                                // Custom code to obtain password here

                            default:
                                self.notifyUser("Authentication failed",
                        err: error?.localizedDescription)
                        }

                    } else {
                        self.notifyUser("Authentication Successful",
                    err: "You now have full access")
                    }
                }
            })

        } else {
            // Device cannot use TouchID
            switch error!.code{

            case LAError.Code.touchIDNotEnrolled.rawValue:
                notifyUser("TouchID is not enrolled",
                        err: error?.localizedDescription)

            case LAError.Code.passcodeNotSet.rawValue:
                notifyUser("A passcode has not been set",
                        err: error?.localizedDescription)

            default:
                notifyUser("TouchID not available",
                        err: error?.localizedDescription)

            }
        }    

    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg, 
            message: err, 
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "OK", 
            style: .cancel, handler: nil)

        alert.addAction(cancelAction)

            self.present(alert, animated: true,
                completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

