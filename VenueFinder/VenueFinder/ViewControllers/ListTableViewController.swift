//
//  ListTableViewController.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit
import CoreLocation

protocol Favorites {
    func isItFavorited(value: Bool)
}

class ListTableViewController: UITableViewController, CLLocationManagerDelegate, Favorites {
    
    var restaurantsFS = [Venue]()
    var restaurantsVG = [Entries]()
    var currentLocation = CLLocation(latitude: 40.7, longitude: -74)
    let geocoder = CLGeocoder()
    let locationManager: CLLocationManager = {
        let locMan: CLLocationManager = CLLocationManager()
        locMan.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locMan.distanceFilter = 50.0
        return locMan
    }()
    //user defaults
    var gotFavorited: Bool!
    var cellNum: Int!
    let userDefault = UserDefaults.standard
    var defaultKey = "favorited"
    var indexKey = "cell"
    var favorites = [Int:Bool]()
    //yelp stuff
    var venueDetails: VenueDetails?
    var reviews = [Review]()
    var yelpID = String()
    var venueCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationUpdate()
        fourSqData()
        vegGuideData()
        setupUI()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "H A N G R Y"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.alpha = 1
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        //user defaults
        //check for changes
        print("I am the detail key: \(userDefault.bool(forKey: "detail"))")
        gotFavorited = userDefault.bool(forKey: "detail")
        saveDefaults()
        //update the tableview
        self.tableView.reloadData()
        print(favorites)
        
    }
    
    // MARK: - User Defaults
    
    func saveDefaults() {
        userDefault.set(cellNum, forKey: indexKey)
        userDefault.set(gotFavorited, forKey: defaultKey)
        favorites[userDefault.integer(forKey: indexKey)] = userDefault.bool(forKey: defaultKey)
    }
    
    func isItFavorited(value: Bool) {
        self.gotFavorited = value
    }
    
    // MARK: - Setup UI & Networking
    
    func setupUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130.0
    }
    
    //remove duplicate entries in the vegguide and foursquare results
    func filterData() {
        if !restaurantsFS.isEmpty && !restaurantsVG.isEmpty {
            for (_, info) in restaurantsFS.enumerated() {
                for (num, veg) in restaurantsVG.enumerated() {
                    if info.location.address.components(separatedBy: " ")[0] == veg.address1.components(separatedBy: " ")[0] {
                        if info.location.address.components(separatedBy: " ")[1] == veg.address1.components(separatedBy: " ")[1] {
                            //                        print("Foursqare: \(info.name), \(index)", "VegGuide: \(veg.name), \(num)")
                            restaurantsVG.remove(at: num)
                            tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc func openMapView() {
        
    }
    
    // MARK: - Call API's
    
    func fourSqData() {
        let url = NetworkString().fourSquareURLString(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
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
        let url = NetworkString().vegGuideURLString(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        APIRequestManager.sharedManager.fetchVGData(endPoint: url) { (restaurant) in
            DispatchQueue.main.async {
                self.restaurantsVG = restaurant.entries
                self.tableView.reloadData()
                self.filterData()
            }
        }
    }
    
    // Yelp
    func getYelpID(_ place: String, number: String) {
        let url = NetworkString().yelpSearchBy(phone: number, country: place)
        APIRequestManager.sharedManager.fetchYelpDetails(endPoint: url, { (business) in
            DispatchQueue.main.async {
                for data in business.businesses {
                    self.yelpID = data.id
                    self.getBusinessData(self.yelpID)
                }
            }
        })
    }
    
    //TODO: - Change search by phone number to search by ID name
    
    func getBusinessData(_ venueID: String) {
        let url = NetworkString().searchBy(venueID: venueID)
        APIRequestManager.sharedManager.fetchYelpBusiness(endPoint: url) { (business) in
            self.venueDetails = business
            self.getReviewData(self.yelpID)
        }
    }
    
    func getReviewData(_ venueID: String) {
        let url = NetworkString().yelpSearchReviewsByVenue(ID: venueID)
        APIRequestManager.sharedManager.fetchYelpReviews(endPoint: url) { (reviews) in
            self.reviews = reviews.reviews
        }
    }
    
    // MARK: - Location Manager
    
    func getLocationUpdate() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.locationServicesEnabled() {
            currentLocation = locationManager.location!
        }
        //call fresh data after location update
        fourSqData()
        vegGuideData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error encountered")
    }
    
    //calculate mileage for the UILabels
    func calculateMileage(location: CLLocation, destination: CLLocation) -> String {
        let mileage = location.distance(from: destination) / 1609.344
        return "\(String(format: "%.01f", mileage)) mi"
    }
}



