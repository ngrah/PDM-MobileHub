//
//  ViewController.swift
//  PDM-MobileHub
//
//  Created by Nick Grah on 1/21/18.
//  Copyright © 2018 PDM. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController.presentViewController(with: self.navigationController!, configuration: nil, completionHandler: {
                (provider: AWSSignInProvider, error: Error?) in
                if error != nil { print("Error occurred: \(String(describing: error))")
                }
                else {
                      // Sign in successful.
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

