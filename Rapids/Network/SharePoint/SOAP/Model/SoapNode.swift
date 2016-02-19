//
//  SoapNode.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class SoapNode {
    
    var namespace: String
    var name: String
    var attributes = [String: String]()
    
    init(namespace: String, name: String) {
        self.namespace = namespace
        self.name = name
    }
    
    func getAttribute(name: String) -> String? {
        return attributes[name]
    }
    
    func setAttribute(name: String, value: String) {
        attributes[name] = value
    }
    
    func removeAttribute(name: String) {
        attributes[name] = nil
    }
    
}