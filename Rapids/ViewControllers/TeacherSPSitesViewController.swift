//
//  TeacherSPSitesViewController.swift
//  Rapids
//
//  Created by Noah on 2016-05-03.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class TeacherSPSitesViewController: UITableViewController, UISearchResultsUpdating, SharePointDataViewer {

    // Protocol requirements
    var errMsgRetrieve = "Unable to retrieve teacher SharePoint sites.\nPull down to refresh."
    var errMsgUpdate = "Unable to update teacher SharePoint sites.\nPlease check your internet connection."
    var errMsgEmpty = "No teacher SharePoint sites"
    var errMsgAuth = "Please sign in to view teacher SharePoint sites"
    
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
    let cellIdentifier = "TeacherSPSiteTableViewCell"
    var searchController: UISearchController!
    var selectedTableIndex: Int = 0
    
    // Model
    var teacherSPSites = [TeacherSPSite]()
    var filteredTeacherSPSites = [TeacherSPSite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TeacherSPSiteTableViewCell
        configureCell(cell, row: indexPath.row)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTableIndex = indexPath.row
        performSegueWithIdentifier("showSPListCollection", sender: self)
    }
    
    private func getModelObjectArray() -> [TeacherSPSite] {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredTeacherSPSites
        } else {
            return teacherSPSites
        }
    }
    
    private func configureCell(cell: TeacherSPSiteTableViewCell, row: Int) {
        // Fetches the appropriate TeacherSPSite for the data source layout
        let teacherSPSite = getModelObjectArray()[row]
        
        cell.teacherLabel.text = teacherSPSite.teacherSalutation + " " + teacherSPSite.teacherLastName
        cell.courseLabel.text = SPUtils.getTeacherSPSitesCourse(teacherSPSite.course)
    }
    
    func signInClicked(sender: AnyObject) {
        showSignInPage()
    }
    
    typealias CacheType = TeacherSPSitesResponse
    typealias ResponseType = TeacherSPSitesResponse
    typealias ListDataType = [TeacherSPSite]
    
    func loadData(networkOnly: Bool) {
        SharePointRequestManager.sharedInstance.getTeacherSPSites(
            networkOnly,
            delegate: self)
    }
    
    func refresh(sender: AnyObject) {
        loadData(true)
    }
    
    func getDataCount() -> Int {
        return getModelObjectArray().count
    }
    
    func extractLastUpdated(cachedData: CacheType) -> NSDate {
        return cachedData.timestamp
    }
    
    func extractListDataFromCache(cachedData: CacheType) -> ListDataType {
        return cachedData.sites
    }
    
    func extractListDataFromResponse(networkData: ResponseType) -> ListDataType {
        return networkData.sites
    }
    
    func clearListData() {
        teacherSPSites.removeAll()
    }
    
    func parseListData(listData: ListDataType) {
        teacherSPSites = listData
        teacherSPSites.sortInPlace { (lhs, rhs) in
            let teacherCompare = lhs.teacherLastName.compare(rhs.teacherLastName)
            if teacherCompare == .OrderedSame {
                return lhs.course.compare(rhs.course) == .OrderedAscending
            } else {
                return teacherCompare == .OrderedAscending
            }
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTeacherSPSites = teacherSPSites.filter { teacherSPSite in
            return
                teacherSPSite.teacherLastName.lowercaseString.hasPrefix(searchText.lowercaseString) ||
                teacherSPSite.course.lowercaseString.hasPrefix(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSPListCollection" {
            let viewController = segue.destinationViewController as! SPListCollectionViewController
            viewController.teacherSPSite = getModelObjectArray()[selectedTableIndex]
        }
    }
    
}
