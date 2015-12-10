//
//  DestinationViewController.swift
//  SplitAnimationController-Example
//
//  Created by Matthew Buckley on 12/10/15.
//  Copyright © 2015 Matt Buckley. All rights reserved.
//

import UIKit

class DestinationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 7), dispatch_get_main_queue()) { () -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }

    }
    
}
