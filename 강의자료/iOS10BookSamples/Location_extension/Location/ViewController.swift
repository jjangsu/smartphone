//
//  ViewController.swift
//  Location
//
//  Created by Neil Smyth on 10/9/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var horizontalAccuracy: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var verticalAccuracy: UILabel!
    @IBOutlet weak var distance: UILabel!

    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil

    }

    @IBAction func resetDistance(_ sender: AnyObject) {
    startLocation = nil
    }
    
func locationManager(_ manager: CLLocationManager,
                didUpdateLocations locations: [CLLocation])
{
    let latestLocation: CLLocation = locations[locations.count - 1]

    latitude.text = String(format: "%.4f",
                         latestLocation.coordinate.latitude)
    longitude.text = String(format: "%.4f",
                         latestLocation.coordinate.longitude)
    horizontalAccuracy.text = String(format: "%.4f",
                         latestLocation.horizontalAccuracy)
    altitude.text = String(format: "%.4f",
                         latestLocation.altitude)
    verticalAccuracy.text = String(format: "%.4f",
                         latestLocation.verticalAccuracy)

    if startLocation == nil {
        startLocation = latestLocation
    }

    let distanceBetween: CLLocationDistance =
                latestLocation.distance(from: startLocation)

    distance.text = String(format: "%.2f", distanceBetween)
}

func locationManager(_ manager: CLLocationManager,
         didFailWithError error: Error) {

}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

