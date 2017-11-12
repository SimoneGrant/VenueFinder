//
//  DetailTableViewController.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController {
    
    var venue: Venue?
    var vgVenue: Entries?
    var yelpID = String()
    var venueDetails = [VenueDetails]()
    var reviews = [Review]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var ratingsView: UIImageView!
//    @IBOutlet weak var ratingsLabel: UILabel!
//    @IBOutlet weak var isOpenView: UIImageView!
//    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var hoursView: UITextView!
//    @IBOutlet weak var distanceLabel: UILabel!
//    @IBOutlet weak var phoneNumLabel: UILabel!
//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var descriptionView: UITextView!
//    @IBOutlet weak var websiteView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        //get rid of back button test on navigation
        if let viewControllers = self.navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil; // get previous view
            previousVC?.title = "" // or previousVC?.title = "Back"
        }
    }
    
    func setupUI() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if venue != nil {
            setupFSLabels()
            getYelpID()
        } else {
            setupVGLabels()
        }
    }
    
    func getYelpID() {
        let country = getCountryCode((venue?.location.country)!)
        if let phoneNum = venue?.contact.phone {
            let url = NetworkString().yelpSearchBy(phone: phoneNum, country: country)
            APIRequestManager.sharedManager.fetchYelpDetails(endPoint: url, { (business) in
                DispatchQueue.main.async {
                    for data in business.businesses {
                        self.yelpID = data.id
                        self.getBusinessData(self.yelpID)
                    }
                }
            })
        }
    }
    
    func getBusinessData(_ venueID: String) {
        let url = NetworkString().searchBy(venueID: venueID)
        APIRequestManager.sharedManager.fetchYelpBusiness(endPoint: url) { (business) in
            self.venueDetails.append(business)
            self.getReviewData(self.yelpID)
        }
    }
    
    func getReviewData(_ venueID: String) {
        let url = NetworkString().yelpSearchReviewsByVenue(ID: venueID)
        APIRequestManager.sharedManager.fetchYelpReviews(endPoint: url) { (reviews) in
            self.reviews = reviews.reviews
            print(reviews)
        }
    }
    
    func getCountryCode(_ country: String) -> String {
        var code = ""
        let filteredResults = Countries.allCountries.filter( { $0.country == country } )
        for x in filteredResults {
            code = x.callCode
        }
        return code
    }
    
    
    func setupFSLabels() {
        for item in (venue?.photos?.groups)! {
            for photo in item.items {
                imageView.image("\(photo.prefix)300x300\(photo.suffix)")
//                print("\(photo.prefix)300x300\(photo.suffix)")
            }
        }
        nameLabel.text = venue?.name
        venue?.categories.forEach { (category) in
            categoryLabel.text = category.name.uppercased()
        }
//        if let rating = venue?.rating {
//            ratingsLabel.text = "\(rating)"
//            ratingsView.ratingfsImage(rating)
//        }
//        if let open = venue?.hours?.isOpen {
//            isOpenView.isOpen(open)
//        }
//        if let priceRange = venue?.price?.currency {
//            priceRangeLabel.text = priceRange
//        }
//        guard let street = venue?.location.address, let city = venue?.location.city,
//            let state = venue?.location.state, let zip = venue?.location.postalCode else { return }
//        addressLabel.text = "\(street), \(city), \(state), \(zip)"
//        phoneNumLabel.text = venue?.contact.formattedPhone
//        websiteView.text = venue?.url?.lowercased()
    }
    
    func setupVGLabels() {
        if let images = vgVenue?.images {
            for img in images {
                imageView.image(img.files[3].uri)
            }
        }
        nameLabel.text = vgVenue?.name
        for category in (vgVenue?.categories)! {
            categoryLabel.text = category.uppercased()
        }
//        addressLabel.text = vgVenue?.address1
//        if let address = vgVenue?.address1, let city = vgVenue?.city, let region = vgVenue?.region, let zip = vgVenue?.postal_code {
//            addressLabel.text = "\(address), \(city), \(region), \(zip)"
//        }
//        phoneNumLabel.text = vgVenue?.phone ?? "N/A"
//        if let rating = vgVenue?.weighted_rating {
//            let num = Double(rating)!
//            ratingsLabel.text = "\(num * 2)"
//            ratingsView.ratingvgImage(num)
//        }
//        isOpenView.image = nil
//        if let priceRange = vgVenue?.price_range {
//            priceRangeLabel.text = priceRange
//        }
//        descriptionView.text = vgVenue?.long_description?.wikitext
//        if let hours = vgVenue?.hours {
//            var hoursDict = [String:[String]]()
//            for sched in hours {
//                let venueDay = sched.days
//                let venueHrs = sched.hours
//                for hr in venueHrs {
//                    hoursDict[venueDay] = [hr]
//                }
//
//                var hour = ""
//                for (day,hours) in hoursDict {
//                    for hr in hours {
//                        hour += day + "\n" + hr.uppercased() + "\n"
//                        hoursView.text = "HOURS - \n\(hour)"
//                    }
//                }
//            }
//        }
//        websiteView.text = vgVenue?.website?.lowercased()
    }
}

