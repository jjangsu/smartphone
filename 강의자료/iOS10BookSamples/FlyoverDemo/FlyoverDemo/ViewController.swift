//
//  ViewController.swift
//  FlyoverDemo
//
//  Created by Neil Smyth on 10/9/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let distance: CLLocationDistance = 650
    let pitch: CGFloat = 65
    let heading = 0.0
    var camera: MKMapCamera?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .satelliteFlyover

        let coordinate = CLLocationCoordinate2D(latitude: 40.7484405,
            longitude: -73.9856644)
        camera = MKMapCamera(lookingAtCenter: coordinate,
            fromDistance: distance,
            pitch: pitch,
            heading: heading)
        mapView.camera = camera!

    }

    @IBAction func animateCamera(_ sender: AnyObject) {
        UIView.animate(withDuration: 20.0, animations: {
            self.camera!.heading += 180
            self.camera!.pitch = 25
            self.mapView.camera = self.camera!
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

