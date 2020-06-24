//
//  ViewController.swift
//  NotifyDemo
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    var messageSubtitle = "Staff Meeting in 20 minutes"

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: 
			[[.alert, .sound, .badge]], 
				completionHandler: { (granted, error) in
            // Handle Error
        })
        UNUserNotificationCenter.current().delegate = self
    }

    @IBAction func buttonPressed(_ sender: AnyObject) {
        sendNotification()
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Meeting Reminder"
        content.subtitle = messageSubtitle
        content.body = "Don't forget to bring coffee."
        content.badge = 1

        let repeatAction = UNNotificationAction(identifier:"repeat",
            title:"Repeat",options:[])
        let changeAction = UNTextInputNotificationAction(identifier: 
            "change", title: "Change Message", options: [])

        let category = UNNotificationCategory(identifier: "actionCategory",
             actions: [repeatAction, changeAction], 
            intentIdentifiers: [], options: [])

        content.categoryIdentifier = "actionCategory"

        UNUserNotificationCenter.current().setNotificationCategories([category])


        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, 
                repeats: false)

        let requestIdentifier = "demoNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier, 
                content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, 
            withCompletionHandler: { (error) in
                // Handle error
        })
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier {
            case "repeat":
                self.sendNotification()
            case "change":
                let textResponse = response 
                as! UNTextInputNotificationResponse 
                messageSubtitle = textResponse.userText
                self.sendNotification()
            default:
                break
        }
        completionHandler()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

