//
//  RouteViewController.swift
//  MapSample
//
//  Created by Neil Smyth on 10/9/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var destination: MKMapItem?
    @IBOutlet weak var routeMap: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routeMap.delegate = self
        routeMap.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestLocation()

    }

    func getDirections() {

        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination!
        request.requestsAlternateRoutes = false

        let directions = MKDirections(request: request)

        directions.calculate(completionHandler: {(response, error) in

            if error != nil {
                print("Error getting directions")
            } else {
                self.showRoute(response!)
            }
        })
    }

    func showRoute(_ response: MKDirectionsResponse) {

        for route in response.routes {

            routeMap.add(route.polyline,
                    level: MKOverlayLevel.aboveRoads)

            for step in route.steps {
                print(step.instructions)
            }
        }

        let region =
             MKCoordinateRegionMakeWithDistance(userLocation!.coordinate,
                            2000, 2000)

        routeMap.setRegion(region, animated: true)
    }

    func mapView(_ mapView: MKMapView, rendererFor
            overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)

        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        self.getDirections()

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
