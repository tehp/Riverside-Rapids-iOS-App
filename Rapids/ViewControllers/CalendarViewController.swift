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

class CalendarViewController: UIViewController, SharePointRequestDelegate {
    
    let ATTR_TITLE = "ows_LinkTitle"
    let ATTR_CATEGORIES = "ows_Categories"
    
    let CATEGORY_GENERAL = "General"
    let CATEGORY_STUDENT_ALERT = "Student Alert"
    let CATEGORY_ALTHLETICS = "Athletics"
    let CATEGORY_GRAD = "Grad"
    
    // UI
    let cellIdentifier = "CalendarTableViewCell"
    var showPopupError: Bool = false
    
    // Model
    var calendarTable = [CalendarEvent]()
    var lastUpdated: NSDate?
    
  
    // MARK: Table View Data
    
    @IBOutlet weak var calendar: CalendarView!
    
    var date: Moment! {
        didSet {
            print(date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 120.0
        
        date = moment()
        calendar.delegate = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
 
    typealias CacheType = GetListItemsResponseData
    typealias ResponseType = GetListItemsResponse
    
    struct CalendarEvent {
        var title: String
        var category: String
    }
   
    func didFindCachedData(cachedData: CacheType) {

    }
    
    func willStartNetworkLoad() {

    }
    
    func didReceiveNetworkData(networkData: ResponseType) {

    }
    
    func didReceiveNetworkError(error: ErrorType) {
   
    }
    
    func didFinishNetworkLoad() {
        // Hide the refreshing indicator

    }

    

}

extension CalendarViewController: CalendarViewDelegate {
    
    func calendarDidSelectDate(date: Moment) {
        self.date = date
    }
    
    func calendarDidPageToDate(date: Moment) {
        self.date = date
    }
}