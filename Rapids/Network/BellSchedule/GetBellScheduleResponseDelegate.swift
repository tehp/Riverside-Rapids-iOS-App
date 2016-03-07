//
//  GetBellScheduleResponseDelegate.swift
//  Rapids
//
//  Created by Noah on 2016-03-05.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

protocol GetBellScheduleResponseDelegate {
    func didReceiveResponse(bellSchedule: BSCal)
    func didReceiveError(error: ErrorType)
}