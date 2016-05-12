//
//  GetListCollectionResponse.swift
//  Rapids
//
//  Created by Programming on 2016-03-11.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class GetListCollectionResponseData: SoapResponseData {
    
    struct PropertyKey {
        static let listsKey = "lists"
    }
    
    var lists: [[String: String]]
    
    init(timestamp: NSDate, lists: [[String: String]]) {
        self.lists = lists
        
        super.init(timestamp: timestamp)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.lists = aDecoder.decodeObjectForKey(PropertyKey.listsKey) as! [[String: String]]
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(lists, forKey: PropertyKey.listsKey)
    }
    
}

class GetListCollectionResponse: SoapResponse {
    
    var lists: [[String: String]]!
    
    override init(responseData: NSData?, timestamp: NSDate) throws {
        try super.init(responseData: responseData, timestamp: timestamp)
        
        lists = [[String: String]]()
        
        let listsObj = try getNthFirstChild(contentRoot, n: 2)
        
        for row in listsObj.children {
            var attributes = [String: String]()
            for (name, value) in row.attributes {
                attributes[name] = value
            }
            lists.append(attributes)
        }
    }
    
    override func generateSoapResponseData() -> SoapResponseData {
        return GetListCollectionResponseData(timestamp: timestamp, lists: lists)
    }
    
}