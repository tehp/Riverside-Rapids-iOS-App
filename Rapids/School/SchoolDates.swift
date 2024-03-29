//
//  SchoolDates.swift
//  Rapids
//
//  Created by Noah on 2016-03-05.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class SchoolDates {
    
    static func getEarliestSchoolStartComponents() -> NSDateComponents {
        let date = NSCalendar.currentCalendar().components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: NSDate())
        
        if date.month >= 8 {
            // If it's August or later, then we will say we are before the upcoming school year
            // Therefore the upcoming school year starts this year Aug. 1st
            date.month = 8
            date.day = 1
            return date
        } else {
            // If it's July or earlier, then we will say we are after the previous school year
            // Therefore the previous school year started 1 year ago Aug. 1st
            date.year = date.year - 1
            date.month = 8
            date.day = 1
            return date
        }
    }
    
    static func getEarliestSchoolStart() -> NSDate {
        return NSCalendar.currentCalendar().dateFromComponents(getEarliestSchoolStartComponents())!
    }
    
    static func getLatestSchoolEnd() -> NSDate {
        let cal = NSCalendar.currentCalendar()
        let schoolStart = getEarliestSchoolStartComponents()
        let date = cal.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: NSDate())
        date.year = schoolStart.year + 1
        date.month = 7
        date.day = 31
        return cal.dateFromComponents(date)!
    }
    
}