//
//  SPAnnouncementsViewController.swift
//  Rapids
//
//  Created by Noah on 2016-05-24.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class SPAnnouncementsViewController: UITableViewController, SharePointDataViewer {

    struct SPAnnouncement {
        var title: String
        var body: String
        var modifiedDate: String
    }
    
    let ATTR_TITLE = "ows_Title"
    let ATTR_BODY = "ows_Body"
    let ATTR_MODIFIED = "ows_Modified"
    
    // Protocol requirements
    var errMsgRetrieve = "Unable to retrieve announcements.\nPull down to refresh."
    var errMsgUpdate = "Unable to update announcements.\nPlease check your internet connection."
    var errMsgEmpty = "No announcements"
    var errMsgAuth = "Please sign in to view announcements"
    
    var showPopupError: Bool = false
    var lastUpdated: NSDate?
    var lastSignedInState: Bool = false
    
    var spTableView: UITableView {
        return self.tableView
    }
    var spRefreshControl: UIRefreshControl {
        return self.refreshControl!
    }
    var defaultTableViewCellSeparator: UITableViewCellSeparatorStyle = .None
    
    // UI
    let cellIdentifier = "SPAnnouncementTableViewCell"
    
    // Model
    var annList: SPList!
    var announcements = [SPAnnouncement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = annList.name
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SPAnnouncementTableViewCell
        configureCell(cell, row: indexPath.row)
        return cell
    }
    
    private func configureCell(cell: SPAnnouncementTableViewCell, row: Int) {
        // Fetches the appropriate announcement for the data source layout
        let announcement = announcements[row]
        
        cell.titleLabel.text = announcement.title
        cell.modifiedDateLabel.text = announcement.modifiedDate
        
        let bodyData = announcement.body.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions: [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        
        var decodedBodyString: String = announcement.body
        do {
            let attributedString = try NSAttributedString(data: bodyData, options: attributedOptions, documentAttributes: nil)
            decodedBodyString = attributedString.string
        } catch {
            // Ignore
        }
        
        cell.bodyLabel.text = decodedBodyString
    }
    
    func signInClicked(sender: AnyObject) {
        showSignInPage()
    }
    
    typealias CacheType = GetListItemsResponseData
    typealias ResponseType = GetListItemsResponse
    typealias ListDataType = [[String: String]]
    
    func loadData(networkOnly: Bool) {
        SharePointRequestManager.sharedInstance.getAnnouncementsList(
            networkOnly,
            requiresAuth: true,
            requestId: SPUtils.generateRequestId(annList),
            listsUrl: annList.url,
            listGUID: annList.guid,
            isTasksList: annList.template == SPListTemplate.TASKS,
            delegate: self)
    }
    
    func refresh(sender: AnyObject) {
        loadData(true)
    }
    
    func getDataCount() -> Int {
        return announcements.count
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
        announcements.removeAll()
    }
    
    func parseListData(listData: ListDataType) {
        for row in listData {
            let title = row[ATTR_TITLE]
            let body = row[ATTR_BODY] ?? ""
            let modifiedDate = row[ATTR_MODIFIED]
            let announcement = SPAnnouncement(title: title!, body: body, modifiedDate: modifiedDate!)
            announcements.append(announcement)
        };
    }
}
