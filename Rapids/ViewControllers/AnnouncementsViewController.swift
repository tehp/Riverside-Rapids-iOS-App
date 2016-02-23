//
//  AnnouncementsViewController.swift
//  Rapids
//
//  Created by Mac Craig on 2016-02-15.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

import UIKit

import Alamofire

class AnnouncementsViewController: UITableViewController, SoapResponseDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        /* start EXAMPLE SOAP REQUEST */
        let viewFields = SoapViewFieldsBuilder()
        viewFields
            .fieldRef("LinkTitle")
        
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.stringFromDate(today)
        
        let query = SoapQueryBuilder()
        query
            .orderBy(nil)
                .fieldRef("Categories", attributes: ["Ascending": SoapCamlBuilder.BOOL_TRUE])
                .fieldRef("Created", attributes: ["Ascending": SoapCamlBuilder.BOOL_TRUE])
                .up()
            ._where()
                .or()
                    .isNull()
                    .fieldRef("Expires", attributes: nil)
                    .up()
                .geq()
                    .fieldRef("Expires", attributes: nil)
                    .value("DateTime", value: dateStr, attributes: ["IncludeTimeValue": SoapCamlBuilder.BOOL_FALSE])
        
        let url = "https://my43.sd43.bc.ca/schools/riverside/_vti_bin/lists.asmx"
        let listName = "{6B015937-2798-4C8F-B654-F49E28A71851}"
        let username = "132-ntajwar"
        let password = "steer323"
        
        let request = GetListItemsRequest(
            url: url,
            username: username,
            password: password,
            listName: listName,
            viewName: nil,
            query: query.complete(),
            viewFields: viewFields.complete(),
            rowLimit: "50",
            queryOptions: nil,
            webID: nil,
            responseDelegate: self)
        
        request.sendRequest()
        /* end ExampleSoapRequest */
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: SoapResponseDelegate
    typealias ResponseType = GetListItemsResponse
    func didReceiveResponse(response: GetListItemsResponse) {
        print(response.rows.count)
        for row in response.rows {
            print(row["ows_LinkTitle"]!)
        }
    }
    
    func didReceiveError(error: ErrorType) {
        print("SoapResponseError")
    }
}

