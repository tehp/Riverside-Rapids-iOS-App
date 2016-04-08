//
//  MainViewController.swift
//  Rapids
//
//  Created by Programming 12 on 2016-04-07.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    var showedSignIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func viewDidAppear(animated: Bool) {
        if AppDelegate.firstLaunch && !showedSignIn {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("signInNavVC")
            self.presentViewController(vc, animated: true, completion: nil)
            showedSignIn = true
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
