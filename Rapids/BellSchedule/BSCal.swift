//
//  BSCal.swift
//  Rapids
//
//  Created by Noah on 2016-02-22.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class BSCal: NSObject, NSCoding {
    
    struct Schedule {
        static let NORMAL = 0
        static let ADVISORY = 1
        static let EXTENDED_ADVISORY = 2
        static let CUSTOM = 3
    }
    
    struct Block {
        static let X = 1
        static let A = 2
        static let B = 3
        static let C = 4
        static let D = 5
        static let ADVISORY = 6
        static let EXTENDED_ADVISORY = 7
        static let LUNCH = 8
    }
    
    struct PropertyKey {
        static let schoolStartKey = "schoolStart"
        static let schoolEndKey = "schoolEnd"
        static let daysKey = "days"
    }
    
    var schoolStart: NSDate
    var schoolEnd: NSDate
    var days: [BSDay]
    
    init(schoolStart: NSDate, schoolEnd: NSDate, days: [BSDay]) {
        self.schoolStart = schoolStart
        self.schoolEnd = schoolEnd
        self.days = days
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let schoolStart = aDecoder.decodeObjectForKey(PropertyKey.schoolStartKey) as! NSDate
        let schoolEnd = aDecoder.decodeObjectForKey(PropertyKey.schoolEndKey) as! NSDate
        let days = aDecoder.decodeObjectForKey(PropertyKey.daysKey) as! [BSDay]
        
        self.init(schoolStart: schoolStart, schoolEnd: schoolEnd, days: days)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(schoolStart, forKey: PropertyKey.schoolStartKey)
        aCoder.encodeObject(schoolEnd, forKey: PropertyKey.schoolEndKey)
        aCoder.encodeObject(days, forKey: PropertyKey.daysKey)
    }
    
}