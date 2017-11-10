//
//  ViewController.swift
//  HangryDraft
//
//  Created by Simone Grant on 10/29/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    var currentViewController: UIViewController?
    var place: String!
    var currentLocation = CLLocation(latitude: 40.7, longitude: -74)
    let locationManager: CLLocationManager = {
        let locMan: CLLocationManager = CLLocationManager()
        locMan.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locMan.distanceFilter = 50.0
        return locMan
    }()
    
    lazy var firstVC: UIViewController = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RestaurantTVC")
        return vc!
    }()
    
    lazy var secondVC: UIViewController = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapVC")
        return vc!
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.selectedSegmentIndex = Index.firstTab.rawValue
        displayCurrentTab(Index.firstTab.rawValue)
        getData()
        navigationController?.navigationBar.barTintColor = UIColor.white
//        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if segmentControl.selectedSegmentIndex == Index.firstTab.rawValue {
//            navigationController?.navigationBar.isTranslucent = false
//        } else if segmentControl.selectedSegmentIndex == Index.secondTab.rawValue {
//            navigationController?.navigationBar.isTranslucent = true
//        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    func getData() {
        let url = "\(Network.FourSquare.baseURL)/?ll=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&venuePhotos=1&client_id=\(Auth.init().clientID)&client_secret=\(Auth.init().clientSecret)&v=20181124&query=vegan"
        APIRequestManager.sharedManager.fetchFSData(endPoint: url) { (restaurant) in
            self.place = restaurant.response.headerFullLocation
            DispatchQueue.main.async {
            }
        }
    }
    
    func getLocationUpdate() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.locationServicesEnabled() {
            currentLocation = locationManager.location!
        }
        getData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error encountered")
    }
    
    
    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        //        if self.currentViewController == secondVC {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        //        }
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.containerView.bounds
            self.containerView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case Index.firstTab.rawValue:
            vc = firstVC
        case Index.secondTab.rawValue:
            vc = secondVC
        default:
            return nil
        }
        return vc
    }
    
    


}

