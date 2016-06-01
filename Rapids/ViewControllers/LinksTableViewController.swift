//
//  LinksTableViewController.swift
//  Rapids
//
//  Created by Programming 12 on 2016-05-30.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class LinksTableViewController: UITableViewController {

    let linkNames: [String] = ["Riverside Homepage", "Riverside Intranet", "Twitter (@rside43)", "The Eddy", "Gym Schedule", "Principal's Blog"]
    let linkUrls: [String] = ["http://www.sd43.bc.ca/secondary/riverside/Pages/default.aspx", "https://my43.sd43.bc.ca/schools/riverside/Pages/Default.aspx", "https://twitter.com/rside43", "http://www.riversideeddy.ca", "http://www.sd43.bc.ca/secondary/riverside/ProgramsServices/Sports/Pages/default.aspx", "http://aciolfitto.wordpress.com/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let clickedUrl = linkUrls[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: clickedUrl)!)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LinkTableViewCell", forIndexPath: indexPath) as! LinkTableViewCell
        
        let row = indexPath.row
        cell.linkNameLabel.text = linkNames[row]
        cell.linkUrlLabel.text = linkUrls[row]
        
        return cell
    }

}
