//
//  SecondViewController.swift
//  ReminderApp
//
//  Created by Neil Smyth on 10/10/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import EventKit
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationText: UITextField!
    let appDelegate = UIApplication.shared.delegate 
		as! AppDelegate
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    @IBAction func setLocationReminder(_ sender: AnyObject) {
        if appDelegate.eventStore == nil {
            appDelegate.eventStore = EKEventStore()

            appDelegate.eventStore?.requestAccess(
                to: EKEntityType.reminder, completion:
               {(granted, error) in
                   if !granted {
                       print("Access to store not granted")
                   } else {
                       print("Access granted")
                   }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let reminder = EKReminder(eventStore: appDelegate.eventStore!)
    reminder.title = locationText.text!
    reminder.calendar =
         appDelegate.eventStore!.defaultCalendarForNewReminders()

    let location = EKStructuredLocation(title: "Current Location")
    location.geoLocation = locations.last

    let alarm = EKAlarm()

    alarm.structuredLocation = location
    alarm.proximity = EKAlarmProximity.leave

    reminder.addAlarm(alarm)

    do {
        try appDelegate.eventStore?.save(reminder,
        commit: true)
    } catch let error {
        print("Reminder failed with error \(error.localizedDescription)")
    }
}

func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to get location: \(error.localizedDescription)")
}


}

