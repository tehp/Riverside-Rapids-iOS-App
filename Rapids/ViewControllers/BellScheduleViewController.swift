//
//  BellScheduleViewController.swift
//  Rapids
//
//  Created by Mac Craig on 2016-02-15.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

import UIKit

class BellScheduleViewController: UIViewController, BellScheduleLoaderDelegate, UITableViewDelegate, UITableViewDataSource{
    
    struct Block {
        var blockName: String
        var startTime: String
        var endTime: String
    }

    var blocks = [Block]()
    
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var progressView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Display today's date
        let today = NSDate()
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        let todayString = dateFormatter.stringFromDate(today)
        dateLabel.text = todayString
        
        dateFormatter.dateFormat = "EEE."
        let dayOfWeekString = dateFormatter.stringFromDate(today)
        dayOfWeekLabel.text = dayOfWeekString
        
        // Load updated bell schedule
        progressView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        progressView.hidesWhenStopped = true
        
        BellScheduleManager.sharedInstance.loadBSCal(true, loaderDelegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBlockName(block: BSBlock) -> String {
        var blockName = ""
        
        switch block.block {
        case BSCal.Block.X:
            blockName = "Block X"
        case BSCal.Block.A:
            blockName = "Block A"
        case BSCal.Block.B:
            blockName = "Block B"
        case BSCal.Block.ADVISORY:
            blockName = "RAP"
        case BSCal.Block.LUNCH:
            blockName = "Lunch"
        case BSCal.Block.C:
            blockName = "Block C"
        case BSCal.Block.D:
            blockName = "Block D"
        case BSCal.Block.EXTENDED_ADVISORY:
            blockName = "Extended RAP"
        default:
            blockName = ""
        }
        
        return blockName;
    }
    
    func formatTimeString(hours: Int, minutes: Int) -> String {
        var timeString = ""
        
        if hours > 12 {
            timeString = String(hours - 12)
        } else {
            timeString = String(hours)
        }
        
        timeString += ":"
        
        if minutes < 10 {
            timeString += "0" + String(minutes)
        } else {
            timeString += String(minutes)
        }
        
        return timeString
    }
    
    func willStartNetworkLoad() {
        progressView.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressView)
    }
    
    func bellScheduleLoaded(bellSchedule: BSCal) {
        blocks.removeAll()
        
        let today = NSDate()
        
        let dayType = BellScheduleManager.sharedInstance.getDayType(today, inBSCal: bellSchedule)
        switch dayType {
        case BSCal.DayType.DAY_2:
            dayLabel.text = "Day 2"
        case BSCal.DayType.DAY_1:
            fallthrough
        default:
            dayLabel.text = "Day 1"
        }
        
        let todayBlocks = BellScheduleManager.sharedInstance.getScheduleForDate(today, inBSCal: bellSchedule)
        if let actualTodayBlocks = todayBlocks {
            for block in actualTodayBlocks {
                let blockName = getBlockName(block)
                let startTime = formatTimeString(block.startH, minutes: block.startM)
                let endTime = formatTimeString(block.endH, minutes: block.endM)
                blocks.append(Block(blockName: blockName, startTime: startTime, endTime: endTime))
            }
        }
        
        tableView.reloadData()
    }
    
    func errorLoadingBellSchedule(error: ErrorType) {
        progressView.stopAnimating()
    }
    
    func didFinishNetworkLoad() {
        progressView.stopAnimating()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blocks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "BlockTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BlockTableViewCell
        
        let block = blocks[indexPath.row]
        cell.blockLabel.text = block.blockName
        cell.startLabel.text = block.startTime
        cell.endLabel.text = block.endTime
        
        return cell
    }
}