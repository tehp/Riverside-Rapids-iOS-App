//
//  SoapQueryBuilder.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class SoapQueryBuilder: SoapCamlBuilder {
    
    init() {
        super.init(rootName: "query", firstChildName: "Query")
    }
    
    func _where() -> SoapQueryBuilder {
        createParentNode("Where", attributes: nil)
        return self
    }
    
    func orderBy(attributes: [String: String]?) -> SoapQueryBuilder {
        createParentNode("OrderBy", attributes: attributes)
        return self
    }
    
    func groupBy() -> SoapQueryBuilder {
        createParentNode("GroupBy", attributes: nil)
        return self
    }
    
    func or() -> SoapQueryBuilder {
        createParentNode("Or", attributes: nil)
        return self
    }
    
    func and() -> SoapQueryBuilder {
        createParentNode("And", attributes: nil)
        return self
    }
    
    func dateRangesOverlap() -> SoapQueryBuilder {
        createParentNode("DateRangesOverlap", attributes: nil)
        return self
    }
    
    func geq() -> SoapQueryBuilder {
        createParentNode("Geq", attributes: nil)
        return self
    }
    
    func gt() -> SoapQueryBuilder {
        createParentNode("Gt", attributes: nil)
        return self
    }
    
    func eq() -> SoapQueryBuilder {
        createParentNode("Eq", attributes: nil)
        return self
    }
    
    func neq() -> SoapQueryBuilder {
        createParentNode("Neq", attributes: nil)
        return self
    }
    
    func leq() -> SoapQueryBuilder {
        createParentNode("Leq", attributes: nil)
        return self
    }
    
    func lt() -> SoapQueryBuilder {
        createParentNode("Lt", attributes: nil)
        return self
    }
    
    func _in() -> SoapQueryBuilder {
        createParentNode("In", attributes: nil)
        return self
    }
    
    func isNull() -> SoapQueryBuilder {
        createParentNode("IsNull", attributes: nil)
        return self
    }
    
    func isNotNull() -> SoapQueryBuilder {
        createParentNode("IsNotNull", attributes: nil)
        return self
    }
    
    func contains() -> SoapQueryBuilder {
        createParentNode("Contains", attributes: nil)
        return self
    }
    
    func beginsWith() -> SoapQueryBuilder {
        createParentNode("BeginsWith", attributes: nil)
        return self
    }
    
    func includes() -> SoapQueryBuilder {
        createParentNode("Includes", attributes: nil)
        return self
    }
    
    func values() -> SoapQueryBuilder {
        createParentNode("Values", attributes: nil)
        return self
    }
    
    func fieldRef(name: String, attributes: [String: String]?) -> SoapQueryBuilder {
        var newAttributes = attributes
        if newAttributes == nil {
            newAttributes = [String: String]()
        }
        newAttributes!["Name"] = name
        createChildNode("FieldRef", value: "", attributes: newAttributes)
        return self
    }
    
    func value(type: String, value: String, attributes: [String: String]) -> SoapQueryBuilder {
        var newAttributes = attributes
        newAttributes["Type"] = type
        createChildNode("Value", value: value, attributes: newAttributes)
        return self
    }
    
    override func up() -> SoapQueryBuilder {
        return super.up() as! SoapQueryBuilder
    }
    
}