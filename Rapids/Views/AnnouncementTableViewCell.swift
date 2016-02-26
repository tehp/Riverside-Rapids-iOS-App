//
//  AnnouncementTableViewCell.swift
//  Rapids
//
//  Created by Noah on 2016-02-23.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
