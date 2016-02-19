//
//  SoapResponseHandler.swift
//  Rapids
//
//  Created by Noah on 2016-02-20.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

protocol SoapResponseDelegate: class {
    typealias ResponseType: SoapResponse
    func didReceiveResponse(response: ResponseType)
    func didReceiveError(error: ErrorType)
}