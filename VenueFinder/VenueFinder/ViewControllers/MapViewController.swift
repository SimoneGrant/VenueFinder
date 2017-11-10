//
//  MapViewController.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var restaurants = [Venue]()
    var currentLocation = CLLocation(latitude: 40.7, longitude: -74)
    let locationManager: CLLocationManager = {
        let locMan: CLLocationManager = CLLocationManager()
        locMan.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locMan.distanceFilter = 50.0
        return locMan
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        getLocationUpdate()
    }
    
    func getData() {
        let url = "\(Network.FourSquare.baseURL)/?ll=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&venuePhotos=1&client_id=\(Auth.init().clientID)&client_secret=\(Auth.init().clientSecret)&v=20181124&query=vegan"
        APIRequestManager.sharedManager.fetchFSData(endPoint: url) { (restaurant) in
            for group in restaurant.response.groups {
                for items in group.items {
                    self.restaurants.append(items.venue)
                }
            }
            DispatchQueue.main.async {
                self.loadAnnotations()
            }
        }
    }
    
    //Location Manager
    func getLocationUpdate() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //center map on user location
        centerMapOnLocation(location: currentLocation)
        //        mapView.userTrackingMode = .follow
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.locationServicesEnabled() {
            currentLocation = locationManager.location!
        }
        getData()
    }
    
    let regionRadius: CLLocationDistance = 1100
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error encountered")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    //Map
    func loadAnnotations() {
        for dict in restaurants {
            let latitude = CLLocationDegrees(Double(dict.location.lat))
            let longitude = CLLocationDegrees(Double(dict.location.lng))
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = dict.name
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = name
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? RestaurantAnnotation else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
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

