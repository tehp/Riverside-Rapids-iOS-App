//
//  TeacherSPSitesRequest.swift
//  Rapids
//
//  Created by Noah on 2016-05-02.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation
import Alamofire

protocol TeacherSPSitesResponseDelegate: class {
    func didReceiveResponse(responseData: TeacherSPSitesResponse)
    func didReceiveError(error: ErrorType)
}

class TeacherSPSitesRequest {
    
    var username: String
    var password: String
    var responseDelegate: TeacherSPSitesResponseDelegate?
    
    init(username: String, password: String, responseDelegate: TeacherSPSitesResponseDelegate?) {
        self.username = username
        self.password = password
        self.responseDelegate = responseDelegate
    }
    
    func sendRequest() {
        let authHeader = NetworkUtils.generateBasicAuthHeader(username, password: password)
        
        Alamofire.request(.GET, D.SharePoint.GET_TEACHER_SP_SITES_URL, headers: ["Authorization": authHeader])
            .responseJSON { response in
                if let actualDelegate = self.responseDelegate {
                    switch response.result {
                        
                    case .Success(let json):
                        let responseData = json as! NSDictionary
                        print(responseData)
                        print(json)
                        actualDelegate.didReceiveResponse(self.parseResponse(responseData))
                        
                    case .Failure(let error):
                        actualDelegate.didReceiveError(error)
                        
                    }
                }
        }
    }
    
    private func parseResponse(json: NSDictionary) -> TeacherSPSitesResponse {
        var sites = [TeacherSPSite]()
        
        for site in json["teacherSPSites"]! as! [NSDictionary] {
            //let id = site["id"]! as! Int64
            let teacherSalutation = site["teacherSalutation"]! as! String
            let teacherLastName = site["teacherLastName"]! as! String
            let course = site["course"]! as! String
            let websiteUrl = site["websiteUrl"]! as! String
            
            sites.append(TeacherSPSite(id: 0, teacherSalutation: teacherSalutation, teacherLastName: teacherLastName, course: course, websiteUrl: websiteUrl))
        }
        
        return TeacherSPSitesResponse(timestamp: NSDate(), sites: sites)
    }
}