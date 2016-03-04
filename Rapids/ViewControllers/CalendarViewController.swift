//
//  CalendarViewController.swift
//  Rapids
//
//  Created by Mac Craig on 2016-02-15.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

import EPCalendarPicker

class CalendarViewController: UIViewController, EPCalendarPickerDelegate {

    
    @IBOutlet weak var txtViewDetail: UITextView!
    @IBOutlet weak var btnShowMeCalendar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTouchShowMeCalendarButton(sender: AnyObject) {
        let calendarPicker = EPCalendarPicker(startYear: 2016, endYear: 2017, multiSelection: true, selectedDates: [])
        calendarPicker.weekdayTintColor = AppDelegate.navColor
        calendarPicker.weekendTintColor = AppDelegate.navColor
        calendarPicker.monthTitleColor = AppDelegate.navColor
        calendarPicker.todayTintColor = AppDelegate.navColor
        calendarPicker.dateSelectionColor = AppDelegate.navColorLight
        calendarPicker.calendarDelegate = self
        calendarPicker.startDate = NSDate()
        calendarPicker.hightlightsToday = true
        calendarPicker.showsTodaysButton = true
        calendarPicker.multiSelectEnabled = false
        calendarPicker.hideDaysFromOtherMonth = false
        calendarPicker.tintColor = UIColor.whiteColor()
        calendarPicker.barTintColor = AppDelegate.navColor
        calendarPicker.dayDisabledTintColor = UIColor.grayColor()
        calendarPicker.title = "Riverside Calendar"
        
        //        calendarPicker.backgroundImage = UIImage(named: "background_image")
        //        calendarPicker.backgroundColor = UIColor.blueColor()
        
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didCancel error : NSError) {
        txtViewDetail.text = "User cancelled selection"
        
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date : NSDate) {
        txtViewDetail.text = "User selected date: \n\(date)"
        
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectMultipleDate dates : [NSDate]) {
        txtViewDetail.text = "User selected dates: \n\(dates)"
    }
    
}