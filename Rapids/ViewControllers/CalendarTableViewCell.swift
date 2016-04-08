//
//  CalendarTableViewCell.swift
//  Rapids
//
//  Created by Mac Craig on 2016-04-06.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var eventLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}