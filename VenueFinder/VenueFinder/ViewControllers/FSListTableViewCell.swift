//
//  FSListTableViewCell.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit
import CoreLocation

class FSListTableViewCell: UITableViewCell {

    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var isOpenView: UIImageView!
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    @IBOutlet weak var ratingsView: UIImageView!
    
    var venue: Venue? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib() //super calls the parent function when you override
        restaurantNameLabel.preferredMaxLayoutWidth = restaurantNameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        restaurantNameLabel.preferredMaxLayoutWidth = restaurantNameLabel.frame.size.width
    }
    
    func updateUI() {
        restaurantNameLabel.text = venue?.name.uppercased()
        addressLabel.text = venue?.location.address
        //category
        venue?.categories.forEach { (category) in
            restaurantTypeLabel.text = category.name.uppercased()
        }
        //images
        venueImage.layer.cornerRadius = 12
        venueImage.layer.masksToBounds = true
        venueImage.clipsToBounds = true
        setNeedsLayout()
        for group in (venue?.photos?.groups)! {
            for item in group.items {
                venueImage.image("\(item.prefix)100x100\(item.suffix)")
            }
        }
        //ratings
        ratingsView.ratingfsImage((venue?.rating)!)
        //hours
        if let open = venue?.hours?.isOpen {
            isOpenView.isOpen(open)
        }
        
        //isOpen
        //        if let hours = venuesVG.hours {
        //            for sched in hours {
        //                let venueDay = sched.days
        //                let venueHrs = sched.hours
        
        //                if let day = Date().dayOfWeek() {
        //                    print(day)
        //                    if venueDay.contains(day) {
        //                        print(venueDay)
        //                    }
        //                }
        //            }
        //        }
        
    }
    
}
