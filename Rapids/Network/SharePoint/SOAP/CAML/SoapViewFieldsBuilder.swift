//
//  SoapViewFieldsBuilder.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class SoapViewFieldsBuilder: SoapCamlBuilder {
    
    init() {
        super.init(rootName: "viewFields", firstChildName: "ViewFields")
    }
    
    func fieldRef(name: String) -> SoapViewFieldsBuilder {
        let fieldRef = SoapObject(namespace: nil, name: "FieldRef")
        fieldRef.setAttribute("Name", value: name)
        getCurrentObj().addElement(fieldRef)
        return self
    }
    
    override func up() -> SoapViewFieldsBuilder {
        return super.up() as! SoapViewFieldsBuilder
    }
    
}