//
//  ViewController.swift
//  MapSample
//
//  Created by Neil Smyth on 10/9/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self 
    }

    @IBAction func zoomIn(_ sender: AnyObject) {
        let userLocation = mapView.userLocation

        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 2000, 2000)

        mapView.setRegion(region, animated: true)

    }
    
    @IBAction func changeMapType(_ sender: AnyObject) {
        if mapView.mapType == MKMapType.standard {
            mapView.mapType = MKMapType.satellite
        } else {
            mapView.mapType = MKMapType.standard
        }

    }
    
    @IBAction func textFieldReturn(_ sender: AnyObject) {
        _ = sender.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        self.performSearch()
    }

    func performSearch() {

        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText.text
        request.region = mapView.region

        let search = MKLocalSearch(request: request)

        search.start(completionHandler: {(response, error) in

            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")

                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")

                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
         })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as!
                        ResultsTableViewController

        destination.mapItems = self.matchingItems
    }


    func mapView(_ mapView: MKMapView, didUpdate
            userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

