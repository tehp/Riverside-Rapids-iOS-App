//
//  BSDay.swift
//  Rapids
//
//  Created by Noah on 2016-02-22.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class BSDay: NSObject, NSCoding {
    
    struct PropertyKey {
        static let dateKey = "date"
        static let dayTypeKey = "dayType"
        static let scheduleKey = "schedule"
        static let customScheduleKey = "customSchedule"
    }
    
    var date: NSDate
    var dayType: String
    var schedule: Int
    var customSchedule: [BSBlock]?
    
    init(date: NSDate, dayType: String, schedule: Int, customSchedule: [BSBlock]?) {
        self.date = date
        self.dayType = dayType
        self.schedule = schedule
        self.customSchedule = customSchedule
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        let dayType = aDecoder.decodeObjectForKey(PropertyKey.dayTypeKey) as! String
        let schedule = aDecoder.decodeIntegerForKey(PropertyKey.scheduleKey)
        let customSchedule = aDecoder.decodeObjectForKey(PropertyKey.customScheduleKey) as? [BSBlock]
        
        self.init(date: date, dayType: dayType, schedule: schedule, customSchedule: customSchedule)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(dayType, forKey: PropertyKey.dayTypeKey)
        aCoder.encodeInteger(schedule, forKey: PropertyKey.scheduleKey)
        aCoder.encodeObject(customSchedule, forKey: PropertyKey.customScheduleKey)
    }
    
}