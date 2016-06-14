//
//  SPListCollectionViewController.swift
//  Rapids
//
//  Created by Noah on 2016-05-11.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class SPListCollectionViewController: UITableViewController, SharePointDataViewer {
    
    let ATTR_ID = "ID"
    let ATTR_TITLE = "Title"
    let ATTR_WEB_FULL_URL = "WebFullUrl"
    let ATTR_DEFAULT_VIEW_URL = "DefaultViewUrl"
    let ATTR_BASE_TYPE = "BaseType"
    let ATTR_SERVER_TEMPLATE = "ServerTemplate"
    
    // Protocol requirements
    var errMsgRetrieve = "Unable to retrieve lists.\nPull down to refresh."
    var errMsgUpdate = "Unable to update lists.\nPlease check your internet connection."
    var errMsgEmpty = "No SharePoint lists"
    var errMsgAuth = "Please sign in to view SharePoint lists"
    
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
    let cellIdentifier = "SPListTableViewCell"
    var clearOnAppear = false
    
    // Model
    var teacherSPSite: TeacherSPSite!
    var listsUrl: String = ""
    var lists = [SPList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listsUrl = SPUtils.getListsUrl(teacherSPSite.websiteUrl)
        self.title = teacherSPSite.teacherLastName + " - " + SPUtils.getTeacherSPSitesCourse(teacherSPSite.course)
        
        // Set back button text for the next view controller
        ViewControllerHelper.setNextVCBackButtonText(self, text: "Back")
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SPListTableViewCell
        configureCell(cell, row: indexPath.row)
        return cell
    }
    
    private func configureCell(cell: SPListTableViewCell, row: Int) {
        // Fetches the appropriate announcement for the data source layout
        let list = lists[row]
        
        cell.nameLabel.text = list.name
        switch list.type {
        case SPListType.Announcements:
            cell.iconView.image = UIImage(named: "Announcement")
        case SPListType.Calendar:
            cell.iconView.image = UIImage(named: "Calendar")
        case SPListType.Documents:
            cell.iconView.image = UIImage(named: "Documents")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let list = lists[indexPath.row]
        switch list.type {
        case .Announcements:
            let storyboard = UIStoryboard(name: "SPAnnouncements", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("spAnnouncementsVC") as! SPAnnouncementsViewController
            vc.annList = list
            self.showViewController(vc, sender: self)
            break
        case .Calendar:
            let storyboard = UIStoryboard(name: "SPCalendar", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("spCalendarVC") as! SPCalendarViewController
            vc.calList = list
            vc.requiresAuth = true
            self.showViewController(vc, sender: self)
            break
        case .Documents:
            let storyboard = UIStoryboard(name: "SPDocuments", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("spDocumentsVC") as! SPDocumentsViewController
            vc.docList = list as! SPDocList
            self.showViewController(vc, sender: self)
            break
        }

    }
    
    func signInClicked(sender: AnyObject) {
        showSignInPage()
    }
    
    typealias CacheType = GetListCollectionResponseData
    typealias ResponseType = GetListCollectionResponse
    typealias ListDataType = [[String: String]]
    
    private func generateRequestId() -> String {
        return "listCollection_" + String(teacherSPSite.id)
    }
    
    func loadData(networkOnly: Bool) {
        SharePointRequestManager.sharedInstance.getSPListCollection(
            networkOnly,
            requiresAuth: true,
            requestId: generateRequestId(),
            listsUrl: listsUrl,
            delegate: self)
    }
    
    func refresh(sender: AnyObject) {
        loadData(true)
    }
    
    func getDataCount() -> Int {
        return lists.count
    }
    
    func extractLastUpdated(cachedData: CacheType) -> NSDate {
        return cachedData.timestamp
    }
    
    func extractListDataFromCache(cachedData: CacheType) -> ListDataType {
        return cachedData.lists
    }
    
    func extractListDataFromResponse(networkData: ResponseType) -> ListDataType {
        return networkData.lists
    }
    
    func clearListData() {
        lists.removeAll()
    }
    
    func parseListData(listData: ListDataType) {
        for row in listData {
            let id = row[ATTR_ID]!
            let title = row[ATTR_TITLE]!
            let webFullUrl = row[ATTR_WEB_FULL_URL]!
            let defaultViewUrl = row[ATTR_DEFAULT_VIEW_URL]!
            
            let baseType = Int(row[ATTR_BASE_TYPE]!)!
            let serverTemplate = Int(row[ATTR_SERVER_TEMPLATE]!)!
            
            if baseType == 1 {
                // Document Library
                if serverTemplate == SPListTemplate.DOCUMENTS {
                    // Documents only (no pictures)
                    if !defaultViewUrl.isEmpty {
                        let slashBeforeTitleIndex = webFullUrl.characters.count
                        let startIndex = defaultViewUrl.startIndex.advancedBy(slashBeforeTitleIndex)
                        let searchStartIndex = defaultViewUrl.startIndex.advancedBy(slashBeforeTitleIndex + 1)
                        let searchEndIndex = defaultViewUrl.endIndex.predecessor()
                        let endIndex = defaultViewUrl.rangeOfString("/", range: searchStartIndex...searchEndIndex)!.startIndex
                        
                        var rootDirPath = webFullUrl + (defaultViewUrl[startIndex...endIndex.predecessor()])
                        rootDirPath = rootDirPath.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                        
                        lists.append(SPDocList(name: title, url: listsUrl, guid: id, template: serverTemplate, rootDirPath: rootDirPath))
                    }
                }
            } else if baseType == 0 {
                if serverTemplate == SPListTemplate.CALENDAR {
                    lists.append(SPList(type: SPListType.Calendar, name: title, url: listsUrl, guid: id, template: serverTemplate))
                } else if serverTemplate == SPListTemplate.ANNOUNCEMENTS || serverTemplate == SPListTemplate.TASKS {
                    lists.append(SPList(type: SPListType.Announcements, name: title, url: listsUrl, guid: id, template: serverTemplate))
                }
            }
        }
        
        lists.sortInPlace { (lhs, rhs) in
            if lhs.type.rawValue == rhs.type.rawValue {
                return lhs.name.compare(rhs.name) == .OrderedAscending
            } else {
                return lhs.type.rawValue < rhs.type.rawValue
            }
        }
    }

}
