//
//  SoapRequest.swift
//  Rapids
//
//  Created by Noah on 2016-02-16.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

import Alamofire

class SoapRequest<ResponseType:SoapResponse, DelegateType:SoapResponseDelegate where DelegateType.ResponseType == ResponseType>: NSObject, NSURLSessionDelegate {
    
    let NAMESPACE = "http://schemas.microsoft.com/sharepoint/soap/"
    
    var methodName: String
    var soapAction: String
    var url: String
    var username: String?
    var password: String?
    
    var request: SoapObject! = nil
    var responseDelegate: DelegateType?
    
    init(methodName: String, url: String, username: String?, password: String?, responseDelegate: DelegateType?) {
        self.methodName = methodName
        self.soapAction = NAMESPACE + methodName
        self.url = url
        self.username = username
        self.password = password
        self.responseDelegate = responseDelegate
    }
    
    private func prepareRequest() {
        self.request = SoapObject(namespace: nil, name: methodName)
        request.setAttribute("xmlns", value: NAMESPACE)
        populateRequestParams(request)
    }
    
    func populateRequestParams(request: SoapObject) {
        // Do nothing - for subclasses to override
    }
    
    func generateResponse(responseData: NSData?) throws -> ResponseType {
        preconditionFailure("Subclasses must override this method")
    }
    
    func sendRequest() {
        prepareRequest()
        
        // Generate the SOAP XML to send
        let envelope = SoapEnvelope(root: request)
        let xmlString = envelope.toFullXMLString()
        
        // Encode the SOAP XML
        let encodedData: NSData! = xmlString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Create the URL Request
        let realUrl = NSURL(string: url)!
        let urlRequest = NSMutableURLRequest(URL: realUrl)
        urlRequest.HTTPMethod = "POST"
        
        // Attach the body
        urlRequest.HTTPBody = encodedData
        
        // Set the necessary HTTP Headers
        urlRequest.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("\(encodedData.length)", forHTTPHeaderField: "Content-Length")
        
        // Send the request using Alamofire
        Alamofire.request(urlRequest)
            .authenticate(user: username!, password: password!)
            .response(completionHandler: { (request, response, data, responseError) in
                if let actualDelegate = self.responseDelegate {
                    // Check for network error
                    guard responseError == nil && data != nil else {
                        actualDelegate.didReceiveError(responseError!)
                        return
                    }
                    
                    // Check status code
                    if let httpStatus = response where httpStatus.statusCode != 200 {
                        actualDelegate.didReceiveError(SoapResponseError.StatusCodeError)
                        return
                    }

                    // Try to parse the response
                    do {
                        let responseObject = try self.generateResponse(data)
                        actualDelegate.didReceiveResponse(responseObject)
                    } catch {
                        actualDelegate.didReceiveError(error)
                    }
                }
            })
    }
    
}