//
//  D.swift
//  Rapids
//
//  Created by Programming on 2016-02-25.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class D {
    
    private static let DEBUG = true
    
    //APP SEVER
    private static let ROOT_APP_SERVER = 1
    private static let ROOT_APP_SERVER_STAGING = "https://temporal-nebula-614.appspot.com/"
    private static let ROOT_APP_SERVER_PROD = "https://rsideapp.appspot.com/"
    
    //TEACHER SharePoint
    private static let ROOT_TEACHER_SP = 2
    private static let ROOT_TEACHER_SP_STAGING = "https://adept-bond-846.appspot.com/"
    private static let ROOT_TEACHER_SP_PROD = "https://rsideapp-teachersp.appspot.com/"
    
    static func isDebug() -> Bool {
        return DEBUG
    }
    
    private static func getRoot(root: Int) -> String {
        switch root {
        case ROOT_APP_SERVER:
            return isDebug() ? ROOT_APP_SERVER_STAGING : ROOT_APP_SERVER_PROD
        case ROOT_TEACHER_SP:
            return isDebug() ? ROOT_TEACHER_SP_STAGING : ROOT_TEACHER_SP_PROD
        default:
            return ""
        }
    }
    
    struct Proxy {

        struct SP {
            static let GET_USER_INFO = "https://rssrapids-proxy.appspot.com/api/sp/GetUserInfo"
        }
        
    }
    
    struct SharePoint {
        //For Authentication
        static let DOMAIN = "sd43"
        static let WORKSTATION = ""
        
        //URLs
        static let AUTH_URL = "https://my43.sd43.bc.ca/schools/Riverside/riversideapp/authentication/_vti_bin/authentication.asmx"
        static let INTRANET_LISTS_URL = "https://my43.sd43.bc.ca/schools/riverside/_vti_bin/lists.asmx"
        static let PUBLIC_LISTS_URL = "http://www.sd43.bc.ca/school/riverside/_vti_bin/lists.asmx"
        
        //GUIDs
        static let DAILY_ANNOUNCEMENTS_GUID = "{6B015937-2798-4C8F-B654-F49E28A71851}"
        static let CALENDAR_GUID = "{7ECB811F-B879-4507-A91F-3CFAE71FC576}"
        static let PUBLICATIONS_GUID = "{7611B87A-F409-4D8B-92A9-42BE7CD410DE}"
        static let STAFF_DIRECTORY_GUID = "{06082896-5AF7-4675-8123-2809342477F6}"
        
        //Other
        static let PUBLICATIONS_ROOT_FOLDER_PATH = "/secondary/riverside/Publications"
        
        //Teacher SharePoint Sites Index
        static let GET_TEACHER_SP_SITES_URL = "https:/rssrapids-teachersp.appspot.com/api/siteindex/GetTeacherSPSites"
    }
    
    struct BellSchedule {
        //static let GET_URL = D.getRoot(ROOT_APP_SERVER) + "bellschedule/v2/get_bs_cal"
        static let GET_URL = "https://rssrapids-bellschedule.appspot.com/api/bscal/v2/get_bs_cal"
        static let GET_URL_PARAM_START_YEAR = "startYear"
    }
    
}