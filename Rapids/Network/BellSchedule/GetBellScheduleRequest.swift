//
//  GetBellScheduleRequest.swift
//  Rapids
//
//  Created by Noah on 2016-02-22.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

import Alamofire

class GetBellScheduleRequest {
    
    var startYear: String
    var responseDelegate: GetBellScheduleResponseDelegate?
    
    init(startYear: String, responseDelegate: GetBellScheduleResponseDelegate?) {
        self.startYear = startYear
        self.responseDelegate = responseDelegate
    }
    
    func sendRequest() {
        Alamofire.request(.GET, D.BellSchedule.GET_URL, parameters: [D.BellSchedule.GET_URL_PARAM_START_YEAR: startYear])
            .responseJSON { response in
                if let actualDelegate = self.responseDelegate {
                    switch response.result {
                        
                    case .Success(let json):
                        let response = json as! NSDictionary
                        actualDelegate.didReceiveResponse(self.parseResponse(response))
                        
                    case .Failure(let error):
                        actualDelegate.didReceiveError(error)
                        
                    }
                }
            }
    }
    
    func parseResponse(response: NSDictionary) -> BSCal {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let schoolStart = dateFormatter.dateFromString(response["schoolStart"]! as! String)!
        let schoolEnd = dateFormatter.dateFromString(response["schoolEnd"]! as! String)!
        
        var days = [BSDay]()
        
        for day in response["days"]! as! [NSDictionary]
        {
            let date = dateFormatter.dateFromString(day["date"]! as! String)!
            let dayType = day["dayType"]! as! String
            let schedule = day["schedule"]! as! Int
            
            var customSchedule: [BSBlock]?
            let parsedCustomSchedule = day["customSchedule"] as? NSArray
            if let actualCustomSchedule = parsedCustomSchedule {
                customSchedule = [BSBlock]()
                for block in actualCustomSchedule {
                    let blockDict = block as! NSDictionary
                    let blockName = blockDict["block"]! as! Int
                    let startH = blockDict["startH"]! as! Int
                    let startM = blockDict["startM"]! as! Int
                    let endH = blockDict["endH"]! as! Int
                    let endM = blockDict["endM"]! as! Int
                    let theBlock = BSBlock(block: blockName, startH: startH, startM: startM, endH: endH, endM: endM)
                    customSchedule!.append(theBlock)
                }
            }
            
            let theDay = BSDay(date: date, dayType: dayType, schedule: schedule, customSchedule: customSchedule)
            days.append(theDay)
        }
        
        return BSCal(schoolStart: schoolStart, schoolEnd: schoolEnd, days: days)
    }
    
}