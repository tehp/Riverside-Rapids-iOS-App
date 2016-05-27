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

var selectedDate = "selectedDate"

class CalendarViewController: UIViewController, SharePointRequestDelegate, UITableViewDelegate, UITableViewDataSource, CalendarViewDelegate {
    
    func calendarDidSelectDate(date: Moment) {
        selectedDate = date.format("yyyy-MM-dd")
        updateSelectedList()
    }
    
    func calendarDidPageToDate(date: Moment) {
        var headline = "error"
        headline = date.format("MMMM yyyy")
        calendarTitle.text = headline
        updateSelectedList()
    }

    
    let ATTR_TITLE = "ows_Title"
    let ATTR_START = "ows_EventDate"
    let ATTR_END = "ows_EndDate"
    let ATTR_LOCATION = "ows_Location"
    let ATTR_DESCRIPTION = "ows_Description"
    
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
    
    var date: Moment! {
        didSet {
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        
        tableView.dataSource = self
        tableView.delegate = self
    
        calendar.delegate = self
        
        print("viewDidAppear Called")
    }
    
    override func viewDidLoad() {
        loadData(false)
        let now = moment()
        let nowString = String(now)
        let nowCut = String(nowString.characters.prefix(10))
        selectedDate = nowCut
        updateSelectedList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
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

    }
    
    func didReceiveNetworkData(networkData: ResponseType) {
        //updateList(networkData.rows)
    }
    
    func didReceiveNetworkError(error: ErrorType) {
   
    }
    
    func didFinishNetworkLoad() {
        // Hide the refreshing indicator

    }
    
    
    // MARK: Soap Requests
    
    private func loadData(networkOnly: Bool) {
        SharePointRequestManager.sharedInstance.getSchoolCalendar(
            networkOnly,
            delegate: self)
    }
    
    func updateList(rows: [[String: String]]) {
        for row in rows {
            let title = row[ATTR_TITLE]
            let start = row[ATTR_START]
            let end = row[ATTR_END]
            
            let event = CalendarEvent(title: title!, start: start!, end: end!)
            calendarTable.append(event)
            
        }
    }
    
    func updateSelectedList() {
        selectedTable.removeAll()
        for event in calendarTable {
            let listOfEventDates = event.start
            let cutDate = String(listOfEventDates.characters.prefix(10))
            if cutDate == selectedDate {
            selectedTable.append(event)
            }
        }
    
        // Update table
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.reloadData()
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

