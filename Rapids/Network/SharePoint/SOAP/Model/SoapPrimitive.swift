//
//  SoapPrimitive.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

import AEXML

class SoapPrimitive: SoapNode {
    
    var text = ""
    
    override func toXMLElement() -> AEXMLElement {
        let element = super.toXMLElement()
        element.value = text
        return element
    }
    
}