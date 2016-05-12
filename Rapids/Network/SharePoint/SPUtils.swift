//
//  SPUtils.swift
//  Rapids
//
//  Created by Noah on 2016-05-11.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

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
}