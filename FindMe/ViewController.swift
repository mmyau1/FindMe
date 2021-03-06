//
//  ViewController.swift
//  FindMe
//
//  Created by Administrator on 8/2/21.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    // Press search button will location nearby hospitals and provide name and address
    @IBAction func searchButton(_ sender: Any) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Hospital"
        searchRequest.region = mapView.region
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if let response = response {
                for mapItem in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    annotation.title = mapItem.placemark.name
                    annotation.subtitle = mapItem.placemark.title
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    let manager = CLLocationManager()
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userLocation.title = "My Location"
        
    }
    // Search for user location and map will zoom in on user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            
            render(location)
            addPinAnnotationToMapView()
        }
        func render(_ location: CLLocation) {
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
            
        }
    }

    //manually adding a pin to the map
    
    func addPinAnnotationToMapView() {
        let coordinate = CLLocationCoordinate2D(latitude: 41.902149, longitude: -87.762802)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Westside Health Authority"
        annotation.subtitle = "5465 W Division St Chicago, IL"
        
        self.mapView.addAnnotation(annotation)
    }
    

}

