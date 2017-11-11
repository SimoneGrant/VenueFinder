//
//  TableViewCell.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit
import CoreLocation

class VGListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var isOpenView: UIImageView!
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    @IBOutlet weak var ratingsView: UIImageView!
    
    
    var entry: Entries? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        restaurantNameLabel.preferredMaxLayoutWidth = restaurantNameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        restaurantNameLabel.preferredMaxLayoutWidth = restaurantNameLabel.frame.size.width
    }
    
    func updateUI() {
        restaurantNameLabel.text = entry?.name.uppercased()
        addressLabel.text = entry?.address1
        priceRangeLabel.text = entry?.price_range
        //category
        if let categories = entry?.categories {
            for category in categories {
                restaurantTypeLabel.text = category.uppercased()
            }
        }
        //ratings
        if let rating = entry?.weighted_rating {
            if let newRating = Double(rating) {
                ratingsView.ratingvgImage(newRating)
            }
        }
        //image
        //BUG - images are not correct
        venueImage.layer.cornerRadius = 12
        venueImage.layer.masksToBounds = true
        venueImage.clipsToBounds = true
        setNeedsLayout()
        venueImage.image = #imageLiteral(resourceName: "pexels-photo-70497")
        if let images = entry?.images {
            for img in images.flatMap({ $0 }) {
                print(img)
                venueImage.image(img.files[1].uri)
            }
        }
        //isOpen
        isOpenView.image = nil
    }
    
}


