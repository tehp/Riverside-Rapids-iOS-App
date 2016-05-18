//
//  SPAnnouncementTableViewCell.swift
//  Rapids
//
//  Created by Noah on 2016-05-24.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class SPAnnouncementTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var modifiedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
