//
//  ViewController.swift
//  Database
//
//  Created by Neil Smyth on 10/5/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    var databasePath = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, 
                       in: .userDomainMask)

        databasePath = dirPaths[0].appendingPathComponent("contacts.db").path

        if !filemgr.fileExists(atPath: databasePath as String) {

            let contactDB = FMDatabase(path: databasePath as String)

            if contactDB == nil {
                print("Error: \(contactDB?.lastErrorMessage())")
            }

            if (contactDB?.open())! {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !(contactDB?.executeStatements(sql_stmt))! {
                    print("Error: \(contactDB?.lastErrorMessage())")
                }
                contactDB?.close()
            } else {
                print("Error: \(contactDB?.lastErrorMessage())")
            }
        }

    }

    @IBAction func saveData(_ sender: AnyObject) {
        let contactDB = FMDatabase(path: databasePath as String)

        if (contactDB?.open())! {

            let insertSQL = "INSERT INTO CONTACTS (name, address, phone) VALUES ('\(name.text!)', '\(address.text!)', '\(phone.text!)')"

            let result = contactDB?.executeUpdate(insertSQL,
                                                  withArgumentsIn: nil)

            if !result! {
                status.text = "Failed to add contact"
                print("Error: \(contactDB?.lastErrorMessage())")
            } else {
                status.text = "Contact Added"
                name.text = ""
                address.text = ""
                phone.text = ""
            }
        } else {
            print("Error: \(contactDB?.lastErrorMessage())")
        }

    }
    
    @IBAction func findContact(_ sender: AnyObject) {
        let contactDB = FMDatabase(path: databasePath as String)

        if (contactDB?.open())! {
            let querySQL = "SELECT address, phone FROM CONTACTS WHERE name = '\(name.text!)'"

            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                   withArgumentsIn: nil)

            if results?.next() == true {
                address.text = results?.string(forColumn: "address")
                phone.text = results?.string(forColumn: "phone")
                status.text = "Record Found"
            } else {
                status.text = "Record not found"
                address.text = ""
                phone.text = ""
            }
            contactDB?.close()
        } else {
            print("Error: \(contactDB?.lastErrorMessage())")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

