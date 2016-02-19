//
//  SoapEnvelope.swift
//  Rapids
//
//  Created by Noah on 2016-02-18.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

import AEXML

class SoapEnvelope: SoapObject {
    
    let SOAP_NAMESPACE = "http://www.w3.org/2003/05/soap-envelope"
    let SOAP_NAMESPACE_NAME = "soap12"
    
    init(root: SoapObject) {
        super.init(namespace: SOAP_NAMESPACE_NAME, name: "Envelope")
        
        let body = SoapObject(namespace: SOAP_NAMESPACE_NAME, name: "Body")
        body.addElement(root)
        
        setAttribute("xmlns:\(SOAP_NAMESPACE_NAME)", value: SOAP_NAMESPACE)
        addElement(body)
    }
    
    func toFullXMLString() -> String {
        let document = AEXMLDocument()

        let root = super.toXMLElement()
        document.addChild(root)
        
        return document.xmlString
    }
    
}