//
//  ViewControllerHelper.swift
//  Rapids
//
//  Created by Noah on 2016-05-02.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerHelper {
    
    static func showRapidsLogo(navigationItem: UINavigationItem) {
        let logo = UIImage(named: "rapids_white")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = logo
        navigationItem.titleView = imageView
    }
    
}