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

class AnnouncementsViewController: UITableViewController, SoapResponseDelegate {
    
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
    
    let cellIdentifier = "AnnouncementTableViewCell"
    
    //MARK Properties
    var announcements = [Announcement]()
    
    
    func loadSampleAnnouncments() {
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup TableView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        
        // Set the fields we want to retrieve
        let viewFields = SoapViewFieldsBuilder()
        viewFields
            .fieldRef("LinkTitle")
        
        // Only retrieve announcements that are not expired or have no expiry date
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.stringFromDate(today)
        
        let query = SoapQueryBuilder()
        query
            .orderBy(nil)
                .fieldRef("Categories", attributes: ["Ascending": SoapCamlBuilder.BOOL_TRUE])
                .fieldRef("Created", attributes: ["Ascending": SoapCamlBuilder.BOOL_TRUE])
                .up()
            ._where()
                .or()
                    .isNull()
                    .fieldRef("Expires", attributes: nil)
                    .up()
                .geq()
                    .fieldRef("Expires", attributes: nil)
                    .value("DateTime", value: dateStr, attributes: ["IncludeTimeValue": SoapCamlBuilder.BOOL_FALSE])
        
        // Other parameters for the SOAP request
        let url = "https://my43.sd43.bc.ca/schools/riverside/_vti_bin/lists.asmx"
        let listName = "{6B015937-2798-4C8F-B654-F49E28A71851}"
        let username = "132-ntajwar"
        let password = "steer323"
        
        // Create the request
        let request = GetListItemsRequest(
            url: url,
            username: username,
            password: password,
            listName: listName,
            viewName: nil,
            query: query.complete(),
            viewFields: viewFields.complete(),
            rowLimit: "50",
            queryOptions: nil,
            webID: nil,
            responseDelegate: self)
        
        // Send the request
        request.sendRequest()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: SoapResponseDelegate
    typealias ResponseType = GetListItemsResponse
    func didReceiveResponse(response: GetListItemsResponse) {
        print(response.rows.count)
        for row in response.rows {
            let title = row[ATTR_TITLE]
            let category = row[ATTR_CATEGORIES]
            let announcement = Announcement(title: title!, category: category!)
            announcements.append(announcement)
        };
        self.tableView.reloadData()
    }
    
    func didReceiveError(error: ErrorType) {
        print("SoapResponseError")
    }
}

