//
//  SPAnnouncementDetailsViewController.swift
//  Rapids
//
//  Created by Programming on 2016-06-01.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class SPAnnouncementDetailsViewController: UIViewController, UIWebViewDelegate, UIDocumentInteractionControllerDelegate {
    
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
        
        bodyWebView.delegate = self
        
        if let rawBody = announcement[ATTR_BODY] {
            bodyWebView.loadHTMLString(rawBody, baseURL: NSURL(string: baseUrl)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDownloadOptions(url: NSURL) {
        let optionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let downloadAction = UIAlertAction(title: "Download", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            SPUtils.downloadAndDisplayFile(url, docControllerDelegate: self)
        })
        let openLinkAction = UIAlertAction(title: "Open Link in Browser", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            UIApplication.sharedApplication().openURL(url)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
            // Do nothing
        })
        
        optionsMenu.addAction(downloadAction)
        optionsMenu.addAction(openLinkAction)
        optionsMenu.addAction(cancelAction)
        
        self.presentViewController(optionsMenu, animated: true, completion: nil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .LinkClicked:
            // Open links in Safari
            showDownloadOptions(request.URL!)
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

}
