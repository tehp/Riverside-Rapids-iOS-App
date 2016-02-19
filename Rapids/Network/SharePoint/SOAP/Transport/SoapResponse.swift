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

class SoapResponse {
    
    private var document: AEXMLDocument!
    var contentRoot: AEXMLElement!
    
    init(responseData: NSData?) throws {
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
    
}