//
//  ListTableViewExtension.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/27/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit
import CoreLocation

extension ListTableViewController {
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
            if let number = venue.contact.phone {
                getYelpID(GetCountry.getCountryCode(venue.location.country), number: number)
            }
            let fsCell = cell
            fsCell.venue = venue
            //mileage
            let restaurantLoc = CLLocation(latitude: CLLocationDegrees(venue.location.lat), longitude: CLLocationDegrees(venue.location.lng))
            cell.mileageLabel.text = calculateMileage(location: restaurantLoc, destination: currentLocation)
            //user default
            let favorite = favorites[indexPath.row]
            if favorite == true {
                cell.savedFavorite.image = UIImage(named: "small_red")
            } else {
                cell.savedFavorite.image = nil
            }
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "vegCell", for: indexPath) as! VGListTableViewCell
            let venuesVG = restaurantsVG[indexPath.row]
            //regex
            if let phoneNum = venuesVG.phone?.replacingOccurrences(of: "[^\\d+]", with: "", options: .regularExpression, range: ((venuesVG.phone)!).startIndex..<((venuesVG.phone)!).endIndex) {
                getYelpID(GetCountry.getCountryCode(venuesVG.country), number: phoneNum)
            }
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
            //user default
            let favorite = favorites[indexPath.row]
            if favorite == true {
                cell.savedFavorite.image = UIImage(named: "small_red")
            } else {
                cell.savedFavorite.image = nil
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //identify the row selected
        cellNum = indexPath.row
        print("yelpID:", yelpID)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //set the back button to empty text on new vc
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if let selectedCell = sender as? UITableViewCell {
            if segue.identifier == "fsDetail" {
                let details = segue.destination as! DetailTableViewController
                let cellPath = self.tableView.indexPath(for: selectedCell)
                let stats = restaurantsFS[(cellPath?.row)!]
                details.venue = stats
                details.yelpID = yelpID
                details.venueDetails = venueDetails
                details.reviews = reviews
                if favorites[(cellPath?.row)!] == true {
                    details.isFavorited = true
                } else {
                    details.isFavorited = false
                }
            } else if segue.identifier == "vgDetail" {
                let details = segue.destination as! DetailTableViewController
                let cellPath = self.tableView.indexPath(for: selectedCell)
                let stats = restaurantsVG[(cellPath?.row)!]
                details.vgVenue = stats
                details.yelpID = yelpID
                details.venueDetails = venueDetails
                details.reviews = reviews
                if favorites[(cellPath?.row)!] == true {
                    details.isFavorited = true
                } else {
                    details.isFavorited = false
                }
            }
        }
    }
}
