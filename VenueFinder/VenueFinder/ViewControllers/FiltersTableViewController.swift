//
//  FiltersTableViewController.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/11/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit

class FiltersTableViewController: UITableViewController {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    var categories = ["Price low to high", "Price high to low", "Distance", "is Open"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton.customView?.layer.borderWidth = 2.0
        searchButton.customView?.layer.cornerRadius = 3.0
    }
    
    @IBAction func searchButtonSelected(_ sender: Any) {
    }
    
    @IBAction func cancelButtonSelected(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
