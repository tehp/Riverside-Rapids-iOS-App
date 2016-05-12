//
//  SPList.swift
//  Rapids
//
//  Created by Noah on 2016-05-11.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

enum SPListType: Int {
    case Announcements = 1
    case Calendar = 2
    case Documents = 3
}

struct SPListTemplate {
    static let ANNOUNCEMENTS = 104
    static let TASKS = 107
    static let DOCUMENTS = 101
    static let CALENDAR = 106
}

class SPList {
    var type: SPListType
    var name: String
    var url: String
    var guid: String
    var template: Int
    
    init(type: SPListType, name: String, url: String, guid: String, template: Int) {
        self.type = type
        self.name = name
        self.url = url
        self.guid = guid
        self.template = template
    }
}

class SPDocList: SPList {
    var rootDirPath: String
    
    init(name: String, url: String, guid: String, template: Int, rootDirPath: String) {
        self.rootDirPath = rootDirPath
        super.init(type: SPListType.Documents, name: name, url: url, guid: guid, template: template)
    }
}