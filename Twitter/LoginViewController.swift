//
//  LoginViewController.swift
//  Twitter
//
//  Created by VietCas on 3/22/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Event Action
    
    @IBAction func onLoginClick(sender: AnyObject) {
        handleOauth()
    }
    
    // MARK: - Methods
    func handleOauth() {
        let client = TwitterClient.sharedInstance
        client.login({ 
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) in
            
        }
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
