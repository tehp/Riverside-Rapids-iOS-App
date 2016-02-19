//
//  SoapRequest.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class SoapRequest {
    
    let NAMESPACE = "http://schemas.microsoft.com/sharepoint/soap/"
    
    var methodName: String
    var soapAction: String
    var url: String
    var username: String?
    var password: String?
    
    var request: SoapObject! = nil
    //TODO
    
    init(methodName: String, url: String, username: String?, password: String?) {
        self.methodName = methodName
        self.soapAction = NAMESPACE + methodName
        self.url = url
        self.username = username
        self.password = password
    }
    
    func prepareRequest() {
        self.request = SoapObject(namespace: NAMESPACE, name: methodName)
        populateRequestParams(self.request)
    }
    
    func populateRequestParams(request: SoapObject) {
        // Do nothing - for subclasses to override
    }
    
    func sendRequest() {
        //TODO
    }
    
}