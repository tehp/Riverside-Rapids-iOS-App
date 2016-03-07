//
//  SharePointRequestManager.swift
//  Rapids
//
//  Created by Noah on 2016-03-06.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

protocol SharePointRequestDelegate {
    typealias CacheType
    typealias ResponseType
    
    func didFindCachedData(cachedData: CacheType)
    func willStartNetworkLoad()
    func didReceiveNetworkData(networkData: ResponseType)
    func didReceiveNetworkError(error: ErrorType)
    func didFinishNetworkLoad()
}

class SharePointSoapResponseHandler<ResponseType:SoapResponse, DelegateType:SharePointRequestDelegate where DelegateType.ResponseType == ResponseType>: SoapResponseDelegate {
    
    var cacheName: String
    var delegate: DelegateType?
    
    init(cacheName: String, delegate: DelegateType?) {
        self.cacheName = cacheName
        self.delegate = delegate
    }
    
    func didReceiveResponse(response: ResponseType) {
        SharePointRequestManager.sharedInstance.saveToCache(response.generateSoapResponseData(), name: cacheName)
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

class SharePointRequestManager {
    
    static let sharedInstance = SharePointRequestManager()
    
    static let CachesDirectory = NSFileManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first!

    struct CacheNames {
        static let DAILY_ANNOUNCEMENTS = "dailyAnnouncements"
        static let CALENDAR = "calendar"
    }
    
    private func generateCacheUrl(name: String) -> NSURL {
        return SharePointRequestManager.CachesDirectory.URLByAppendingPathComponent("sharepoint-\(name)")
    }
    
    private func saveToCache<T: SoapResponseData>(data: T, name: String) -> Bool {
        let url = generateCacheUrl(name)
        return NSKeyedArchiver.archiveRootObject(data, toFile: url.path!)
    }
    
    private func loadFromCache<T: SoapResponseData>(name: String) -> T? {
        let url = generateCacheUrl(name)
        return NSKeyedUnarchiver.unarchiveObjectWithFile(url.path!) as? T
    }
    
    func requestDailyAnnouncements<T: SharePointRequestDelegate where T.CacheType == GetListItemsResponseData, T.ResponseType == GetListItemsResponse>(networkOnly: Bool, username: String, password: String, delegate: T) {
        
        if !networkOnly {
            // Attempt to load from cache first
            if let actualCachedData: GetListItemsResponseData = loadFromCache(CacheNames.DAILY_ANNOUNCEMENTS) {
                delegate.didFindCachedData(actualCachedData)
            }
        }
        
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
        
        // For handling the response
        let responseHandler: SharePointSoapResponseHandler<GetListItemsResponse, T> = SharePointSoapResponseHandler(cacheName: CacheNames.DAILY_ANNOUNCEMENTS, delegate: delegate)
        
        // Create the request
        let request = GetListItemsRequest(
            url: url,
            username: username,
            password: password,
            listName: listName,
            viewName: nil,
            query: query.complete(),
            viewFields: viewFields.complete(),
            rowLimit: rowLimit,
            queryOptions: nil,
            webID: nil,
            responseDelegate: responseHandler)
        
        // Notify delegate that we are starting a network request
        delegate.willStartNetworkLoad()
        
        // Send the request
        request.sendRequest()
    }
    
    func requestCalendar<T: SharePointRequestDelegate where T.CacheType == GetListItemsResponseData, T.ResponseType == GetListItemsResponse>(networkOnly: Bool, username: String, password: String, delegate: T) {
        
    }
    
}