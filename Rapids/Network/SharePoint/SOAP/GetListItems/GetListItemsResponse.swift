//
//  GetListItemsResponse.swift
//  Rapids
//
//  Created by Noah on 2016-02-21.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class GetListItemsResponse: SoapResponse {
    
    var rows: [[String: String]]!
    
    override init(responseData: NSData?) throws {
        try super.init(responseData: responseData)
        
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
    
}