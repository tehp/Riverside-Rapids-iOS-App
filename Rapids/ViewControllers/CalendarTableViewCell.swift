//
//  CalendarTableViewCell.swift
//  Rapids
//
//  Created by Mac Craig on 2016-04-06.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var eventLabel: UILabel!
    
    func viewDidLoad() {
        eventLabel.text = "test"
    }
}