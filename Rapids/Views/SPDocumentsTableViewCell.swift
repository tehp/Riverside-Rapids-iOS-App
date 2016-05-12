//
//  SPDocumentsTableViewCell.swift
//  Rapids
//
//  Created by Noah on 2016-05-13.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class SPDocumentsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
