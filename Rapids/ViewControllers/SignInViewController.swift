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
       
        SharePointRequestManager.sharedInstance.checkAuth(username!, password: password!, delegate: self)
    }
    
    typealias CacheType = AnyObject
    typealias ResponseType = NSDictionary
    
    func didFindCachedData(cachedData: CacheType) {
        // not needed
    }
    
    func willStartNetworkLoad() {
        //not needed
    }
    
    func didReceiveNetworkData(networkData: ResponseType) {
        CredentialsManager.sharedInstance.signIn(username!, password: password!, userDisplayName: networkData["Name"]! as! String)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didReceiveNetworkError(error: ErrorType) {
        print(error)
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
