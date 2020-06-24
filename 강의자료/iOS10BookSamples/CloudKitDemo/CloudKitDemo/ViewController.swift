//
//  ViewController.swift
//  CloudKitDemo
//
//  Created by Neil Smyth on 10/6/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import CloudKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var commentsField: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    let container = CKContainer.default
    var privateDatabase: CKDatabase?
    var currentRecord: CKRecord?
    var photoURL: URL?
    var recordZone: CKRecordZone?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        privateDatabase = container().privateCloudDatabase
        recordZone = CKRecordZone(zoneName: "HouseZone")

         privateDatabase?.save(recordZone!, 
		completionHandler: {(recordzone, error) in
            if (error != nil) {
                self.notifyUser("Record Zone Error", 
			message: "Failed to create custom record zone.")
            } else {
                print("Saved record zone")
            }
         })
        
        let predicate = NSPredicate(format: "TRUEPREDICATE")

        let subscription = CKQuerySubscription(recordType: "Houses",
                              predicate: predicate,
                              options: .firesOnRecordCreation)

        let notificationInfo = CKNotificationInfo()

        notificationInfo.alertBody = "A new House was added"
        notificationInfo.shouldBadge = true

        subscription.notificationInfo = notificationInfo

        privateDatabase?.save(subscription,
                  completionHandler: ({returnRecord, error in
            if let err = error {
                print("subscription failed %@",
                            err.localizedDescription)
            } else {
                DispatchQueue.main.async() {
                    self.notifyUser("Success",
                        message: "Subscription set up successfully")
                }
            }
        }))

    }

    override func touchesBegan(_ touches: Set<UITouch>,
                       with event: UIEvent?) {
        addressField.endEditing(true)
        commentsField.endEditing(true)
    }

    @IBAction func shareRecord(_ sender: AnyObject) {
        let controller = UICloudSharingController { controller,
            preparationCompletionHandler in
            let share = CKShare(rootRecord: self.currentRecord!)

            share[CKShareTitleKey] = "An Amazing House" as CKRecordValue
            share.publicPermission = .readOnly

            let modifyRecordsOperation = CKModifyRecordsOperation(
                recordsToSave: [self.currentRecord!, share], 
                recordIDsToDelete: nil)

            modifyRecordsOperation.timeoutIntervalForRequest = 10
            modifyRecordsOperation.timeoutIntervalForResource = 10

            modifyRecordsOperation.modifyRecordsCompletionBlock = { 
                records, recordIDs, error in
                if error != nil {
                    print(error?.localizedDescription)
                }
                preparationCompletionHandler(share, 
                    CKContainer.default(), error)
            }
            self.privateDatabase?.add(modifyRecordsOperation)
        }

        controller.availablePermissions = [.allowPublic, .allowReadOnly]
        controller.popoverPresentationController?.barButtonItem = 
                    sender as? UIBarButtonItem

        present(controller, animated: true)

    }

    func fetchShare(_ metadata: CKShareMetadata) {

        let operation = CKFetchRecordsOperation(
            recordIDs: [metadata.rootRecordID])

        operation.perRecordCompletionBlock = { record, _, error in


            if error != nil {
                print(error?.localizedDescription)
            }

            if record != nil {
                DispatchQueue.main.async() {
                    self.currentRecord = record
                    self.addressField.text =
                        record?.object(forKey: "address") as? String
                    self.commentsField.text =
                        record?.object(forKey: "comment") as? String
                    let photo =
                        record?.object(forKey: "photo") as! CKAsset
                    let image = UIImage(contentsOfFile:
                        photo.fileURL.path)
                    self.imageView.image = image
                    self.photoURL = self.saveImageToFile(image!)
                }
            }
        }

        operation.fetchRecordsCompletionBlock = { _, error in
            if error != nil {
                print(error?.localizedDescription)
            }
        }

        CKContainer.default().sharedCloudDatabase.add(operation)
    }

    @IBAction func saveRecord(_ sender: AnyObject) {
        if (photoURL == nil) {
            notifyUser("No Photo", 
        message: "Use the Photo option to choose a photo for the record")
            return
        }

        let asset = CKAsset(fileURL: photoURL!)
        let myRecord = CKRecord(recordType: "Houses", 
                        zoneID: (recordZone?.zoneID)!)

        myRecord.setObject(addressField.text as CKRecordValue?, 
                        forKey: "address")

        myRecord.setObject(commentsField.text as CKRecordValue?, 
                        forKey: "comment")

        myRecord.setObject(asset, forKey: "photo")


        let modifyRecordsOperation = CKModifyRecordsOperation(
            recordsToSave: [myRecord], 
            recordIDsToDelete: nil)

        modifyRecordsOperation.timeoutIntervalForRequest = 10
        modifyRecordsOperation.timeoutIntervalForResource = 10

        modifyRecordsOperation.modifyRecordsCompletionBlock = 
            { records, recordIDs, error in
            if let err = error {
                self.notifyUser("Save Error", message:
                    err.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.notifyUser("Success",
                                    message: "Record saved successfully")
                }
                self.currentRecord = myRecord
            }
        }
        privateDatabase?.add(modifyRecordsOperation)

    }
    
    @IBAction func queryRecord(_ sender: AnyObject) {
        let predicate = NSPredicate(format: "address = %@", 
                    addressField.text!)

        let query = CKQuery(recordType: "Houses", predicate: predicate)

        privateDatabase?.perform(query, inZoneWith: recordZone?.zoneID,
                      completionHandler: ({results, error in

            if (error != nil) {
                DispatchQueue.main.async() {
                    self.notifyUser("Cloud Access Error",
                        message: error!.localizedDescription)
                }
            } else {
                if results!.count > 0 {

                    let record = results![0]
                    self.currentRecord = record

                    DispatchQueue.main.async() {

                        self.commentsField.text =
                           record.object(forKey: "comment") as! String

                        let photo =
                           record.object(forKey: "photo") as! CKAsset

                        let image = UIImage(contentsOfFile:
                            photo.fileURL.path)

                        self.imageView.image = image
                        self.photoURL = self.saveImageToFile(image!)
                    }
                } else {
                    DispatchQueue.main.async() {
                        self.notifyUser("No Match Found",
                         message: "No record matching the address was found")
                    }
                }
            }
        }))

    }
    
    @IBAction func selectPhoto(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.sourceType =
               UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]

        self.present(imagePicker, animated: true,
                         completion:nil)

    }
    
    @IBAction func updateRecord(_ sender: AnyObject) {
       if let record = currentRecord {

            let asset = CKAsset(fileURL: photoURL!)

            record.setObject(addressField.text as CKRecordValue?, 
                    forKey: "address")
            record.setObject(commentsField.text as CKRecordValue?, 
                    forKey: "comment")
            record.setObject(asset, forKey: "photo")

            privateDatabase?.save(record, completionHandler:
              ({returnRecord, error in
                if let err = error {
                    DispatchQueue.main.async() {
                        self.notifyUser("Update Error",
                              message: err.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async() {
                        self.notifyUser("Success", message:
                                "Record updated successfully")
                    }
                }
            }))
        } else {
            notifyUser("No Record Selected", message:
                    "Use Query to select a record to update")
        }

    }
    
    @IBAction func deleteRecord(_ sender: AnyObject) {
        if let record = currentRecord {

            privateDatabase?.delete(withRecordID: record.recordID,
                    completionHandler: ({returnRecord, error in
                if let err = error {
                    DispatchQueue.main.async() {
                        self.notifyUser("Delete Error", message:
                                         err.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async() {
                        self.notifyUser("Success", message:
                               "Record deleted successfully")
                    }
                }
            }))
        } else {
            notifyUser("No Record Selected", message:
                            "Use Query to select a record to delete")
        }

    }
    

    func fetchRecord(_ recordID: CKRecordID) -> Void
    {

        privateDatabase?.fetch(withRecordID: recordID,
                         completionHandler: ({record, error in
            if let err = error {
                DispatchQueue.main.async() {
                    self.notifyUser("Fetch Error", message:
                       err.localizedDescription)
                }
            } else {
                DispatchQueue.main.async() {
                    self.currentRecord = record
                    self.addressField.text =
                       record!.object(forKey: "address") as? String
                    self.commentsField.text =
                       record!.object(forKey: "comment") as? String
                    let photo =
                       record!.object(forKey: "photo") as! CKAsset

                    let image = UIImage(contentsOfFile:
                       photo.fileURL.path)
                    self.imageView.image = image
                    self.photoURL = self.saveImageToFile(image!)
                }
            }
        }))
    }

    func notifyUser(_ title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title,
                            message: message,
                        preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "OK",
                style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        self.present(alert, animated: true,
                    completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image =
            info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        photoURL = saveImageToFile(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func saveImageToFile(_ image: UIImage) -> URL
    {
        let filemgr = FileManager.default

        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)

        let fileURL = dirPaths[0].appendingPathComponent("currentImage.jpg")

        if let renderedJPEGData =
                    UIImageJPEGRepresentation(image, 0.5) {
            try! renderedJPEGData.write(to: fileURL)
        }

        return fileURL
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

