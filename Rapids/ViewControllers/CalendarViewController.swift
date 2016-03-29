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

class CalendarViewController: UIViewController {
    
    
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

    
}

extension CalendarViewController: CalendarViewDelegate {
    
    func calendarDidSelectDate(date: Moment) {
        self.date = date
    }
    
    func calendarDidPageToDate(date: Moment) {
        self.date = date
    }
}

