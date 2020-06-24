//
//  ViewController.swift
//  MapItem
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import Contacts
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    var coords: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func getDirections(_ sender: AnyObject) {
        
        let addressString = "\(address.text) \(city.text) \(state.text) \(zip.text)"
        
        CLGeocoder().geocodeAddressString(addressString, completionHandler:
            {(placemarks, error) in

            if error != nil {
                print("Geocode failed with error: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let location = placemark.location
                self.coords = location!.coordinate
                self.showMap()
            }
        })

    }
    
    func showMap() {
        let addressDict =
               [CNPostalAddressStreetKey: address.text!,
                CNPostalAddressCityKey: city.text!,
                CNPostalAddressStateKey: state.text!,
                CNPostalAddressPostalCodeKey: zip.text!]

        let place = MKPlacemark(coordinate: coords!,
                                 addressDictionary: addressDict)

        let mapItem = MKMapItem(placemark: place)

        let options = [MKLaunchOptionsDirectionsModeKey:
                            MKLaunchOptionsDirectionsModeDriving]

        mapItem.openInMaps(launchOptions: options)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

