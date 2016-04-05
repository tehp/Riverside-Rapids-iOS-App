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
    
    // MARK: Table View Data
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var calendar: CalendarView!
    
    var date: Moment! {
        didSet {
            print(date)
            dateLabel.text = String(date)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date = moment()
        calendar.delegate = self
        
    }
    
    typealias CacheType = GetListItemsResponseData
    typealias ResponseType = GetListItemsResponse
    
    struct CalendarEvent {
        var title: String
        var category: String
    }
    
    // UI
    let cellIdentifier = "AnnouncementTableViewCell"
    var showPopupError: Bool = false
    
    // Model
    var calendarTable = [CalendarEvent]()
    var lastUpdated: NSDate?
    
    func didFindCachedData(cachedData: CacheType) {
        
    }
    func willStartNetworkLoad() {
        
    }
    func didReceiveNetworkData(networkData: ResponseType) {
        
    }
    func didReceiveNetworkError(error: ErrorType) {
        
        let errMsgRetrieve = "Unable to retrieve announcements.\nPull down to refresh."
        let errMsgUpdate = "Unable to update announcements.\nPlease check your internet connection."
        
        if(calendarTable.count == 0) {
            // Create error message label
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = errMsgRetrieve
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.numberOfLines = 0
            messageLabel.sizeToFit()
            
            // Display the error message label
            //self.tableView.backgroundView = messageLabel
            //self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        } else if showPopupError {
            let alertController = UIAlertController(title: "Network Error", message: errMsgUpdate, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: { (alertAction) in
                //self.loadData(true)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }
    func didFinishNetworkLoad() {
        // After the first network request we want to show popup errors
        showPopupError = true
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