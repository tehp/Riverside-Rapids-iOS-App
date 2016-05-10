//
//  AnnouncementsViewControllerV2.swift
//  Rapids
//
//  Created by Programming on 2016-05-05.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation
import UIKit

class AnnouncementsViewController: UITableViewController, SharePointDataViewer {
    
    struct Announcement {
        var title: String
        var category: String
    }
    
    let ATTR_TITLE = "ows_LinkTitle"
    let ATTR_CATEGORIES = "ows_Categories"
    
    let CATEGORY_GENERAL = "General"
    let CATEGORY_STUDENT_ALERT = "Student Alert"
    let CATEGORY_ALTHLETICS = "Athletics"
    let CATEGORY_GRAD = "Grad"
    
    // Protocol requirements
    var showPopupError: Bool = false
    var lastUpdated: NSDate?
    var lastSignedInState: Bool = false
    
    var spTableView: UITableView {
        return self.tableView
    }
    var spRefreshControl: UIRefreshControl {
        return self.refreshControl!
    }
    
    // UI
    let cellIdentifier = "AnnouncementTableViewCell"
    
    // Model
    var announcements = [Announcement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AnnouncementTableViewCell
        configureCell(cell, row: indexPath.row)
        return cell
    }
    
    private func configureCell(cell: AnnouncementTableViewCell, row: Int) {
        // Fetches the appropriate announcement for the data source layout
        let announcement = announcements[row]
        
        cell.nameLabel.text = announcement.title
        switch announcement.category {
        case CATEGORY_ALTHLETICS:
            cell.photoImageView.image = UIImage(named: "Basketball-50")
        case CATEGORY_STUDENT_ALERT:
            cell.photoImageView.image = UIImage(named: "Megaphone-50")
        case CATEGORY_GRAD:
            cell.photoImageView.image = UIImage(named: "Student-50")
        case CATEGORY_GENERAL:
            fallthrough
        default:
            cell.photoImageView.image = UIImage(named: "Info-50")
        }
    }
    
    func signInClicked(sender: AnyObject) {
        showSignInPage()
    }
    
    typealias CacheType = GetListItemsResponseData
    typealias ResponseType = GetListItemsResponse
    typealias ListDataType = [[String: String]]
    
    func loadData(networkOnly: Bool) {
        SharePointRequestManager.sharedInstance.getDailyAnnouncements(
            networkOnly,
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
            let category = row[ATTR_CATEGORIES]
            let announcement = Announcement(title: title!, category: category!)
            announcements.append(announcement)
        };
    }
    
}