//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Neil Smyth on 10/6/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    let managedObjectContext = (UIApplication.shared.delegate
                as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveContact(_ sender: AnyObject) {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Contacts",
                                       in: managedObjectContext)

        let contact = Contacts(entity: entityDescription!,
            insertInto: managedObjectContext)

        contact.name = name.text!
        contact.address = address.text!
        contact.phone = phone.text!

        do {
            try managedObjectContext.save()
            name.text = ""
            address.text = ""
            phone.text = ""
            status.text = "Contact Saved"

        } catch let error {
            status.text = error.localizedDescription
        }

    }
    
    @IBAction func findContact(_ sender: AnyObject) {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Contacts",
                                       in: managedObjectContext)

        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.entity = entityDescription

        let pred = NSPredicate(format: "(name = %@)", name.text!)
        request.predicate = pred

        do {
            var results =
                 try managedObjectContext.fetch(request as! 
                NSFetchRequest<NSFetchRequestResult>)

            if results.count > 0 {
                let match = results[0] as! NSManagedObject

                name.text = match.value(forKey: "name") as? String
                address.text = match.value(forKey: "address") as? String
                phone.text = match.value(forKey: "phone") as? String
                status.text = "Matches found: \(results.count)"
            } else {
                status.text = "No Match"
            }

        } catch let error {
             status.text = error.localizedDescription
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

