//
//  DetailTableViewExtension.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/17/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit
import MapKit

extension DetailTableViewController: MKMapViewDelegate {
    func setupMap() {
        mapView.delegate = self
//        mapView.showsScale = true
//        mapView.showsUserLocation = true
    }
    func addViewOnMap() {
        var destinationLocation: CLLocationCoordinate2D!
        let destinationAnnotation = MKPointAnnotation()
        
        if venue != nil {
            if let address = venue?.location.address, let city = venue?.location.city, let state = venue?.location.state, let zip = venue?.location.postalCode {
                let fullAddress = "\(address), \(city), \(state), \(zip)"
                geocoder.geocodeAddressString(fullAddress) { (placemarks, error) in
                    guard let placemarks = placemarks, let location = placemarks.first?.location else {
                        print("no location found")
                        return
                    }

                    destinationLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    
                    if let name = self.venue?.name {
                        destinationAnnotation.title = name
                    }
                    destinationAnnotation.coordinate = destinationLocation

                    
                    let currentPlacemark = MKPlacemark(coordinate: self.currentLocation.coordinate, addressDictionary: nil)
                    let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
                    
                    let currentMapItem = MKMapItem(placemark: currentPlacemark)
                    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                    
                    let currentAnnotation = MKPointAnnotation()
                    currentAnnotation.title = "Your Location"
                    currentAnnotation.coordinate = self.currentLocation.coordinate
                    
                    self.mapView.showAnnotations([currentAnnotation, destinationAnnotation], animated: true)
                    
                    let directionsRequest = MKDirectionsRequest()
                    directionsRequest.source = currentMapItem
                    directionsRequest.destination = destinationMapItem
                    directionsRequest.transportType = .walking
                    
                    //calculate the direction
                    let directions = MKDirections(request: directionsRequest)
                    directions.calculate { (response, error) in
                        guard let response = response else {
                            if let error = error {
                                print(error)
                            }
                            return
                        }
                        let route = response.routes[0]
                        self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                        
                        let rect = route.polyline.boundingMapRect
                        self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                    }
                    
                    
                }
            }
        } else {
            
            if let address = vgVenue?.address1, let city = vgVenue?.city, let region = vgVenue?.region, let zip = vgVenue?.postal_code {
                let fullAddress = "\(address), \(city), \(region), \(zip)"
                geocoder.geocodeAddressString(fullAddress) { (placemarks, error) in
                    guard let placemarks = placemarks, let location = placemarks.first?.location else {
                        print("no location found")
                        return
                    }
                    
                    destinationLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    
                    if let name = self.vgVenue?.name {
                        destinationAnnotation.title = name
                    }
                    destinationAnnotation.coordinate = destinationLocation
                    
                    let currentPlacemark = MKPlacemark(coordinate: self.currentLocation.coordinate, addressDictionary: nil)
                    let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
                    
                    let currentMapItem = MKMapItem(placemark: currentPlacemark)
                    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                    
                    let currentAnnotation = MKPointAnnotation()
                    currentAnnotation.title = "Your Location"
                    currentAnnotation.coordinate = self.currentLocation.coordinate
                    
                    self.mapView.showAnnotations([currentAnnotation, destinationAnnotation], animated: true)
                    
                    let directionsRequest = MKDirectionsRequest()
                    directionsRequest.source = currentMapItem
                    directionsRequest.destination = destinationMapItem
                    directionsRequest.transportType = .walking
                    
                    //calculate the direction
                    let directions = MKDirections(request: directionsRequest)
                    directions.calculate { (response, error) in
                        guard let response = response else {
                            if let error = error {
                                print(error)
                            }
                            return
                        }
                        let route = response.routes[0]
                        self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                        
                        let rect = route.polyline.boundingMapRect
                        self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                    }

                }
            }
        }

    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0
        return renderer
    }
}
