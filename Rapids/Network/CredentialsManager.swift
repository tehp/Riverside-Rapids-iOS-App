//
//  CredentialsManager.swift
//  Rapids
//
//  Created by Programming 12 on 2016-04-01.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation
import KeychainSwift

class CredentialsManager {
    
    static let sharedInstance = CredentialsManager()
    
    struct KeychainKeys {
        static let USERNAME = "ca.bc.sd43.riverside.sp.auth.Username"
        static let PASSWORD = "ca.bc.sd43.riverside.sp.auth.Password"
        static let USER_DISPLAY_NAME = "ca.bc.sd43.riverside.sp.auth.UserDisplayName"
    }
    
    var username: String = ""
    var password: String = ""
    var userDisplayName: String = ""
    var signedIn: Bool = false
    
    init() {
        loadCredentials()
    }
    
    func signIn(username: String, password: String, userDisplayName: String) {
        self.username = username
        self.password = password
        self.userDisplayName = userDisplayName
        self.signedIn = true
        saveCredentials()
    }
    
    func signOut() {
        self.username = ""
        self.password = ""
        self.userDisplayName = ""
        self.signedIn = false
        saveCredentials()
    }
    
    func saveCredentials() {
        let keychain = KeychainSwift()
        keychain.set(username, forKey: KeychainKeys.USERNAME)
        keychain.set(password, forKey: KeychainKeys.PASSWORD)
        keychain.set(userDisplayName, forKey: KeychainKeys.USER_DISPLAY_NAME)
    }
    
    func loadCredentials() {
        let keychain = KeychainSwift()
        let loadedUsername = keychain.get(KeychainKeys.USERNAME)
        let loadedPassword = keychain.get(KeychainKeys.PASSWORD)
        let loadedUserDisplayName = keychain.get(KeychainKeys.USER_DISPLAY_NAME)
        if loadedUsername != nil && loadedUsername != "" &&
            loadedPassword != nil && loadedPassword != "" &&
            loadedUserDisplayName != nil && loadedUserDisplayName != "" {
            username = loadedUsername!
            password = loadedPassword!
            userDisplayName = loadedUserDisplayName!
            signedIn = true
        } else {
            username = ""
            password = ""
            userDisplayName = ""
            signedIn = false
        }
    }
}