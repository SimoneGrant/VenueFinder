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
    var venueDetails: VenueDetails?
    var reviews = [Review]()
    var yelpID = String()
    var venueCategory = ""
    let app = UIApplication.shared
    var currentLocation = CLLocation(latitude: 40.7, longitude: -74)
    let geocoder = CLGeocoder()
    //userDefault
    var pageDelegate: Favorites?
    var isFavorited: Bool!
    let userDefault = UserDefaults.standard
    var detailKey = "detail"
    
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
        setupNavigationAndLabels()
        userDefault.set(isFavorited, forKey: detailKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        app.statusBarStyle = .lightContent
        //use this to read boolean value from protocol delegate
        pageDelegate?.isItFavorited(value: isFavorited)
        
        //trying to get previously true cells to remain true
        if userDefault.bool(forKey: detailKey) == true {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        }
    }
    
    // MARK: - Setup, Navigation, and Scrolling
    
    func setupNavigationAndLabels() {
        //fix status bar inset
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        let nav = navigationController?.navigationBar
        nav?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav?.shadowImage = UIImage()
        nav?.isTranslucent = true
        nav?.tintColor = UIColor.white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "blackHeart"), style: .plain, target: self, action: #selector(selectFavorite))
        
        if venue != nil {
            setupFSLabels()
            setupYelpLabelsForFS()
        } else {
            setupVGLabels()
            setupYelpLabelsForVG()
        }
        
        printYelpReviews()
        setupMap()
        addViewOnMap()
    }
    
    //change navigation transparency
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let nav = navigationController?.navigationBar
        nav?.alpha = 0.6 + (self.tableView.contentOffset.y / (self.tableView.contentSize.height - self.tableView.frame.size.height))
        nav?.isTranslucent = false
        nav?.barTintColor = UIColor.white
        nav?.tintColor = UIColor.black
        app.statusBarStyle = .default
        if tableView.contentOffset.y <= 40 {
            nav?.alpha = 1
            nav?.isTranslucent = true
            nav?.tintColor = UIColor.white
            app.statusBarStyle = .lightContent
        }
    }
    
    // MARK: - User Defaults
    
    // FIXME: - FIX TOOLBAR BUTTON COLOR ON DESELECTION
    
    @objc func selectFavorite() {
        if isFavorited == false {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.red
            isFavorited = true
            pageDelegate?.isItFavorited(value: isFavorited)
        } else {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            isFavorited = false
            pageDelegate?.isItFavorited(value: isFavorited)
        }
        userDefault.set(isFavorited, forKey: detailKey)
    }
    
    // MARK: Setup Views and Functionality
    
    //Visit website
    @IBAction func visitWebsiteSelected(_ sender: UIButton) {
        if venue != nil {
            if let url = venue?.url {
                goToURL(url)
            }
        } else {
            if let website = vgVenue?.website {
                goToURL(website)
            }
        }
    }
    
    func goToURL(_ url: String) {
        if let destinationURL = URL(string: url) {
            app.open(destinationURL, options: [:], completionHandler: nil)
        }
    }
    
    //Make a call
    @IBAction func selectedPhoneNum(_ sender: UIButton) {
        if venue != nil {
            if let number = venue?.contact.phone {
                dialPhoneNum(number)
            }
        } else {
            if let number = vgVenue?.phone?.replacingOccurrences(of: "[^\\d+]", with: "", options: .regularExpression, range: ((vgVenue?.phone)!).startIndex..<((vgVenue?.phone)!).endIndex) {
                dialPhoneNum(number)
            }
        }
    }
    
    func dialPhoneNum(_ number: String) {
        if let call = venue?.contact.phone, let url = URL(string: "tel://\(call)"),
            app.canOpenURL(url) {
            app.open(url)
        }
    }
    
    //Load labels
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
    }
    
    func setupYelpLabelsForFS() {
        //restaurant descriptions
        var tagArr = [String]()
        var tagString = String()
        venue?.categories.forEach { (category) in
            venueCategory = category.name.uppercased()
        }
        for tag in (venueDetails?.categories)! {
            if tag.title == "Vegan" || tag.title == "Vegetarian" {
                tagArr.append("\(tag.title) cuisine")
            } else {
                tagArr.append(tag.title)
            }
        }
        //appending descriptions to tag
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
        if tagString == "" {
            if let name = venue?.name {
                descriptionTextView.text = "\(name) specializes as a \(venueCategory)."
            }
        }
        if let name = venue?.name {
            descriptionTextView.text = "\(name) is a \(venueCategory.lowercased()). They specialize in \(tagString.lowercased())."
        }
        
        //get time
        let time = Time()
        var openMilitary: String!
        var closeMilitary: String!
        for hours in (venueDetails?.hours)! {
            for openHours in hours.open {
                openMilitary = openHours.start
                closeMilitary = openHours.end
                if let day = time.getDayOfWeek() {
                    if openHours.day == day - 1 {
                        let open = time.convertToReadableTime(openHours.start)
                        let close = time.convertToReadableTime(openHours.end)
                        hoursView.text = "\(time.getTime(open)) - \(time.getTime(close))"
                    }
                }
            }
        }
        //isRestaurantOpen
        let today = Date()
        let openHour = Int(String(openMilitary.characters.prefix(2)))
        let openMin = Int(String(openMilitary.characters.suffix(2)))
        let closeHour = Int(String(closeMilitary.characters.prefix(2)))
        let closeMin = Int(String(closeMilitary.characters.suffix(2)))
        let openTime = today.compareTimes(hours: openHour!, minutes: openMin!)
        let closeTime = today.compareTimes(hours: closeHour!, minutes: closeMin!)
        if today <= openTime && today >= closeTime {
            isOpenView.detailIsOpen(false)
        } else {
            isOpenView.detailIsOpen(true)
        }
    }
    
    func printYelpReviews() {
        //labels
        for (index, review) in reviews.enumerated() {
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
    
    func setupYelpLabelsForVG() {
        let time = Time()
        for hours in (venueDetails?.hours)! {
            for openHours in hours.open {
                if let day = time.getDayOfWeek() {
                    if openHours.day == day - 1 {
                        let open = time.convertToReadableTime(openHours.start)
                        let close = time.convertToReadableTime(openHours.end)
                        hoursView.text = "\(time.getTime(open)) - \(time.getTime(close))"
                    }
                }
            }
        }
        printYelpReviews()
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
        
        //if yelp hours aren't available
        var range = [0,1,2,3,4,5,6]
        let day = Time().getDayOfWeek()
        if let hours = vgVenue?.hours {
            for hour in hours  {
                let restaurantDay = hour.days
                //apply correct combination to range
                switch restaurantDay {
                case "Mon - Fri":
                    range = Array(1...5)
                    break
                case "Mon - Wed":
                    range = Array(1...3)
                    break
                case "Mon - Thu":
                    range = Array(1...4)
                    break
                case "Tue - Thu":
                    range = Array(2...4)
                    break
                case "Fri - Sat":
                    range = Array(5...6)
                    break
                case "Sat - Sun":
                    range = [6,0]
                    break
                case "Fri - Sun":
                    range = [5,6,0]
                    break
                case "Thur - Fri":
                    range = Array(4...5)
                default:
                    //                print(restaurantDay)
                    break
                }
                if range.contains(day!) {
                    for hr in hour.hours {
                        hoursView.text = hr
                    }
                }
            }
        }
    }
}


