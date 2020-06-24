//
//  TodayViewController.swift
//  MyLocation
//
//  Created by Neil Smyth on 10/10/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
        
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!

    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestLocation()
    }

    @IBAction func openApp(_ sender: AnyObject) {
        let url: URL? = URL(string: "location:")!

        if let appurl = url {
            self.extensionContext!.open(appurl,
                completionHandler: nil)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
            updateWidget()
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func updateWidget()
    {
         if currentLocation != nil {
             let latitudeText = String(format: "Lat: %.4f", 
                            currentLocation!.coordinate.latitude)

             let longitudeText = String(format: "Lon: %.4f",
                            currentLocation!.coordinate.longitude)

             latitudeLabel.text = latitudeText
             longitudeLabel.text = longitudeText
          }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
updateWidget()
        completionHandler(NCUpdateResult.newData)
    }
    
}
