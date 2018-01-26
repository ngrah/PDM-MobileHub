//
//  SignInTableViewController.swift
//  PDM-MobileHub
//
//  Created by Nick Grah on 1/26/18.
//  Copyright © 2018 PDM. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
//import AWSCognitoAuth

class SignInTableViewController: UITableViewController{

    //var demoFeatures: [DemoFeature] = []
    fileprivate let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    
  //********************************************************************************
    func onSignIn (_ success: Bool) {
        // handle successful sign in
        if (success) {
            //self.setupRightBarButtonItem()
            performSegue(withIdentifier: "didSignIn", sender: self)
        } else {
            // handle cancel operation from user
        }
    }
    
  //********************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        // Default theme settings.
        //navigationController!.navigationBar.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //navigationController!.navigationBar.barTintColor = UIColor(red: 0xF5/255.0, green: 0x85/255.0, blue: 0x35/255.0, alpha: 1.0)
        //navigationController!.navigationBar.tintColor = UIColor.white
        
       
        
        self.presentSignInViewController()
        
    }

  //********************************************************************************
    func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = loginButton
        navigationItem.rightBarButtonItem!.target = self
        
        if (AWSSignInManager.sharedInstance().isLoggedIn) {
            navigationItem.rightBarButtonItem!.title = NSLocalizedString("Sign-Out", comment: "Label for the logout button.")
            navigationItem.rightBarButtonItem!.action = #selector(SignInTableViewController.handleLogout)
        }
    }
    
  //********************************************************************************
    func getViewController() -> UIViewController {
        return self;
    }
    
    //********************************************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  //********************************************************************************

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
    
   
    
  

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  //********************************************************************************
    func presentSignInViewController() {
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            let config = AWSAuthUIConfiguration()
            config.enableUserPoolsUI = true
            config.canCancel = false
            
            AWSAuthUIViewController.presentViewController(with: self.navigationController!,
                                                          configuration: config,
                                                          completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                                                            if error != nil {
                                                                print("Error occurred: \(error)")
                                                            } else {
                                                                self.onSignIn(true)
                                                            }
            })
        }
    }
    
  //********************************************************************************
    @objc func handleLogout() {
        if (AWSSignInManager.sharedInstance().isLoggedIn) {
            AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
                self.navigationController!.popToRootViewController(animated: false)
                self.setupRightBarButtonItem()
                self.presentSignInViewController()
            })
            // print("Logout Successful: \(signInProvider.getDisplayName)");
        } else {
            assert(false)
        }
    }
    
      //********************************************************************************
    
     //   func getViewController() -> UIViewController {
     //       return self;
     //   }
        
        
        
  

   
    //********************************************************************************
}
