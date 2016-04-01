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

public var selectedDayOnPaged: Int? = nil

class CalendarViewController: UIViewController, SharePointRequestDelegate {
    
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
    
    func didFindCachedData(cachedData: CacheType) {
        
    }
    func willStartNetworkLoad() {
        
    }
    func didReceiveNetworkData(networkData: ResponseType) {
        
    }
    func didReceiveNetworkError(error: ErrorType) {
        
    }
    func didFinishNetworkLoad() {
        
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