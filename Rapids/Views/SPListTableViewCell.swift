//
//  SPListTableViewCell.swift
//  Rapids
//
//  Created by Noah on 2016-05-11.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class SPListTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
