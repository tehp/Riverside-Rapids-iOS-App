//
//  BSCal.swift
//  Rapids
//
//  Created by Noah on 2016-02-22.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class BSCal {
    
    var schoolStart: NSDate
    var schoolEnd: NSDate
    var days: [BSDay]
    
    init(schoolStart: NSDate, schoolEnd: NSDate, days: [BSDay]) {
        self.schoolStart = schoolStart
        self.schoolEnd = schoolEnd
        self.days = days
    }
    
}