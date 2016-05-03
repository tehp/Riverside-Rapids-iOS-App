//
//  TeacherSPSite.swift
//  Rapids
//
//  Created by Noah on 2016-05-02.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class TeacherSPSite: NSObject, NSCoding {
    
    struct PropertyKey {
        static let idKey = "id"
        static let teacherSalutationKey = "teacherSalutation"
        static let teacherLastNameKey = "teacherLastName"
        static let courseKey = "course"
        static let websiteUrlKey = "websiteUrl"
    }
    
    var id: Int64
    var teacherSalutation: String
    var teacherLastName: String
    var course: String
    var websiteUrl: String
    
    init(id: Int64, teacherSalutation: String, teacherLastName: String, course: String, websiteUrl: String) {
        self.id = id
        self.teacherSalutation = teacherSalutation
        self.teacherLastName = teacherLastName
        self.course = course
        self.websiteUrl = websiteUrl
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInt64ForKey(PropertyKey.idKey)
        self.teacherSalutation = aDecoder.decodeObjectForKey(PropertyKey.teacherSalutationKey) as! String
        self.teacherLastName = aDecoder.decodeObjectForKey(PropertyKey.teacherLastNameKey) as! String
        self.course = aDecoder.decodeObjectForKey(PropertyKey.courseKey) as! String
        self.websiteUrl = aDecoder.decodeObjectForKey(PropertyKey.websiteUrlKey) as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt64(id, forKey: PropertyKey.idKey)
        aCoder.encodeObject(teacherSalutation, forKey: PropertyKey.teacherSalutationKey)
        aCoder.encodeObject(teacherLastName, forKey: PropertyKey.teacherLastNameKey)
        aCoder.encodeObject(course, forKey: PropertyKey.courseKey)
        aCoder.encodeObject(websiteUrl, forKey: PropertyKey.websiteUrlKey)
    }
}