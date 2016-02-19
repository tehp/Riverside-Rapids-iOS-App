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

class AnnouncementsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let viewFields = SoapViewFieldsBuilder()
        viewFields
            .fieldRef("LinkTitle")
        
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
            .value("DateTime", value: "2016-02-16", attributes: ["IncludeTimeValue": SoapCamlBuilder.BOOL_FALSE])
        
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
            webID: nil)
        
        request.sendRequest()
        
        let credential = NSURLCredential(user: username, password: password, persistence: .None)
        
        Alamofire.request(.GET, url)
            .authenticate(usingCredential: credential)
            .response(completionHandler: { (request, response, data, error) in print("\(String(response)), \(String(data)), \(String(error))")})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

