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
    
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchHomeTimeline(hasRefresh: nil)
        initTableView()
        initRefreshControl()
    }
    
    func fetchHomeTimeline(hasRefresh refreshControl: UIRefreshControl?) {
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) in
            self.tweets = tweets
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
                refreshControl?.endRefreshing()
            })
        }) { (error: NSError) in
            
        }
    }
    
    @IBAction func logoutClick(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let tweetDetailVC = segue.destinationViewController as? TweetDetailViewController, let cell = sender as? TweetCell {
            let indexPath = tableView.indexPathForCell(cell)!
            tweetDetailVC.tweet = tweets[indexPath.row]
        }
    }
    
    @IBAction func unwindSegueInTweetsViewController(segue: UIStoryboardSegue) {
    
    }

}

extension TweetsViewController {
    
    func initRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        fetchHomeTimeline(hasRefresh: refreshControl)
    }
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        return cell
    }
}
