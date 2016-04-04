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
    
    override func viewDidAppear(animated: Bool) {
        if CredentialsManager.sharedInstance.signedIn {
            signinButton.setTitle(CredentialsManager.sharedInstance.userDisplayName, forState: .Normal)
        } else {
            signinButton.setTitle("Sign In", forState: .Normal)
        }
    }
    
    @IBAction func schoolMapClicked(sender: UIButton) {
    }
    
    @IBAction func aboutClicked(sender: UIButton) {
    }
    
    @IBAction func signinClicked(sender: UIButton) {
    }
    
}

