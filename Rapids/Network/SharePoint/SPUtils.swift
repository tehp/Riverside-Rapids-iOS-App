//
//  SPUtils.swift
//  Rapids
//
//  Created by Noah on 2016-05-11.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation
import Alamofire

struct SPFile {
    var isFolder: Bool
    var title: String
    var encodedFullUrl: String
    var soapUrl: String
    var lastModified: String
}

class SPUtils {
    
    static let LISTS_WEBSERVICE_SUFFIX = "_vti_bin/lists.asmx"
    
    static func getListsUrl(websiteUrl: String) -> String {
        let startIndex = websiteUrl.startIndex
        let endIndex = websiteUrl.rangeOfString("/", options: .BackwardsSearch)!.startIndex
        return websiteUrl[startIndex...endIndex] + LISTS_WEBSERVICE_SUFFIX
    }
    
    static func getBaseUrl(listUrl: String) -> String {
        let urlComponents = NSURLComponents(string: listUrl)!
        return urlComponents.scheme! + "://" + urlComponents.host!
    }
    
    static func getTeacherSPSitesCourse(courseName: String) -> String {
        return (courseName == "") ? "Home" : courseName
    }
    
    static func generateRequestId(list: SPList) -> String {
        return "spList_" + list.guid
    }
    
    static func getFileIconName(fileNameWithExt: String) -> String {
        let fileNameWithExtLower = fileNameWithExt.lowercaseString
        if fileNameWithExtLower.hasSuffix(".pdf") {
            return "File-PDF"
        } else if fileNameWithExtLower.hasSuffix(".ppt") || fileNameWithExtLower.hasSuffix(".pptx") {
            return "File-PPT"
        } else if fileNameWithExtLower.hasSuffix(".doc") || fileNameWithExtLower.hasSuffix(".docx") {
            return "File-DOC"
        } else if fileNameWithExtLower.hasSuffix(".jpg") || fileNameWithExtLower.hasSuffix(".jpeg") || fileNameWithExtLower.hasSuffix(".png") || fileNameWithExtLower.hasSuffix(".gif") || fileNameWithExtLower.hasSuffix(".tif") || fileNameWithExtLower.hasSuffix(".tiff") {
            return "File-IMG"
        } else {
            return "File-Unknown"
        }
    }
    
    static func downloadAndDisplayFile(file: SPFile, docControllerDelegate: UIDocumentInteractionControllerDelegate) {
        downloadAndDisplayFile(file.encodedFullUrl, docControllerDelegate: docControllerDelegate)
    }
    
    static func downloadAndDisplayFile(url: URLStringConvertible, docControllerDelegate: UIDocumentInteractionControllerDelegate) {
        var localPath: NSURL?
        Alamofire.download(.GET, url, destination: { (temporaryURL, response) in
            let directoryURL = AppDelegate.tempFolder
            let pathComponent = response.suggestedFilename
            localPath = directoryURL.URLByAppendingPathComponent(pathComponent!)
            return localPath!
        })
            .authenticate(user: CredentialsManager.sharedInstance.username, password: CredentialsManager.sharedInstance.password)
            .response { (request, response, data, error) in
                let docController = UIDocumentInteractionController(URL: localPath!)
                docController.delegate = docControllerDelegate
                docController.presentPreviewAnimated(true)
        }
    }
}