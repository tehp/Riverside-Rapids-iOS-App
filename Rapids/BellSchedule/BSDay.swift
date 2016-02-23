//
//  BSDay.swift
//  Rapids
//
//  Created by Noah on 2016-02-22.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class BSDay {
    
    var date: NSDate
    var dayType: String
    var schedule: Int
    var customSchedule: [BSBlock]
    
    init(date: NSDate, dayType: String, schedule: Int, customSchedule: [BSBlock]) {
        self.date = date
        self.dayType = dayType
        self.schedule = schedule
        self.customSchedule = customSchedule
    }
    
}