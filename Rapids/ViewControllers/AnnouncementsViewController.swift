//
//  AnnouncementsViewController.swift
//  Rapids
//
//  Created by Mac Craig on 2016-02-15.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation
                                                                                                                                                                                                                        
import UIKit

import Alamofire

class AnnouncementsViewController: UITableViewController, SharePointRequestDelegate {
    
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
    
    // UI
    let cellIdentifier = "AnnouncementTableViewCell"
    var showPopupError: Bool = false
    
    // Model
    var announcements = [Announcement]()
    var lastUpdated: NSDate?
    
    // State
    var lastSignedInState: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup TableView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        
        // Setup Pull to Refresh
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Initialize state
        lastSignedInState = CredentialsManager.sharedInstance.signedIn
        
        // Do initial load
        loadData(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let currentSignedInState = CredentialsManager.sharedInstance.signedIn
        if currentSignedInState != lastSignedInState {
            lastSignedInState = currentSignedInState
            loadData(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender: AnyObject) {
        loadData(true)
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view vells are reused and should be dequeued using a cell identifier.
        
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
    
    // MARK: Soap Request / Response
    
    private func loadData(networkOnly: Bool) {
        SharePointRequestManager.sharedInstance.getDailyAnnouncements(
            networkOnly,
            username: CredentialsManager.sharedInstance.username,
            password: CredentialsManager.sharedInstance.password,
            delegate: self)
    }
    
    func updateList(rows: [[String: String]]) {
        // Clear current data
        announcements.removeAll()
        
        // Update data
        for row in rows {
            let title = row[ATTR_TITLE]
            let category = row[ATTR_CATEGORIES]
            let announcement = Announcement(title: title!, category: category!)
            announcements.append(announcement)
        };
        
        // Update table
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.reloadData()
        
        // Update refresh control
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM. d 'at' h:mm a"
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Last updated: \(dateFormatter.stringFromDate(lastUpdated!))")
        
        // Hide error messgae
        self.tableView.backgroundView = nil
    }
    
    typealias CacheType = GetListItemsResponseData
    typealias ResponseType = GetListItemsResponse
    
    func didFailPreConditions(error: Int) {
        // Hide the refreshing indicator
        self.refreshControl?.endRefreshing()
        
        // Handle the error
        if error == SharePointRequestErrors.ERROR_PRE_NOT_SIGNED_IN {
            showAuthError()
        }
    }
    
    func didFindCachedData(cachedData: CacheType) {
        lastUpdated = cachedData.timestamp
        updateList(cachedData.rows)
    }
    
    func willStartNetworkLoad() {
        if let actualRefreshControl = self.refreshControl {
            if !actualRefreshControl.refreshing {
                self.tableView.contentOffset = CGPointMake(0, -actualRefreshControl.frame.size.height)
                actualRefreshControl.beginRefreshing()
            }
        }
    }
    
    func didReceiveNetworkData(networkData: ResponseType) {
        lastUpdated = NSDate()
        updateList(networkData.rows)
    }
    
    func didReceiveNetworkError(error: ErrorType) {
        print(error)
        
        let errMsgRetrieve = "Unable to retrieve announcements.\nPull down to refresh."
        let errMsgUpdate = "Unable to update announcements.\nPlease check your internet connection."
        
        if announcements.count == 0 {
            showErrorMessage(false, errorMessage: errMsgRetrieve)
        } else if showPopupError {
            showErrorMessage(true, errorMessage: errMsgUpdate)
        }
    }
    
    func didFinishNetworkLoad() {
        // Hide the refreshing indicator
        self.refreshControl?.endRefreshing()
        
        // After the first network request we want to show popup errors
        showPopupError = true
    }
    
    func showErrorMessage(popup: Bool, errorMessage: String) {
        if !popup {
            // Create error message label
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = errorMessage
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.numberOfLines = 0
            messageLabel.sizeToFit()
            
            // Hide the table contents
            announcements.removeAll()
            self.tableView.reloadData()
            
            // Display the error message label
            self.tableView.backgroundView = messageLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        } else if showPopupError {
            let alertController = UIAlertController(title: "Network Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: { (alertAction) in
                self.loadData(true)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func showAuthError() {
        showErrorMessage(false, errorMessage: "You must be signed in to use this feature")
    }
}

