//
//  TweetsViewController.swift
//  Twitter
//
//  Created by VietCas on 3/26/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    // MARK: - Attributes
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchHomeTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchHomeTimeline() {
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) in
            print(tweets)
        }) { (error: NSError) in
            
        }
    }
    
    @IBAction func logoutClick(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
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
