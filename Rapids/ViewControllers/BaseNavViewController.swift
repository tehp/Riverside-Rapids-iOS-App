//
//  BaseNavViewController.swift
//  Rapids
//
//  Created by Programming 12 on 2016-05-02.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class BaseNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ViewControllerHelper.showRapidsLogo(self.visibleViewController!.navigationItem)
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
