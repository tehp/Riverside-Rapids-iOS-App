//
//  TeacherSPSitesResponse.swift
//  Rapids
//
//  Created by Noah on 2016-05-02.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class TeacherSPSitesResponse: NSObject, NSCoding {
    
    struct PropertyKey {
        static let timestampKey = "timestamp"
        static let sitesKey = "site"
    }
    
    var timestamp: NSDate
    var sites: [TeacherSPSite]
    
    init(timestamp: NSDate, sites: [TeacherSPSite]) {
        self.timestamp = timestamp
        self.sites = sites
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.timestamp = aDecoder.decodeObjectForKey(PropertyKey.timestampKey) as! NSDate
        self.sites = aDecoder.decodeObjectForKey(PropertyKey.sitesKey) as! [TeacherSPSite]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(timestamp, forKey: PropertyKey.timestampKey)
        aCoder.encodeObject(sites, forKey: PropertyKey.sitesKey)
    }
}