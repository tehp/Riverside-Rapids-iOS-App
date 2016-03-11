//
//  SignInViewController.swift
//  Rapids
//
//  Created by Programming 12 on 2016-03-03.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, SharePointRequestDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var progressView: UIActivityIndicatorView!
    
    var username: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 0, height: 700)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func signIn(sender: UIBarButtonItem) {
        username = usernameField.text!
        password = passwordField.text!
       
        SharePointRequestManager.sharedInstance.getUserInfo(username!, password: password!, delegate: self)
    }
    
    // MARK: SharePointRequestManager
    
    typealias CacheType = AnyObject
    typealias ResponseType = NSDictionary
    
    func didFailPreConditions(error: Int) {
        // not needed
    }
    
    func didFindCachedData(cachedData: CacheType) {
        // not needed
    }
    
    func willStartNetworkLoad() {
        progressView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        progressView.hidesWhenStopped = true
        progressView.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressView)
    }
    
    func didReceiveNetworkData(networkData: ResponseType) {
        CredentialsManager.sharedInstance.signIn(username!, password: password!, userDisplayName: networkData["Name"]! as! String)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didReceiveNetworkError(error: ErrorType) {
        progressView.stopAnimating()
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "signIn:")
        self.navigationItem.rightBarButtonItem = doneButton
    
        let signInFailedAlert = UIAlertController(title: "Sign In Error", message: "There was an error verifying your credentials", preferredStyle: UIAlertControllerStyle.Alert)
        
        signInFailedAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            CredentialsManager.sharedInstance.signOut()
    
            
            }))
        presentViewController(signInFailedAlert, animated: true, completion: nil)
        
    }
    
    func didFinishNetworkLoad() {
        //not needed
    }
    
    /*// In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
