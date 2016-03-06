//
//  BellScheduleManager.swift
//  Rapids
//
//  Created by Noah on 2016-03-05.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

protocol BellScheduleLoaderDelegate {
    func bellScheduleLoaded(bellSchedule: BSCal)
    func errorLoadingBellSchedule(error: ErrorType)
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
        }
    }
    
    func didReceiveError(error: ErrorType) {
        if let actualDelegate = loaderDelegate {
            actualDelegate.errorLoadingBellSchedule(error)
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
    
    func loadBSCal(loaderDelegate: BellScheduleLoaderDelegate?) {
        // Try to load from storage first and notify delegate
        if let loadedFromStorage = loadFromStorage() {
            if let actualDelegate = loaderDelegate {
                actualDelegate.bellScheduleLoaded(loadedFromStorage)
            }
        }
        
        // Then try to load from the network
        let startYear = SchoolDates.getEarliestSchoolStart().year
        let requestHandler = BellScheduleRequestHandler(loaderDelegate: loaderDelegate)
        let request = GetBellScheduleRequest(startYear: String(startYear), responseDelegate: requestHandler)
        request.sendRequest()
    }
    
}