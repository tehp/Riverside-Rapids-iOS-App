//
//  CalendarViewController.swift
//  Rapids
//
//  Created by Mac Craig on 2016-02-15.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit
import CalendarView
import SwiftMoment
import Foundation

    class CalendarViewController: UIViewController, SharePointRequestDelegate, UITableViewDelegate, UITableViewDataSource, CalendarViewDelegate {

    let ATTR_TITLE = "ows_Title"
    let ATTR_START = "ows_EventDate"
    let ATTR_END = "ows_EndDate"
    let ATTR_LOCATION = "ows_Location"
    let ATTR_DESCRIPTION = "ows_Description"
        
    var selectedMoment = moment()
    
    // UI
    let cellIdentifier = "CalendarTableViewCell"
    var showPopupError: Bool = false

    
    // Model
    var selectedTable = [CalendarEvent]()
    var calendarTable = [CalendarEvent]()
    var lastUpdated: NSDate?
    

    
  
    // MARK: Table View Data
    
    @IBOutlet weak var calendar: CalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarTitle: UILabel!
    
    var progressView: UIActivityIndicatorView!
    
    override func viewDidAppear(animated: Bool) {
        calendar.delegate = self
        updateSelectedList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.dataSource = self
        tableView.delegate = self
        
        let headline = moment().format("MMMM yyyy")
        calendarTitle.text = headline
        
        loadData(false)
        selectedMoment = moment()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: CalendarViewDelegate
    
    func calendarDidSelectDate(date: Moment) {
        selectedMoment = moment(date)
        updateSelectedList()
    
    }
    
    func calendarDidPageToDate(date: Moment) {
        var headline = "error"
        headline = date.format("MMMM yyyy")
        calendarTitle.text = headline
        
        selectedMoment = moment(date)
        updateSelectedList()
    }
    
    
    // MARK: SharePointRequestDelegate
    
    typealias CacheType = GetListItemsResponseData
    typealias ResponseType = GetListItemsResponse
    
    struct CalendarEvent {
        var title: String
        var start: String
        var end: String
    }
   
    func didFailPreConditions(error: Int) {
        
    }
    
    func didFindCachedData(cachedData: CacheType) {
        updateList(cachedData.rows)
    }
    
    func willStartNetworkLoad() {
        progressView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        progressView.hidesWhenStopped = true
        progressView.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressView)
    }
    
    func didReceiveNetworkData(networkData: ResponseType) {
        updateList(networkData.rows)
    }
    
    func didReceiveNetworkError(error: ErrorType) {
        progressView.stopAnimating()
    }
    
    func didFinishNetworkLoad() {
        // Hide the refreshing indicator
        progressView.stopAnimating()
    }
    
    // MARK: Displaying Data
    
    private func loadData(networkOnly: Bool) {
        SharePointRequestManager.sharedInstance.getSchoolCalendar(
            networkOnly,
            delegate: self)
    }

  
    
    func updateList(rows: [[String: String]]) {
        calendarTable.removeAll()
        for row in rows {
            var title = row[ATTR_TITLE]!
            let start = row[ATTR_START]!
            let end = row[ATTR_END]!
            
            do {
                let regex = try NSRegularExpression(pattern: "([dD][aA][yY] *[12])", options: NSRegularExpressionOptions.CaseInsensitive)
                if regex.matchesInString(title, options: .Anchored, range: NSRange(location: 0, length: title.utf16.count)).count == 1 {
                    continue
                }
            } catch {
                // Ignore
            }
            
            title = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let event = CalendarEvent(title: title, start: start, end: end)
            calendarTable.append(event)
            
            
        }
    }
    
    func updateSelectedList() {
        selectedTable.removeAll()
        for event in calendarTable {
            let eventStartMoment = moment(String(event.start.characters.prefix(10)))!
            let eventEndMoment = moment(String(event.end.characters.prefix(10)))!
            
            if selectedMoment >= eventStartMoment && selectedMoment <= eventEndMoment {
                selectedTable.append(event)
            }
        }
    
        // Update table
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.tableView.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTable.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CalendarTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CalendarTableViewCell
        
        let event = selectedTable[indexPath.row]
        cell.eventLabel.text = event.title

        return cell
    }
}