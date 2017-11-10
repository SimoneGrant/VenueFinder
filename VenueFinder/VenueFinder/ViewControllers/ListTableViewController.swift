//
//  ListTableViewController.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit
import CoreLocation

class ListTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var restaurantsFS = [Venue]()
    var restaurantsVG = [Entries]()
    var restaurantsYelp = [Details]()
    var currentLocation = CLLocation(latitude: 40.7, longitude: -74)
    let geocoder = CLGeocoder()
    let locationManager: CLLocationManager = {
        let locMan: CLLocationManager = CLLocationManager()
        locMan.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locMan.distanceFilter = 50.0
        return locMan
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationUpdate()
        fourSqData()
        vegGuideData()
        //        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    //Setup
    func fourSqData() {
        let url = "\(Network.FourSquare.baseURL)/?ll=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&venuePhotos=1&client_id=\(Auth.init().clientID)&client_secret=\(Auth.init().clientSecret)&v=20181124&query=vegan"
        APIRequestManager.sharedManager.fetchFSData(endPoint: url) { (restaurant) in
            for group in restaurant.response.groups {
                for items in group.items {
                    self.restaurantsFS.append(items.venue)
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func vegGuideData() {
        let url = "\(Network.VegGuide.baseURL)by-lat-long/\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)/filter/category_id=1;veg_level=4;distance=2"
        APIRequestManager.sharedManager.fetchVGData(endPoint: url) { (restaurant) in
            DispatchQueue.main.async {
                self.restaurantsVG = restaurant.entries
                self.tableView.reloadData()
            }
        }
    }
    
    func yelpData() {
        let url = "\(Network.Yelp.restaurantSearch)&latitude=\(currentLocation.coordinate.latitude)&longitude=\(currentLocation.coordinate.longitude)"
        APIRequestManager.sharedManager.fetchYelpRestaurants(endPoint: url) { (details) in
            self.restaurantsYelp = details.businesses
            //self.tableView.reloadData()
        }
    }
    
    func getLocationUpdate() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    //Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.locationServicesEnabled() {
            currentLocation = locationManager.location!
        }
        fourSqData()
        vegGuideData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error encountered")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return restaurantsFS.count
        default:
            return restaurantsVG.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FSListTableViewCell
            let venue = restaurantsFS[indexPath.row]
            //custom tableviewcell
            let fsCell = cell
            fsCell.venue = venue
            //mileage
            let restaurantLoc = CLLocation(latitude: CLLocationDegrees(venue.location.lat), longitude: CLLocationDegrees(venue.location.lng))
            cell.mileageLabel.text = calculateMileage(location: restaurantLoc, destination: currentLocation)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "vegCell", for: indexPath) as! VGListTableViewCell
            let venuesVG = restaurantsVG[indexPath.row]
            //refactor using cell property observer
            //            if let vegCell = cell as? VGListTableViewCell   {
            //                vegCell.entry = venuesVG
            //            }
            let vegCell = cell
            vegCell.entry = venuesVG
            //distance
            let address = venuesVG.address1
            let city = venuesVG.city
            let region = venuesVG.region
            if let zip = venuesVG.postal_code {
                let fullAddress = "\(address), \(city), \(region), \(zip)"
                geocoder.geocodeAddressString(fullAddress) { (placemarks, error) in
                    guard let placemarks = placemarks, let location = placemarks.first?.location else {
                        print("no location found")
                        return
                    }
                    //BUG
                    cell.mileageLabel.text = self.calculateMileage(location: self.currentLocation, destination: location)
                }
            }
            return cell
        }
    }
    
    func calculateMileage(location: CLLocation, destination: CLLocation) -> String {
        let mileage = location.distance(from: destination) / 1609.344
        return "\(String(format: "%.01f", mileage)) mi"
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? UITableViewCell {
            if segue.identifier == "fsDetail" {
                let details = segue.destination as! DetailTableViewController
                let cellPath = self.tableView.indexPath(for: selectedCell)
                let stats = restaurantsFS[(cellPath?.row)!]
                details.venue = stats
            } else if segue.identifier == "vgDetail" {
                let details = segue.destination as! DetailTableViewController
                let cellPath = self.tableView.indexPath(for: selectedCell)
                let stats = restaurantsVG[(cellPath?.row)!]
                details.vgVenue = stats
            }
        }
    }
    
    
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

