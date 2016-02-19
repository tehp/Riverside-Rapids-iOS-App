//
//  GetListItemsRequest.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class GetListItemsRequest<DelegateType:SoapResponseDelegate where DelegateType.ResponseType == GetListItemsResponse>: SoapRequest<GetListItemsResponse, DelegateType> {
    
    let METHOD_NAME = "GetListItems"
    
    var listName: String
    var viewName: String?
    var query: SoapObject?
    var viewFields: SoapObject?
    var rowLimit: String?
    var queryOptions: SoapObject?
    var webID: String?
    
    init(url: String, username: String, password: String?, listName: String, viewName: String?, query: SoapObject?, viewFields: SoapObject?, rowLimit: String?, queryOptions: SoapObject?, webID: String?, responseDelegate: DelegateType) {
        
        self.listName = listName
        self.viewName = viewName
        self.query = query
        self.viewFields = viewFields
        self.rowLimit = rowLimit
        self.queryOptions = queryOptions
        self.webID = webID
        
        super.init(methodName: METHOD_NAME, url: url, username: username, password: password, responseDelegate: responseDelegate)
    }
    
    override func populateRequestParams(request: SoapObject) {
        request.addProperty(nil, name: "listName", value: listName)
        
        if let actualViewName = viewName {
            request.addProperty(nil, name: "viewName", value: actualViewName)
        }
        
        if let actualQuery = query {
            request.addElement(actualQuery)
        }
        
        if let actualViewFields = viewFields {
            request.addElement(actualViewFields)
        }
        
        if let actualRowLimit = rowLimit {
            request.addProperty(nil, name: "rowLimit", value: actualRowLimit)
        }
        
        if let actualQueryOptions = queryOptions {
            request.addElement(actualQueryOptions)
        }
        
        if let actualWebID = webID {
            request.addProperty(nil, name: "webID", value: actualWebID)
        }
    }
    
    override func generateResponse(responseData: NSData?) throws -> GetListItemsResponse {
        return try GetListItemsResponse(responseData: responseData)
    }
    
}