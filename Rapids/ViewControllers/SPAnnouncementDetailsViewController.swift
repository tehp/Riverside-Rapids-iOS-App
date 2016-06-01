//
//  SPAnnouncementDetailsViewController.swift
//  Rapids
//
//  Created by Programming on 2016-06-01.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class SPAnnouncementDetailsViewController: UIViewController {
    
    let ATTR_TITLE = "ows_Title"
    let ATTR_BODY = "ows_Body"
    let ATTR_ATTACHMENTS = "ows_Attachments"
    
    var announcement: [String: String]!
    var listUrl: String!
    var baseUrl: String!
    
    var attachmentStrings: [String]!
    var attachmentUrls: [String]!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let announcementTitle = announcement[ATTR_TITLE]!
        titleLabel.text = announcementTitle
        
        if let rawBody = announcement[ATTR_BODY] {
            bodyWebView.loadHTMLString(rawBody, baseURL: NSURL(string: baseUrl)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
