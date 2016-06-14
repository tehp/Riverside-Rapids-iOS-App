//
//  BellScheduleManager.swift
//  Rapids
//
//  Created by Noah on 2016-03-05.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

protocol BellScheduleLoaderDelegate {
    func willStartNetworkLoad()
    func bellScheduleLoaded(bellSchedule: BSCal)
    func errorLoadingBellSchedule(error: ErrorType)
    func didFinishNetworkLoad()
}

private class BellScheduleRequestHandler: GetBellScheduleResponseDelegate {
    
    var loaderDelegate: BellScheduleLoaderDelegate?
    
    init(loaderDelegate: BellScheduleLoaderDelegate?) {
        self.loaderDelegate = loaderDelegate
    }
    
    func didReceiveResponse(bellSchedule: BSCal) {
        BellScheduleManager.sharedInstance.saveToStorage(bellSchedule)
        
        if let actualDelegate = loaderDelegate {
            actualDelegate.bellScheduleLoaded(bellSchedule)
            actualDelegate.didFinishNetworkLoad()
        }
    }
    
    func didReceiveError(error: ErrorType) {
        if let actualDelegate = loaderDelegate {
            actualDelegate.errorLoadingBellSchedule(error)
            actualDelegate.didFinishNetworkLoad()
        }
    }
}

class BellScheduleManager {
    
    static let sharedInstance = BellScheduleManager()
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ARCHIVE_URL = DocumentsDirectory.URLByAppendingPathComponent("bsCal")
    
    private func saveToStorage(bellSchedule: BSCal) -> Bool {
        return NSKeyedArchiver.archiveRootObject(bellSchedule, toFile: BellScheduleManager.ARCHIVE_URL.path!)
    }
    
    private func loadFromStorage() -> BSCal? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(BellScheduleManager.ARCHIVE_URL.path!) as? BSCal
    }
    
    func loadBSCal(forceNetwork: Bool, loaderDelegate: BellScheduleLoaderDelegate?) {
        // Try to load from storage first and notify delegate
        if let loadedFromStorage = loadFromStorage() {
            if let actualDelegate = loaderDelegate {
                actualDelegate.bellScheduleLoaded(loadedFromStorage)
                if !forceNetwork {
                    // The BSCal was successfully loaded from storage and forceNetwork is disabled
                    // So we can stop right here
                    return
                }
            }
        }
        
        // Then try to load from the network
        if let actualDelegate = loaderDelegate {
            actualDelegate.willStartNetworkLoad()
        }
        let startYear = SchoolDates.getEarliestSchoolStartComponents().year
        let requestHandler = BellScheduleRequestHandler(loaderDelegate: loaderDelegate)
        let request = GetBellScheduleRequest(startYear: String(startYear), responseDelegate: requestHandler)
        request.sendRequest()
    }
    
    func loadBSCalImmediate() -> BSCal? {
        return loadFromStorage()
    }
    
    func getStandardSchedule(schedule: Int) -> [BSBlock] {
        switch schedule {
        case BSCal.Schedule.ADVISORY:
            return [
                BSBlock(block: BSCal.Block.X,        startH:  7, startM: 45, endH:  8, endM: 55),
                BSBlock(block: BSCal.Block.A,        startH:  9, startM:  0, endH: 10, endM: 10),
                BSBlock(block: BSCal.Block.ADVISORY, startH: 10, startM: 15, endH: 10, endM: 35),
                BSBlock(block: BSCal.Block.B,        startH: 10, startM: 40, endH: 11, endM: 55),
                BSBlock(block: BSCal.Block.LUNCH,    startH: 11, startM: 55, endH: 12, endM: 30),
                BSBlock(block: BSCal.Block.C,        startH: 12, startM: 35, endH: 13, endM: 45),
                BSBlock(block: BSCal.Block.D,        startH: 13, startM: 50, endH: 15, endM:  0)
            ]
            
        case BSCal.Schedule.EXTENDED_ADVISORY:
            return [
                BSBlock(block: BSCal.Block.X,                 startH:  7, startM: 45, endH:  8, endM: 55),
                BSBlock(block: BSCal.Block.A,                 startH:  9, startM:  0, endH: 10, endM:  0),
                BSBlock(block: BSCal.Block.B,                 startH: 10, startM:  5, endH: 11, endM:  5),
                BSBlock(block: BSCal.Block.EXTENDED_ADVISORY, startH: 11, startM: 10, endH: 12, endM: 10),
                BSBlock(block: BSCal.Block.LUNCH,             startH: 12, startM: 10, endH: 12, endM: 50),
                BSBlock(block: BSCal.Block.C,                 startH: 12, startM: 55, endH: 13, endM: 55),
                BSBlock(block: BSCal.Block.D,                 startH: 14, startM:  0, endH: 15, endM:  0)
            ]
            
        case BSCal.Schedule.NORMAL:
            fallthrough
        default:
            return [
                BSBlock(block: BSCal.Block.X,     startH:  7, startM: 40, endH:  8, endM: 55),
                BSBlock(block: BSCal.Block.A,     startH:  9, startM:  0, endH: 10, endM: 20),
                BSBlock(block: BSCal.Block.B,     startH: 10, startM: 25, endH: 11, endM: 45),
                BSBlock(block: BSCal.Block.LUNCH, startH: 11, startM: 45, endH: 12, endM: 20),
                BSBlock(block: BSCal.Block.C,     startH: 12, startM: 25, endH: 13, endM: 45),
                BSBlock(block: BSCal.Block.D,     startH: 13, startM: 50, endH: 15, endM: 10)
            ]
        }
    }
    
    func getDayType(date: NSDate, inBSCal: BSCal) -> String {
        let calendar = NSCalendar.currentCalendar();
        for day in inBSCal.days {
            if calendar.compareDate(date, toDate: day.date, toUnitGranularity: NSCalendarUnit.Day) == .OrderedSame {
                return day.dayType
            }
        }
        return "day1"
    }
    
    func getScheduleForDate(date: NSDate, inBSCal: BSCal) -> [BSBlock]? {
        let calendar = NSCalendar.currentCalendar();
        for day in inBSCal.days {
            if calendar.compareDate(date, toDate: day.date, toUnitGranularity: NSCalendarUnit.Day) == .OrderedSame {
                let schedule = day.schedule
                if schedule == BSCal.Schedule.CUSTOM {
                    return day.customSchedule
                } else {
                    return getStandardSchedule(schedule)
                }
            }
        }
        return nil
    }
    
}