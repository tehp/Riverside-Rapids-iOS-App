//
//  SoapResponse.swift
//  Rapids
//
//  Created by Noah on 2016-02-20.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation
import AEXML

enum SoapResponseError: ErrorType {
    case StatusCodeError
    case NoDataError
    case XMLError
    case ParseError
}

class SoapResponseData: NSObject, NSCoding {
    
    struct PropertyKey {
        static let timestampKey = "timestamp"
    }
    
    var timestamp: NSDate
    
    init(timestamp: NSDate) {
        self.timestamp = timestamp
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.timestamp = aDecoder.decodeObjectForKey(PropertyKey.timestampKey) as! NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(timestamp, forKey: PropertyKey.timestampKey)
    }
    
}

class SoapResponse: NSObject, NSCoding {
    
    struct PropertyKey {
        static let responseDataKey = "responseData"
        static let timestampKey = "timestamp"
    }
    
    private var responseData: NSData?
    private var document: AEXMLDocument!
    var contentRoot: AEXMLElement!
    var timestamp: NSDate
    
    init(responseData: NSData?, timestamp: NSDate) throws {
        self.responseData = responseData
        self.timestamp = timestamp
        super.init()
        
        if let actualResponseData = responseData {
            do {
                try document = AEXMLDocument(xmlData: actualResponseData)
            } catch {
                throw SoapResponseError.XMLError
            }
            
            try contentRoot = getNthFirstChild(document.root, n: 2)
        } else {
            throw SoapResponseError.NoDataError
        }
    }
    
    func getNthFirstChild(root: AEXMLElement, n: Int) throws -> AEXMLElement {
        var theChild = root
        for _ in 1...n {
            if theChild.children.count == 1 {
                theChild = theChild.children[0]
            } else {
                throw SoapResponseError.ParseError
            }
        }
        return theChild
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let responseData = aDecoder.decodeObjectForKey(PropertyKey.responseDataKey) as? NSData
        let timestamp = aDecoder.decodeObjectForKey(PropertyKey.timestampKey) as! NSDate
        
        do {
            try self.init(responseData: responseData, timestamp: timestamp)
        } catch {
            return nil
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(responseData, forKey: PropertyKey.responseDataKey)
        aCoder.encodeObject(timestamp, forKey: PropertyKey.timestampKey)
    }
    
    func generateSoapResponseData() -> SoapResponseData {
        preconditionFailure("Subclasses must override")
    }
    
}