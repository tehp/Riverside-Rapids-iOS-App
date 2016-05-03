//
//  NetworkUtils.swift
//  Rapids
//
//  Created by Noah on 2016-05-03.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class NetworkUtils {
    
    static func generateBasicAuthHeader(username: String, password: String) -> String {
        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let authHeader = "Basic " + base64Credentials
        return authHeader
    }
    
}