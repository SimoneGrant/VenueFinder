//
//  FiltersTableViewController.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/11/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import UIKit

class FiltersTableViewController: UITableViewController {
    
    @IBOutlet weak var lowToHighSwitch: UISwitch!
    @IBOutlet weak var highToLowSwitch: UISwitch!
    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var isOpenSwitch: UISwitch!
    
    var doneButton: UIButton {
        var button = UIButton()
        button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "button_done"), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(searchButtonSelected(_:)), for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    @objc func searchButtonSelected(_ sender: UIButton) {
        print("button selected")
    }
    
    @IBAction func cancelButtonSelected(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func lowToHighAction(_ sender: UISwitch) {
        if sender.isOn {
            print("low to high is on")
        }
    }
    
    @IBAction func highToLowAction(_ sender: UISwitch) {
    }
    
    @IBAction func closestRestaurantsFilter(_ sender: UISwitch) {
    }
    
    @IBAction func isOpen(_ sender: UISwitch) {
    }
}
