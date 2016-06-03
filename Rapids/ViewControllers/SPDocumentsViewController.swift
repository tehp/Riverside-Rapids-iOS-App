//
//  SPDocumentsViewController.swift
//  Rapids
//
//  Created by Noah on 2016-05-13.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

import Alamofire

class SPDocumentsViewController: UITableViewController, SharePointDataViewer, UIDocumentInteractionControllerDelegate {

    let ATTR_TITLE = "ows_LinkFilename"
    let ATTR_FILE = "ows_FileRef"
    let ATTR_FS_OBJ_TYPE = "ows_FSObjType"
    let ATTR_MODIFIED = "ows_Modified"
    
    // Protocol requirements
    var errMsgRetrieve = "Unable to retrieve documents.\nPull down to refresh."
    var errMsgUpdate = "Unable to update documents.\nPlease check your internet connection."
    var errMsgEmpty = "This folder is empty"
    var errMsgAuth = "Please sign in to view this document library"
    
    var showPopupError: Bool = false
    var lastUpdated: NSDate?
    var lastSignedInState: Bool = false
    
    var spTableView: UITableView {
        return self.tableView
    }
    var spRefreshControl: UIRefreshControl {
        return self.refreshControl!
    }
    var defaultTableViewCellSeparator: UITableViewCellSeparatorStyle = .SingleLine
    
    // UI
    let cellIdentifier = "SPDocumentsTableViewCell"
    
    // Model
    var docList: SPDocList!
    
    var rootFolderPath: String = ""
    var rootFolder: String = ""
    var dirBaseUrl: String = ""
    
    var currentFolder: String = ""
    var currentFolderName: String = ""
    
    var nextFolder: String = ""
    
    var files = [SPFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set back button text for the next view controller
        ViewControllerHelper.setNextVCBackButtonText(self, text: "Back")
        
        // Parse urls and paths
        rootFolderPath = docList.rootDirPath.stringByRemovingPercentEncoding!
        
        let lastSlashIndex = rootFolderPath.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch)!.startIndex
        rootFolder = rootFolderPath.substringFromIndex(lastSlashIndex.successor())
        self.navigationItem.title = rootFolder
        
        dirBaseUrl = SPUtils.getBaseUrl(docList.url)
        
        // Prepare for initial request
        currentFolder = rootFolderPath
        nextFolder = currentFolder
        
        handleViewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        handleViewWillAppear()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return getSectionCount()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDataCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SPDocumentsTableViewCell
        configureCell(cell, row: indexPath.row)
        return cell
    }
    
    private func configureCell(cell: SPDocumentsTableViewCell, row: Int) {
        // Fetches the appropriate announcement for the data source layout
        let file = files[row]
        
        cell.titleLabel.text = file.title
        cell.subtitleLabel.text = file.lastModified
        if file.isFolder {
            cell.iconView.image = UIImage(named: "File-Folder")
        } else {
            cell.iconView.image = UIImage(named: SPUtils.getFileIconName(file.soapUrl))
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let file = files[indexPath.row]
        if file.isFolder {
            let nextFolderPath = file.soapUrl
            let nextFolderDocList = SPDocList(name: docList.name, url: docList.url, guid: docList.guid, template: docList.template, rootDirPath: nextFolderPath)
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("spDocumentsVC") as! SPDocumentsViewController
            vc.docList = nextFolderDocList
            self.showViewController(vc, sender: self)
        } else {
            SPUtils.downloadAndDisplayFile(file, docControllerDelegate: self)
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func signInClicked(sender: AnyObject) {
        showSignInPage()
    }
    
    typealias CacheType = GetListItemsResponseData
    typealias ResponseType = GetListItemsResponse
    typealias ListDataType = [[String: String]]
    
    func loadData(networkOnly: Bool) {
        SharePointRequestManager.sharedInstance.getDocumentsList(
            true, // Always do network only requests, since we're never using the cache
            requiresAuth: true,
            requestId: nil, // Disables the cache
            listsUrl: docList.url,
            listGUID: docList.guid,
            folder: nextFolder,
            delegate: self)
    }
    
    func refresh(sender: AnyObject) {
        loadData(true)
    }
    
    func getDataCount() -> Int {
        return files.count
    }
    
    func extractLastUpdated(cachedData: CacheType) -> NSDate {
        return cachedData.timestamp
    }
    
    func extractListDataFromCache(cachedData: CacheType) -> ListDataType {
        return cachedData.rows
    }
    
    func extractListDataFromResponse(networkData: ResponseType) -> ListDataType {
        return networkData.rows
    }
    
    func clearListData() {
        files.removeAll()
    }
    
    func parseListData(listData: ListDataType) {
        for row in listData {
            let title = row[ATTR_TITLE]!
            let soapUrl = row[ATTR_FILE]!
            let fsObjType = row[ATTR_FS_OBJ_TYPE]!
            let modified = row[ATTR_MODIFIED]!
            
            // soapUrl
            let soapUrlHashtagIndex = soapUrl.rangeOfString("#")!.startIndex
            let fullSoapUrl = "/" + soapUrl.substringFromIndex(soapUrlHashtagIndex.successor())
            
            // isFolder
            let fsObjLastHashtagIndex = fsObjType.rangeOfString("#", options: NSStringCompareOptions.BackwardsSearch)!.startIndex
            let isFolder = Int(fsObjType.substringFromIndex(fsObjLastHashtagIndex.successor())) == 1
            
            // fullEncodedUrl
            let encodedSoapUrl: String = fullSoapUrl.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())!
            let encodedFullUrl: String
            if dirBaseUrl.hasSuffix("/") {
                encodedFullUrl = dirBaseUrl.substringToIndex(dirBaseUrl.endIndex) + encodedSoapUrl
            } else {
                encodedFullUrl = dirBaseUrl + encodedSoapUrl
            }
            
            // Create the SPFile object
            files.append(SPFile(isFolder: isFolder, title: title, encodedFullUrl: encodedFullUrl, soapUrl: fullSoapUrl, lastModified: modified))
        };
    }

}
