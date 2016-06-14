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

class SPCalendarViewController: UIViewController, SharePointRequestDelegate, UITableViewDelegate, UITableViewDataSource, CalendarViewDelegate {

    let ATTR_TITLE = "ows_Title"
    let ATTR_START = "ows_EventDate"
    let ATTR_END = "ows_EndDate"
    let ATTR_LOCATION = "ows_Location"
    let ATTR_DESCRIPTION = "ows_Description"
    let ATTR_ALL_DAY = "ows_fAllDayEvent"
    
    // UI
    let cellIdentifier = "SPCalendarTableViewCell"
    var showPopupError: Bool = false

    @IBOutlet weak var calendar: CalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarTitle: UILabel!
    
    var progressView: UIActivityIndicatorView!
    
    var selectedMoment = moment()

    
    // Model
    var selectedTable = [CalendarEvent]()
    var calendarTable = [CalendarEvent]()
    var lastUpdated: NSDate?
    
    var calList: SPList = SPList(type: SPListType.Calendar, name: "School Calendar", url: D.SharePoint.PUBLIC_LISTS_URL, guid: D.SharePoint.CALENDAR_GUID, template: SPListTemplate.CALENDAR) // default to School Calendar
    var requiresAuth: Bool = false
    
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
        
        self.navigationItem.title = calList.name
    }
        
    override func viewDidAppear(animated: Bool) {
        calendar.delegate = self
        updateSelectedList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: CalendarViewDelegate
    
    func calendarDidSelectDate(date: Moment) {
        selectedMoment = moment(date)
        updateSelectedList()
        print("calendarDidSelectDate - " + date.format("yyyy-MM-dd"))
    
    }
    
    func calendarDidPageToDate(date: Moment) {
        var headline = "error"
        headline = date.format("MMMM yyyy")
        calendarTitle.text = headline
        
        selectedMoment = moment(date)
        updateSelectedList()
        print("calendarDidPageToDate - " + date.format("yyyy-MM-dd"))
    }
    
    
    // MARK: SharePointRequestDelegate
    
    typealias CacheType = GetListItemsResponseData
    typealias ResponseType = GetListItemsResponse
    
    struct CalendarEvent {
        var title: String
        var start: String
        var end: String
        var allDay: Bool
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
        SharePointRequestManager.sharedInstance.getCalendarList(
            networkOnly,
            requiresAuth: requiresAuth,
            requestId: SPUtils.generateRequestId(calList),
            url: calList.url,
            listGUID: calList.guid,
            delegate: self)
    }
    
    func updateList(rows: [[String: String]]) {
        calendarTable.removeAll()
        for row in rows {
            var title: String = row[ATTR_TITLE]!
            let start: String = row[ATTR_START]!
            let end: String = row[ATTR_END]!
            let allDay: Bool = row[ATTR_ALL_DAY]! == "1"
            
            do {
                let regex = try NSRegularExpression(pattern: "([dD][aA][yY] *[12])", options: NSRegularExpressionOptions.CaseInsensitive)
                if regex.matchesInString(title, options: .Anchored, range: NSRange(location: 0, length: title.utf16.count)).count == 1 {
                    continue
                }
            } catch {
                // Ignore
            }
            title = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            let event = CalendarEvent(title: title, start: start, end: end, allDay: allDay)
            calendarTable.append(event)
        }
    }
    
    func updateSelectedList() {
        selectedTable.removeAll()
        for event in calendarTable {
            let eventStartMoment = moment(String(event.start.characters.prefix(10)))!
            let eventEndMoment = moment(String(event.end.characters.prefix(10)))!
            
            if compareDates(selectedMoment, date2: eventStartMoment) >= 0 && compareDates(selectedMoment, date2: eventEndMoment) <= 0 {
                selectedTable.append(event)
            }
        }
    
        // Update table
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.tableView.reloadData()
        }
    }
    
    func compareDates(date1: Moment, date2: Moment) -> Int {
        if date1.year > date2.year {
            return 1
        } else if date1.year < date2.year {
            return -1
        } else {
            if date1.month > date2.month {
                return 1
            } else if date1.month < date2.month {
                return -1
            } else {
                if date1.day > date2.day {
                    return 1
                } else if date1.day < date2.day {
                    return -1
                } else {
                    return 0
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTable.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SPCalendarTableViewCell
        
        let event = selectedTable[indexPath.row]
        cell.eventLabel.text = event.title
        
        if event.allDay {
            cell.timeLabel.text = "All Day"
        } else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let startDate = dateFormatter.dateFromString(event.start)!
            let endDate = dateFormatter.dateFromString(event.end)!
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            let startTime = timeFormatter.stringFromDate(startDate)
            let endTime = timeFormatter.stringFromDate(endDate)
            
            let timeString = startTime + " - " + endTime
            cell.timeLabel.text = timeString
        }

        return cell
    }
}