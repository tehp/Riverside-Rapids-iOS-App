//
//  SharePointRequestManager.swift
//  Rapids
//
//  Created by Noah on 2016-03-06.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

import Alamofire

protocol SharePointRequestDelegate {
    typealias CacheType
    typealias ResponseType
    
    func didFailPreConditions(error: Int)
    func didFindCachedData(cachedData: CacheType)
    func willStartNetworkLoad()
    func didReceiveNetworkData(networkData: ResponseType)
    func didReceiveNetworkError(error: ErrorType)
    func didFinishNetworkLoad()
}

struct SharePointRequestErrors {
    static let ERROR_PRE_NOT_SIGNED_IN = 1;
    static let ERROR_PRE_NO_INTERNET = 2;
}

class SharePointSoapResponseHandler<ResponseType:SoapResponse, DelegateType:SharePointRequestDelegate where DelegateType.ResponseType == ResponseType>: SoapResponseDelegate {
    
    var cacheName: String?
    var delegate: DelegateType?
    
    init(cacheName: String?, delegate: DelegateType?) {
        self.cacheName = cacheName
        self.delegate = delegate
    }
    
    func didReceiveResponse(response: ResponseType) {
        if let cacheName = cacheName {
            SharePointRequestManager.sharedInstance.saveToCache(response.generateSoapResponseData(), name: cacheName)
        }
        
        if let actualDelegate = delegate {
            actualDelegate.didReceiveNetworkData(response)
            actualDelegate.didFinishNetworkLoad()
        }
    }
    
    func didReceiveError(error: ErrorType) {
        if let actualDelegate = delegate {
            actualDelegate.didReceiveNetworkError(error)
            actualDelegate.didFinishNetworkLoad()
        }
    }
    
}

class TeacherSPSitesResponseHandler<DelegateType:SharePointRequestDelegate where DelegateType.ResponseType == TeacherSPSitesResponse>: TeacherSPSitesResponseDelegate {
    
    var cacheName: String
    var delegate: DelegateType?
    
    init(cacheName: String, delegate: DelegateType?) {
        self.cacheName = cacheName
        self.delegate = delegate
    }
    
    func didReceiveResponse(responseData: TeacherSPSitesResponse) {
        SharePointRequestManager.sharedInstance.saveToCache(responseData, name: cacheName)
        if let actualDelegate = delegate {
            actualDelegate.didReceiveNetworkData(responseData)
            actualDelegate.didFinishNetworkLoad()
        }
    }
    
    func didReceiveError(error: ErrorType) {
        if let actualDelegate = delegate {
            actualDelegate.didReceiveNetworkError(error)
            actualDelegate.didFinishNetworkLoad()
        }
    }
    
}

class SharePointRequestManager {
    
    static let sharedInstance = SharePointRequestManager()
    
    static let CachesDirectory = NSFileManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first!

    struct RequestIDs {
        static let DAILY_ANNOUNCEMENTS = "dailyAnnouncements"
        static let SCHOOL_CALENDAR = "schoolCalendar"
        static let PUBLICATIONS = "publications"
        
        static let TEACHER_SP_SITES = "teacherSPSites"
    }
    
    let credentialsManager: CredentialsManager!
    
    init() {
        credentialsManager = CredentialsManager.sharedInstance
    }

    private func generateCacheUrl(name: String) -> NSURL {
        return SharePointRequestManager.CachesDirectory.URLByAppendingPathComponent("sharepoint-\(name)")
    }
    
    private func saveToCache<T: NSCoding>(data: T, name: String) -> Bool {
        let url = generateCacheUrl(name)
        return NSKeyedArchiver.archiveRootObject(data, toFile: url.path!)
    }
    
    private func loadFromCache<T: NSCoding>(name: String) -> T? {
        let url = generateCacheUrl(name)
        return NSKeyedUnarchiver.unarchiveObjectWithFile(url.path!) as? T
    }
    
    private func deleteCache(name: String) -> Bool {
        let url = generateCacheUrl(name)
        do {
            try NSFileManager.defaultManager().removeItemAtPath(url.path!)
            return true
        } catch {
            return false
        }
    }
    
    private func checkAuth(requiresAuth: Bool) -> Bool {
        return !requiresAuth || credentialsManager.signedIn
    }
    
    func getSPListItems<T: SharePointRequestDelegate where T.CacheType == GetListItemsResponseData, T.ResponseType == GetListItemsResponse>(networkOnly: Bool, requiresAuth: Bool, requestId: String?, url: String, listGUID: String, viewName: String?, query: SoapObject?, viewFields: SoapObject?, rowLimit: String?, queryOptions: SoapObject?, webID: String?, delegate: T) {
        
        let cacheEnabled = requestId != nil
        
        if !checkAuth(requiresAuth) {
            if cacheEnabled {
                deleteCache(requestId!)
            }
            delegate.didFailPreConditions(SharePointRequestErrors.ERROR_PRE_NOT_SIGNED_IN)
            return
        }
        
        if !networkOnly && cacheEnabled {
            // Attempt to load from cache first
            if let actualCachedData: GetListItemsResponseData = loadFromCache(requestId!) {
                delegate.didFindCachedData(actualCachedData)
            }
        }
        
        // For handling the response
        let responseHandler: SharePointSoapResponseHandler<GetListItemsResponse, T> = SharePointSoapResponseHandler(cacheName: requestId, delegate: delegate)
        
        // Create the request
        let request = GetListItemsRequest(
            url: url,
            username: credentialsManager.username,
            password: credentialsManager.password,
            listName: listGUID,
            viewName: viewName,
            query: query,
            viewFields: viewFields,
            rowLimit: rowLimit,
            queryOptions: queryOptions,
            webID: webID,
            responseDelegate: responseHandler)
        
        // Notify delegate that we are starting a network request
        delegate.willStartNetworkLoad()
        
        // Send the request
        request.sendRequest()
    }
    
    func getSPListCollection<T: SharePointRequestDelegate where T.CacheType == GetListCollectionResponseData, T.ResponseType == GetListCollectionResponse>(networkOnly: Bool, requiresAuth: Bool, requestId: String?, listsUrl: String, delegate: T) {
        
        let cacheEnabled = requestId != nil
        
        if !checkAuth(requiresAuth) {
            if cacheEnabled {
                deleteCache(requestId!)
            }
            delegate.didFailPreConditions(SharePointRequestErrors.ERROR_PRE_NOT_SIGNED_IN)
            return
        }
        
        if !networkOnly && cacheEnabled {
            // Attempt to load from cache first
            if let actualCachedData: GetListCollectionResponseData = loadFromCache(requestId!) {
                delegate.didFindCachedData(actualCachedData)
            }
        }
        
        // For handling the response
        let responseHandler: SharePointSoapResponseHandler<GetListCollectionResponse, T> = SharePointSoapResponseHandler(cacheName: requestId, delegate: delegate)
        
        // Create the request
        let request = GetListCollectionRequest(
            url: listsUrl,
            username: credentialsManager.username,
            password: credentialsManager.password,
            responseDelegate: responseHandler)
        
        // Notify delegate that we are starting a network request
        delegate.willStartNetworkLoad()
        
        // Send the request
        request.sendRequest()
    }
    
    func getAnnouncementsList<T: SharePointRequestDelegate where T.CacheType == GetListItemsResponseData, T.ResponseType == GetListItemsResponse>(networkOnly: Bool, requiresAuth: Bool, requestId: String, listsUrl: String, listGUID: String, isTasksList: Bool, delegate: T) {
        
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.stringFromDate(today)
        
        var viewFields: SoapCamlBuilder
        var query: SoapCamlBuilder
        
        if isTasksList {
            viewFields = SoapViewFieldsBuilder()
                .fieldRef("Title")
            
            query = SoapQueryBuilder()
                .orderBy(nil)
                    .fieldRef("Modified", attributes: ["Ascending": SoapCamlBuilder.BOOL_TRUE])
        } else {
            viewFields = SoapViewFieldsBuilder()
                .fieldRef("Body")
                .fieldRef("Title")
                .fieldRef("Attachments")
                .fieldRef("Modified")
            
            query = SoapQueryBuilder()
                .orderBy(nil)
                    .fieldRef("Modified", attributes: ["Ascending": SoapCamlBuilder.BOOL_FALSE])
                    .up()
                ._where()
                    .or()
                        .isNull()
                            .fieldRef("Expires", attributes: nil)
                            .up()
                        .geq()
                            .fieldRef("Expires", attributes: nil)
                            .value("DateTime", value: dateStr, attributes: ["IncludeTimeValue": SoapCamlBuilder.BOOL_FALSE])
        }
        
        let queryOptions = SoapQueryOptionsBuilder()
            .includeAttachmentUrls(true)
        
        let rowLimit = "50"
        
        getSPListItems(
            networkOnly,
            requiresAuth: requiresAuth,
            requestId: requestId,
            url: listsUrl,
            listGUID: listGUID,
            viewName: nil,
            query: query.complete(),
            viewFields: viewFields.complete(),
            rowLimit: rowLimit,
            queryOptions: queryOptions.complete(),
            webID: nil,
            delegate: delegate
        )
    }
    
    func getCalendarList<T: SharePointRequestDelegate where T.CacheType == GetListItemsResponseData, T.ResponseType == GetListItemsResponse>(networkOnly: Bool, requiresAuth: Bool, requestId: String, url: String, listGUID: String, delegate: T) {
        
        // Prepare SOAP Request
        // Set the fields we want to retrieve
        let viewFields = SoapViewFieldsBuilder()
        viewFields
            .fieldRef("Title")
            .fieldRef("EventDate")
            .fieldRef("EndDate")
            .fieldRef("Location")
            .fieldRef("Description")
            .fieldRef("fAllDayEvent")
            .fieldRef("fRecurrence")
            .fieldRef("Attachments")
        
        // Only retrieve announcements that are not expired or have no expiry date
        let schoolStart = SchoolDates.getEarliestSchoolStart()
        let schoolEnd = SchoolDates.getLatestSchoolEnd()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let schoolStartStr = dateFormatter.stringFromDate(schoolStart)
        let schoolEndStr = dateFormatter.stringFromDate(schoolEnd)
        
        let query = SoapQueryBuilder()
        query
            ._where()
                .and()
                    .geq()
                        .fieldRef("EventDate", attributes: nil)
                        .value("DateTime", value: schoolStartStr, attributes: ["IncludeTimeValue": SoapCamlBuilder.BOOL_FALSE])
                        .up()
                    .leq()
                        .fieldRef("EventDate", attributes: nil)
                        .value("DateTime", value: schoolEndStr, attributes: ["IncludeTimeValue": SoapCamlBuilder.BOOL_FALSE])
        
        //Get attachment URLs for details views
        let queryOptions = SoapQueryOptionsBuilder().includeAttachmentUrls(true)
        
        //Set a limit but a large enough one that we should never max it out
        let rowLimit = "1000"
        
        getSPListItems(
            networkOnly,
            requiresAuth: requiresAuth,
            requestId: requestId,
            url: url,
            listGUID: listGUID,
            viewName: nil,
            query: query.complete(),
            viewFields: viewFields.complete(),
            rowLimit: rowLimit,
            queryOptions: queryOptions.complete(),
            webID: nil,
            delegate: delegate
        )
    }
    
    func getDocumentsList<T: SharePointRequestDelegate where T.CacheType == GetListItemsResponseData, T.ResponseType == GetListItemsResponse>(networkOnly: Bool, requiresAuth: Bool, requestId: String?, listsUrl: String, listGUID: String, folder: String, delegate: T) {
        
        let viewFields = SoapViewFieldsBuilder()
            .fieldRef("LinkFilename")
            .fieldRef("FielRef")
            .fieldRef("FSObjType")
            .fieldRef("Modified")
        
        let queryOptions = SoapQueryOptionsBuilder()
            .folder(folder)
        
        let rowLimit = "500"
        
        getSPListItems(
            networkOnly,
            requiresAuth: requiresAuth,
            requestId: requestId,
            url: listsUrl,
            listGUID: listGUID,
            viewName: nil,
            query: nil,
            viewFields: viewFields.complete(),
            rowLimit: rowLimit,
            queryOptions: queryOptions.complete(),
            webID: nil,
            delegate: delegate
        )
    }
    
    func getDailyAnnouncements<T: SharePointRequestDelegate where T.CacheType == GetListItemsResponseData, T.ResponseType == GetListItemsResponse>(networkOnly: Bool, delegate: T) {
        
        // Prepare SOAP Request
        // Set the fields we want to retrieve
        let viewFields = SoapViewFieldsBuilder()
        viewFields
            .fieldRef("LinkTitle")
        
        // Only retrieve announcements that are not expired or have no expiry date
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.stringFromDate(today)
        
        let query = SoapQueryBuilder()
        query
            .orderBy(nil)
                .fieldRef("Categories", attributes: ["Ascending": SoapCamlBuilder.BOOL_TRUE])
                .fieldRef("Created", attributes: ["Ascending": SoapCamlBuilder.BOOL_TRUE])
                .up()
            ._where()
                .or()
                    .isNull()
                        .fieldRef("Expires", attributes: nil)
                        .up()
                    .geq()
                        .fieldRef("Expires", attributes: nil)
                        .value("DateTime", value: dateStr, attributes: ["IncludeTimeValue": SoapCamlBuilder.BOOL_FALSE])
        
        // Other parameters for the SOAP request
        let url = D.SharePoint.INTRANET_LISTS_URL
        let listName = D.SharePoint.DAILY_ANNOUNCEMENTS_GUID
        let rowLimit = "50"
        
        getSPListItems(
            networkOnly,
            requiresAuth: true,
            requestId: RequestIDs.DAILY_ANNOUNCEMENTS,
            url: url,
            listGUID: listName,
            viewName: nil,
            query: query.complete(),
            viewFields: viewFields.complete(),
            rowLimit: rowLimit,
            queryOptions: nil,
            webID: nil,
            delegate: delegate
        )
    }
    
    func getSchoolCalendar<T: SharePointRequestDelegate where T.CacheType == GetListItemsResponseData, T.ResponseType == GetListItemsResponse>(networkOnly: Bool, delegate: T) {
        
        getCalendarList(networkOnly, requiresAuth: false, requestId: RequestIDs.SCHOOL_CALENDAR, url: D.SharePoint.PUBLIC_LISTS_URL, listGUID: D.SharePoint.CALENDAR_GUID, delegate: delegate)
    }
    
    func getPublications<T: SharePointRequestDelegate where T.CacheType == GetListItemsResponseData, T.ResponseType == GetListItemsResponse>(networkOnly: Bool, delegate: T) {
        
        getDocumentsList(networkOnly, requiresAuth: false, requestId: RequestIDs.PUBLICATIONS, listsUrl: D.SharePoint.PUBLIC_LISTS_URL, listGUID: D.SharePoint.PUBLICATIONS_GUID, folder: D.SharePoint.PUBLICATIONS_ROOT_FOLDER_PATH, delegate: delegate)
    }
    
    func getTeacherSPSites<T: SharePointRequestDelegate where T.CacheType == TeacherSPSitesResponse, T.ResponseType == TeacherSPSitesResponse>(networkOnly: Bool, delegate: T) {
        
        let requestId = RequestIDs.TEACHER_SP_SITES
        
        if !checkAuth(true) {
            deleteCache(requestId)
            delegate.didFailPreConditions(SharePointRequestErrors.ERROR_PRE_NOT_SIGNED_IN)
            return
        }
        
        if !networkOnly {
            // Attempt to load from cache first
            if let actualCachedData: TeacherSPSitesResponse = loadFromCache(requestId) {
                delegate.didFindCachedData(actualCachedData)
            }
        }
        
        // For handling the response
        let responseHandler: TeacherSPSitesResponseHandler<T> = TeacherSPSitesResponseHandler(cacheName: requestId, delegate: delegate)
        
        // Create the request
        let request = TeacherSPSitesRequest(
            username: credentialsManager.username,
            password: credentialsManager.password,
            responseDelegate: responseHandler
        )
        
        // Notify delegate that we are starting a network request
        delegate.willStartNetworkLoad()
        
        // Send the request
        request.sendRequest()
    }
    
    func getUserInfo<T: SharePointRequestDelegate where T.ResponseType == NSDictionary>(username: String, password: String, delegate: T) {

        let authHeader = NetworkUtils.generateBasicAuthHeader(username, password: password)
        
        delegate.willStartNetworkLoad()
        
        Alamofire.request(.GET, D.Proxy.SP.GET_USER_INFO, headers: ["Authorization": authHeader])
            .responseJSON { response in
                switch response.result {
                case .Success(let json):
                    let response = json as! NSDictionary
                    delegate.didReceiveNetworkData(response)
                    
                case .Failure(let error):
                    delegate.didReceiveNetworkError(error)
                    
                }
                
                delegate.didFinishNetworkLoad()
        }
    }
    
}