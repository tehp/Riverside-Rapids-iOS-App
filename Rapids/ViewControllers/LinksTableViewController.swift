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
    let linkUrls: [String] = ["http://www.sd43.bc.ca/secondary/riverside/Pages"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LinkTableViewCell", forIndexPath: indexPath) as! LinkTableViewCell
        
        return cell
    }

}
