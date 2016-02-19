//
//  SoapRequest.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

import Alamofire

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
    
    private func prepareRequest() {
        self.request = SoapObject(namespace: nil, name: methodName)
        request.setAttribute("xmlns", value: NAMESPACE)
        populateRequestParams(self.request)
    }
    
    func populateRequestParams(request: SoapObject) {
        // Do nothing - for subclasses to override
    }
    
    func sendRequest() {
        prepareRequest()
        
        let envelope = SoapEnvelope(root: request)
        let xmlString = envelope.toFullXMLString()
        
        if username != nil && password != nil {
            let authString = "\(username):\(password)"
            let authData = authString.dataUsingEncoding(NSUTF8StringEncoding)
            let authBase64 = authData?.base64EncodedDataWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            let realUrl = NSURL(string: url)!
            let urlRequest = NSMutableURLRequest(URL: realUrl)
            urlRequest.HTTPMethod = "POST"
            
            let encodedData = xmlString.dataUsingEncoding(NSUTF8StringEncoding)
            
            urlRequest.timeoutInterval = 60
            urlRequest.HTTPBody = encodedData
            urlRequest.HTTPShouldHandleCookies = false
            urlRequest.setValue("Basic \(authBase64)", forHTTPHeaderField: "Authorization")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) { data, response, error in
                
                guard error == nil && data != nil else {
                    print("error = \(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }
            task.resume()
        }
    }
    
}