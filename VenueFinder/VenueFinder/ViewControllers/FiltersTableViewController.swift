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
        
        let doneButton = UIButton(type: .custom)
        doneButton.setImage(#imageLiteral(resourceName: "button_done"), for: .normal)
        doneButton.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    @IBAction func searchButtonSelected(_ sender: Any) {
    }
    
    @IBAction func cancelButtonSelected(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func openMapView() {
        ////
    }
    

}
