//
//  CredentialsManager.swift
//  Rapids
//
//  Created by Programming 12 on 2016-04-01.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class CredentialsManager {
    
    static let sharedInstance = CredentialsManager()
    
    var username: String?
    var password: String?
    var userDisplayName: String?
    var signedIn: Bool = false
    
    func signin(usename: String, password: String, userDisplayName: String) {
        
    }
    
}