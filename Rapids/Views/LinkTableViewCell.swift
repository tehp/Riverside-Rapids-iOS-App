//
//  LinkTableViewCell.swift
//  Rapids
//
//  Created by Programming 12 on 2016-05-30.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {

    @IBOutlet weak var linkNameLabel: UILabel!
    
    @IBOutlet weak var linkUrlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
