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
    
    var venueCategory = ""
    var tagArr = [String]()
    var tagString = String()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsView: UIImageView!
    @IBOutlet weak var isOpenView: UIImageView!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursView: UILabel!
//    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionView: UITextView!
//    @IBOutlet weak var websiteView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var reviewOne: UILabel!
    @IBOutlet weak var reviewTwo: UILabel!
    @IBOutlet weak var reviewThree: UILabel!
    @IBOutlet weak var reviewDateOne: UILabel!
    @IBOutlet weak var reviewDateTwo: UILabel!
    @IBOutlet weak var reviewDateThree: UILabel!
    @IBOutlet weak var reviewImageOne: UIImageView!
    @IBOutlet weak var reviewImageTwo: UIImageView!
    @IBOutlet weak var reviewImageThree: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
    //change navigation transparency
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navigationController!.navigationBar.alpha = 0.7 + (self.tableView.contentOffset.y / (self.tableView.contentSize.height - self.tableView.frame.size.height))
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = UIColor.white
            navigationController?.navigationBar.tintColor = UIColor.black
        if tableView.contentOffset.y <= 80 {
            navigationController?.navigationBar.alpha = 1
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.tintColor = UIColor.white
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
        } else {
            setupVGLabels()
        }
        getYelpID()
    }
    
    func getYelpID() {
        var phoneNumber = ""
        var country = ""
        if venue != nil {
             country = getCountryCode((venue?.location.country)!)
            if let phoneNum = venue?.contact.phone {
                phoneNumber = phoneNum
            }
        } else {
            country = getCountryCode((vgVenue?.country)!)
            if let phoneNum = vgVenue?.phone {
                phoneNumber = phoneNum
            }
        }
        let url = NetworkString().yelpSearchBy(phone: phoneNumber, country: country)
        APIRequestManager.sharedManager.fetchYelpDetails(endPoint: url, { (business) in
            DispatchQueue.main.async {
                for data in business.businesses {
                    self.yelpID = data.id
                    self.getBusinessData(self.yelpID)
                }
            }
        })
    }
    
    func getBusinessData(_ venueID: String) {
        let url = NetworkString().searchBy(venueID: venueID)
        APIRequestManager.sharedManager.fetchYelpBusiness(endPoint: url) { (business) in
                self.venueDetails = [business]
                //call here while venue details is accessible
                self.setupYelpLabels()
                self.getReviewData(self.yelpID)
        }
    }
    
    func getReviewData(_ venueID: String) {
        print("4")
        let url = NetworkString().yelpSearchReviewsByVenue(ID: venueID)
        APIRequestManager.sharedManager.fetchYelpReviews(endPoint: url) { (reviews) in
            self.reviews = reviews.reviews
//            print(reviews)
            self.printYelpReviews()
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
            }
        }
        nameLabel.text = venue?.name
        if let rating = venue?.rating {
            ratingsView.ratingfsImage(rating)
        }
        if let open = venue?.hours?.isOpen {
            isOpenView.detailIsOpen(open)
        }
        if let priceRange = venue?.price?.currency {
            priceRangeLabel.text = priceRange
        }
        guard let street = venue?.location.address, let city = venue?.location.city,
            let state = venue?.location.state, let zip = venue?.location.postalCode else { return }
        addressLabel.text = "\(street), \(city), \(state), \(zip)"
        phoneNumLabel.text = venue?.contact.formattedPhone
        phoneNumLabel.sizeToFit()
//        websiteView.text = venue?.url?.lowercased()
    }
    
    func setupYelpLabels() {
        venue?.categories.forEach { (category) in
            venueCategory = category.name.uppercased()
        }
        
        for detail in venueDetails {
            for tag in detail.categories {
                if tag.title == "Vegan" || tag.title == "Vegetarian" {
                    tagArr.append("\(tag.title) cuisine")
                } else {
                    tagArr.append(tag.title)
                }
            }
        }
//        print("tagArr is", tagArr)
        if tagArr.count == 1 {
            tagString = tagArr[0]
        }
        if tagArr.count >= 2 {
            tagArr.insert("and ", at: tagArr.count - 1)
        }
        if tagArr.count >= 3 {
            for tag in 0..<tagArr.count {
                if tag < tagArr.count - 2 {
                    tagString += "\(tagArr[tag]), "
                } else {
                    tagString += "\(tagArr[tag])"
                }
            }
        }
//        print("tagString", tagString)
        if tagString == "" {
            if let name = venue?.name {
            descriptionTextView.text = "\(name) specializes as a \(venueCategory)."
            }
        }
        if let name = venue?.name {
           descriptionTextView.text = "\(name) is a \(venueCategory.lowercased()). They specialize in \(tagString.lowercased())."
        }
    }
    
    func printYelpReviews() {
        //labels
        for (index, review) in reviews.enumerated() {
            print(review)
            if index == 0 {
                reviewOne.text = review.text
                reviewDateOne.text = review.time_created.components(separatedBy: " ")[0]
                reviewImageOne.ratingyelpImage(review.rating)
            } else if index == 1 {
                reviewTwo.text = review.text
                reviewDateTwo.text = review.time_created.components(separatedBy: " ")[0]
                reviewImageTwo.ratingyelpImage(review.rating)
            } else if index == 2 {
                reviewThree.text = review.text
                reviewDateThree.text = review.time_created.components(separatedBy: " ")[0]
                reviewImageThree.ratingyelpImage(review.rating)
            }
        }
    }
    

    func setupVGLabels() {
        if let images = vgVenue?.images {
            for img in images {
                imageView.image(img.files[3].uri)
            }
        }
        nameLabel.text = vgVenue?.name
        addressLabel.text = vgVenue?.address1
        if let address = vgVenue?.address1, let city = vgVenue?.city, let region = vgVenue?.region, let zip = vgVenue?.postal_code {
            addressLabel.text = "\(address), \(city), \(region), \(zip)"
        }
        phoneNumLabel.text = vgVenue?.phone ?? "N/A"
        if let rating = vgVenue?.weighted_rating {
            let num = Double(rating)!
            ratingsView.ratingvgImage(num)
        }
        isOpenView.image = #imageLiteral(resourceName: "time")
        if let priceRange = vgVenue?.price_range {
            priceRangeLabel.text = priceRange.components(separatedBy: " ")[0]
        }
        descriptionTextView.text = vgVenue?.long_description?.wikitext
//        websiteView.text = vgVenue?.website?.lowercased()
    }
}

