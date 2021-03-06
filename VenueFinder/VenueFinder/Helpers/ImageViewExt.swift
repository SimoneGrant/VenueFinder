//
//  ImageViewExt.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    //download image
    public func image(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: response)
                }
            }
            }.resume()
    }
    
    //get rating
    public func ratingfsImage(_ rating: Double) {
        switch rating {
        case 0..<2.5:
            self.image = Rating.oneStar.rating
        case 2.5..<4.5:
            self.image = Rating.twoStars.rating
        case 4.5..<8:
            self.image = Rating.threeStars.rating
        case 8..<9.5:
            self.image = Rating.fourStars.rating
        case 9.5...10:
            self.image = Rating.fiveStars.rating
        default:
            self.image = nil
        }
    }
    
    public func ratingvgImage(_ rating: Double) {
        switch rating {
        case 0...1.5:
            self.image = Rating.oneStar.rating
        case 1.5...2.5:
            self.image = Rating.twoStars.rating
        case 2.5...3.5:
            self.image = Rating.threeStars.rating
        case 3.5...4.5:
            self.image = Rating.fourStars.rating
        case 4.5...5:
            self.image = Rating.fiveStars.rating
        default:
            self.image = nil
        }
    }
    
    public func ratingyelpImage(_ rating: Int) {
        switch rating {
        case 0:
            self.image = Rating.oneStar.rating
        case 1:
            self.image = Rating.oneStar.rating
        case 2:
            self.image = Rating.twoStars.rating
        case 3:
            self.image = Rating.threeStars.rating
        case 4:
            self.image = Rating.fourStars.rating
        case 5:
            self.image = Rating.fiveStars.rating
        default:
            self.image = nil
        }
    }
    
    //check if open
    public func isOpen(_ open: Bool) {
        if !open {
            self.image = #imageLiteral(resourceName: "closed")
        } else {
            self.image = nil
        }
    }
    //detail if open
    public func detailIsOpen(_ open: Bool) {
        if !open {
            self.image = #imageLiteral(resourceName: "closed")
        } else {
            self.image = #imageLiteral(resourceName: "time")
        }
    }
}




//index view controllers
enum Index: Int {
    case firstTab = 0
    case secondTab = 1
}

//return rating image
enum Rating {
    case noStar, oneStar, twoStars, threeStars, fourStars, fiveStars
}

extension Rating {
    var rating: UIImage {
        switch self {
        case .noStar:
            return #imageLiteral(resourceName: "noStar")
        case .oneStar:
            return #imageLiteral(resourceName: "oneStar")
        case .twoStars:
            return #imageLiteral(resourceName: "twoStars")
        case .threeStars:
            return #imageLiteral(resourceName: "threeStars")
        case .fourStars:
            return #imageLiteral(resourceName: "fourStars")
        case .fiveStars:
            return #imageLiteral(resourceName: "fiveStars")
        }
    }
}

