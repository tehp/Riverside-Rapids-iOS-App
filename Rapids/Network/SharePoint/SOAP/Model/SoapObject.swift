//
//  SoapObject.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class SoapObject: SoapNode {
    
    var elements = [SoapNode]()
    
    func getElementAt(index: Int) -> SoapNode {
        return elements[index]
    }
    
    func addElement(element: SoapNode) {
        elements.append(element)
    }
    
    func addProperty(namespace: String, name: String, value: String) {
        let property = SoapPrimitive(namespace: namespace, name: name)
        property.text = value
        elements.append(property)
    }
    
    func removeElementAt(index: Int) {
        elements.removeAtIndex(index)
    }
    
}