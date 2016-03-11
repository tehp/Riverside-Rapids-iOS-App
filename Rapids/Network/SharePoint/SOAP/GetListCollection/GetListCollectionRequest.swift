//
//  GetListCollectionRequest.swift
//  Rapids
//
//  Created by Programming on 2016-03-11.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class GetListCollectionRequest<DelegateType:SoapResponseDelegate where DelegateType.ResponseType == GetListCollectionResponse>: SoapRequest<GetListCollectionResponse, DelegateType> {

    let METHOD_NAME = "GetListCollection"
    
    init(url: String, username: String, password: String, responseDelegate: DelegateType) {
        super.init(methodName: METHOD_NAME, url: url, username: username, password: password, responseDelegate: responseDelegate)
    }
    
    override func populateRequestParams(request: SoapObject) {
        // Do nothing
    }
    
    override func generateResponse(responseData: NSData?) throws -> GetListCollectionResponse {
        return try GetListCollectionResponse(responseData: responseData, timestamp: NSDate())
    }
    
}