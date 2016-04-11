//
//  BlockTableViewCell.swift
//  Rapids
//
//  Created by Programming on 2016-02-29.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class BlockTableViewCell: UITableViewCell {

    @IBOutlet weak var blockLabel: UILabel!
    
    
    @IBOutlet weak var startLabel: UILabel!
    
    
    @IBOutlet weak var endLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
