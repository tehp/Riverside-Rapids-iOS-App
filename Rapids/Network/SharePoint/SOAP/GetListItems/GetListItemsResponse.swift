//
//  GetListItemsResponse.swift
//  Rapids
//
//  Created by Noah on 2016-02-21.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class GetListItemsResponseData: SoapResponseData {
    
    struct PropertyKey {
        static let rowsKey = "rows"
    }
    
    var rows: [[String: String]]
    
    init(timestamp: NSDate, rows: [[String: String]]) {
        self.rows = rows
        
        super.init(timestamp: timestamp)
    }

    required init?(coder aDecoder: NSCoder) {
        self.rows = aDecoder.decodeObjectForKey(PropertyKey.rowsKey) as! [[String: String]]
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(rows, forKey: PropertyKey.rowsKey)
    }
    
}

class GetListItemsResponse: SoapResponse {
    
    var rows: [[String: String]]!
    
    override init(responseData: NSData?, timestamp: NSDate) throws {
        try super.init(responseData: responseData, timestamp: timestamp)
        
        rows = [[String: String]]()
        
        let data = try getNthFirstChild(contentRoot, n: 3)
        
        for row in data.children {
            var attributes = [String: String]()
            for (name, value) in row.attributes {
                attributes[name] = value
            }
            rows.append(attributes)
        }
    }
    
    override func generateSoapResponseData() -> GetListItemsResponseData {
        return GetListItemsResponseData(timestamp: timestamp, rows: rows)
    }
    
}