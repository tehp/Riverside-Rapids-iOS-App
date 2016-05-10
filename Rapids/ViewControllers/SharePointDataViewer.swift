//
//  SharePointTableViewController.swift
//  Rapids
//
//  Created by Noah on 2016-05-03.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

protocol SharePointDataViewer: class, SharePointRequestDelegate {
    
    typealias CacheType
    typealias ResponseType
    typealias ListDataType
    
    var showPopupError: Bool {get set}
    var lastUpdated: NSDate? {get set}
    var lastSignedInState: Bool {get set}
    
    var spTableView: UITableView {get}
    var spRefreshControl: UIRefreshControl {get}
    
    func handleViewDidLoad()
    func handleViewWillAppear()
    func getSectionCount() -> Int
    
    func getDataCount() -> Int
    func extractLastUpdated(cachedData: CacheType) -> NSDate
    func extractListDataFromCache(cachedData: CacheType) -> ListDataType
    func extractListDataFromResponse(networkData: ResponseType) -> ListDataType
    func clearListData()
    func parseListData(listData: ListDataType)
    
    func refresh(sender: AnyObject)
    func loadData(networkOnly: Bool)
    func showErrorMessage(popup: Bool, errorMessage: String)
    func showAuthError()
    func signInClicked(sender: AnyObject)
    func showSignInPage()
}

extension SharePointDataViewer where Self: UIViewController {
    
    // MARK: - Lifecycle callbacks
    
    func handleViewDidLoad() {
        // Setup TableView
        spTableView.rowHeight = UITableViewAutomaticDimension
        spTableView.estimatedRowHeight = 120.0
        
        // Setup Pull to Refresh
        spRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Initialize state
        lastSignedInState = CredentialsManager.sharedInstance.signedIn
        
        // Do initial load
        loadData(false)
    }
    
    func handleViewWillAppear() {
        // If the signed in state changed we need to reload the data
        let currentSignedInState = CredentialsManager.sharedInstance.signedIn
        if currentSignedInState != lastSignedInState {
            lastSignedInState = currentSignedInState
            loadData(true)
        }
    }
    
    // MARK: - Table view data source
    
    func getSectionCount() -> Int {
        return 1
    }
    
    
    // MARK: - Network methods
    
    func didFailPreConditions(error: Int) {
        // Hide the refreshing indicator
        spRefreshControl.endRefreshing()
        
        // Handle the error
        if error == SharePointRequestErrors.ERROR_PRE_NOT_SIGNED_IN {
            showAuthError()
        }
    }
    
    func didFindCachedData(cachedData: CacheType) {
        lastUpdated = extractLastUpdated(cachedData)
        updateList(extractListDataFromCache(cachedData))
    }
    
    func willStartNetworkLoad() {
        if !spRefreshControl.refreshing {
            spTableView.contentOffset = CGPointMake(0, -spRefreshControl.frame.size.height)
            spRefreshControl.beginRefreshing()
        }
    }
    
    func didReceiveNetworkData(networkData: ResponseType) {
        lastUpdated = NSDate()
        updateList(extractListDataFromResponse(networkData))
    }
    
    func didReceiveNetworkError(error: ErrorType) {
        print(error)
        
        let errMsgRetrieve = "Unable to retrieve announcements.\nPull down to refresh."
        let errMsgUpdate = "Unable to update announcements.\nPlease check your internet connection."
        
        if getDataCount() == 0 {
            showErrorMessage(false, errorMessage: errMsgRetrieve)
        } else if showPopupError {
            showErrorMessage(true, errorMessage: errMsgUpdate)
        }
    }
    
    func didFinishNetworkLoad() {
        // Hide the refreshing indicator
        spRefreshControl.endRefreshing()
        
        // After the first network request we want to show popup errors
        showPopupError = true
    }
    
    
    // MARK: - Displaying data
    
    func updateList(listData: ListDataType) {
        // Clear current data
        clearListData()
        
        // Update data
        parseListData(listData)
        
        // Update table
        spTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        spTableView.reloadData()
        
        // Update refresh control
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM. d 'at' h:mm a"
        spRefreshControl.attributedTitle = NSAttributedString(string: "Last updated: \(dateFormatter.stringFromDate(lastUpdated!))")
        
        // Hide error messgae
        spTableView.backgroundView = nil
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
            clearListData()
            spTableView.reloadData()
            
            // Display the error message label
            spTableView.backgroundView = messageLabel
            spTableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
        // Create a view to hold our error message/button
        let container = UIView()
        
        // Create the sign in button
        let button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(100, 100, 100, 50)
        button.tintColor = UIColor.whiteColor()
        button.backgroundColor = AppDelegate.navColor
        button.setTitle("Sign In", forState: UIControlState.Normal)
        button.addTarget(self, action: "signInClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        container.addSubview(button)
        
        // Create the error message label
        let label = UILabel(frame: CGRectMake(0, 0, 400, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Please sign in to view announcements"
        container.addSubview(label)
        
        // Center everything
        let centerButtonOnY = self.view.frame.height / 2
        let centerButtonOnX = self.view.frame.width / 2
        
        button.center = CGPointMake(centerButtonOnX,centerButtonOnY);
        label.center = CGPointMake(centerButtonOnX,centerButtonOnY - 69)
        
        // Hide the table contents
        clearListData()
        spTableView.reloadData()
        
        // Display the container
        spTableView.backgroundView = container
        spTableView.separatorStyle = .None
    }
    
    func showSignInPage() {
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("signInNavVC")
        self.presentViewController(vc, animated: true, completion: nil)
    }

}