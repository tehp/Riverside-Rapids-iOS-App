//
//  MoreViewController.swift
//  Rapids
//
//  Created by Mac Craig on 2016-02-15.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

import UIKit

class MoreViewController: UIViewController {
    
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if CredentialsManager.sharedInstance.signedIn {
            signinButton.setTitle(CredentialsManager.sharedInstance.userDisplayName, forState: .Normal)
        } else {
            signinButton.setTitle("Sign In", forState: .Normal)
        }
    }
    
    @IBAction func schoolMapClicked(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("mapNavVC")
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func aboutClicked(sender: UIButton) {
    }
    
    @IBAction func signinClicked(sender: UIButton) {
        if !CredentialsManager.sharedInstance.signedIn {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("signInNavVC")
            self.presentViewController(vc, animated: true, completion: nil)
        } else {
            let signOutAlert = UIAlertController(title: "Sign out", message: "Do you want to sign out?", preferredStyle: UIAlertControllerStyle.Alert)
            
            signOutAlert.addAction(UIAlertAction(title: "Sign out", style: .Default, handler: { (action: UIAlertAction!) in
                CredentialsManager.sharedInstance.signOut()
                self.signinButton.setTitle("Sign In" , forState: .Normal)
            }))
            
            signOutAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                print("User Canceled")
            }))

            
            presentViewController(signOutAlert, animated: true, completion: nil)
        }
    }
    
}

