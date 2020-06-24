//
//  ViewController.swift
//  SocialApp
//
//  Created by Neil Smyth on 10/10/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func selectImage(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType =
                    UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true,
                    completion: nil)

    }
    
    @IBAction func sendPost(_ sender: AnyObject) {
        var activityItems: [AnyObject]?

        if (postImage.image != nil) {
            activityItems = [postText.text as AnyObject, postImage.image!]
        } else {
            activityItems = [postText.text as AnyObject]
        }

        let activityController = UIActivityViewController(activityItems:
                    activityItems!, applicationActivities: nil)
        self.present(activityController, animated: true,
                    completion: nil)


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        postText.endEditing(true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        postImage.image = image
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

