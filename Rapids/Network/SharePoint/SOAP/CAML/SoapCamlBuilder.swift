//
//  SoapCamlBuilder.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class SoapCamlBuilder {

    static let BOOL_TRUE = "TRUE"
    static let BOOL_FALSE = "FALSE"
    
    var root: SoapObject
    
    var objStack = [SoapObject]()
    var currentObjPointer = 0
    
    init(rootName: String, firstChildName: String) {
        // Create the root object
        self.root = SoapObject(namespace: "", name: rootName)
        
        // Create the first child object and add it to the current
        let firstChild = SoapObject(namespace: "", name: firstChildName)
        self.root.addElement(firstChild)
        
        // Add the first child to the stack so we are pointing to it to start
        objStack.append(firstChild)
    }
    
    func getBoolString(boolVal: Bool) -> String {
        return boolVal ? SoapCamlBuilder.BOOL_TRUE : SoapCamlBuilder.BOOL_FALSE
    }
    
    func getCurrentObj() -> SoapObject {
        return objStack[currentObjPointer]
    }
    
    func createParentNode(name: String, attributes: [String: String]?) -> SoapCamlBuilder {
        // Create the node
        let node = SoapObject(namespace: "", name: name)
        
        // Fill in any provided attributes
        if let actualAttributes = attributes {
            for (name, value) in actualAttributes {
                node.setAttribute(name, value: value)
            }
        }
        
        // Add the node to the current object and make it the new current object
        objStack[currentObjPointer].addElement(node)
        objStack.append(node)
        currentObjPointer++
        
        return self
    }
    
    func createChildNode(name: String, value: String, attributes: [String: String]?) -> SoapCamlBuilder {
        // Create the node
        let node = SoapPrimitive(namespace: "", name: name)
        
        // Fill in any provided attributes
        if let actualAttributes = attributes {
            for (name, value) in actualAttributes {
                node.setAttribute(name, value: value)
            }
        }
        
        // Set the text of the node
        node.text = value
        
        // Add the node to the current object (don't make it the current object because it's a primitive so it can't have any children)
        getCurrentObj().addElement(node)
        
        return self
    }
    
    func up() -> SoapCamlBuilder {
        objStack.removeAtIndex(currentObjPointer)
        currentObjPointer--
        return self
    }
    
    func complete() -> SoapObject {
        return root
    }
}