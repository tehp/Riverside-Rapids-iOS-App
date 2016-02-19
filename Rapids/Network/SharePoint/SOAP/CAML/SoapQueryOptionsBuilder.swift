//
//  SoapQueryOptionsBuilder.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class SoapQueryOptionsBuilder: SoapCamlBuilder {
    
    init() {
        super.init(rootName: "queryOptions", firstChildName: "QueryOptions")
    }
    
    func folder(folderValue: String) -> SoapQueryOptionsBuilder {
        createChildNode("Folder", value: folderValue, attributes: nil)
        return self
    }
    
    func paging(pagingStr: String) -> SoapQueryOptionsBuilder {
        createChildNode("Paging", value: "", attributes: ["ListItemCollectionPositionNext": pagingStr])
        return self
    }
    
    func includeMandatoryColumns(include: Bool) -> SoapQueryOptionsBuilder {
        createChildNode("IncludeMandatoryColumns", value: getBoolString(include), attributes: nil)
        return self
    }
    
    func includeAttachmentUrls(include: Bool) -> SoapQueryOptionsBuilder {
        createChildNode("IncludeAttachmentUrls", value: getBoolString(include), attributes: nil)
        return self
    }
    
    override func up() -> SoapQueryOptionsBuilder {
        return super.up() as! SoapQueryOptionsBuilder
    }
    
}