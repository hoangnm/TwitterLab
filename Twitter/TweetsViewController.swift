//
//  TweetsViewController.swift
//  Twitter
//
//  Created by VietCas on 3/26/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, NewTweetViewDelegate {

    // MARK: - Attributes
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets = [Tweet]()
    
    var loadingMoreView:InfiniteScrollActivityView?
    
    var page = 1
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchHomeTimeline(hasRefresh: nil, isInfinite: false)
        initTableView()
        initRefreshControl()
        initInfiniteScroll()
    }
    
    func fetchHomeTimeline(hasRefresh refreshControl: UIRefreshControl?, isInfinite: Bool) {
        TwitterClient.sharedInstance.homeTimeLine(page, success: { (tweets: [Tweet]) in
            if isInfinite {
                self.loadingMoreView!.stopAnimating()
                self.isMoreDataLoading = false
                self.tweets.appendContentsOf(tweets)
            } else {
                self.tweets = tweets
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
                refreshControl?.endRefreshing()
            })
        }) { (error: NSError) in
            
        }
    }
    
    func didUpdateTweet(updatedTweet: Tweet) {
        tweets.insert(updatedTweet, atIndex: 0)
        self.tableView.reloadData()
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
            tweetDetailVC.delegate = self
        } else if let newTweetVC = segue.destinationViewController as? NewTweetViewController {
            if let cell = sender as? TweetCell {
                let indexPath = tableView.indexPathForCell(cell)!
                newTweetVC.replyId = tweets[indexPath.row].id
                newTweetVC.replyUserName = tweets[indexPath.row].screenName
            }
            newTweetVC.delegate = self
        }
    }
    
    /*@IBAction func unwindSegueInTweetsViewController(segue: UIStoryboardSegue) {
       
    }*/

}

extension TweetsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                page = page + 1
                fetchHomeTimeline(hasRefresh: nil, isInfinite: true)
            }
        }
    }
    
    func initInfiniteScroll() {
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
}

extension TweetsViewController: TweetDetailDelegate {
    func updateTweet(tweet: Tweet) {
        tableView.reloadData()
    }
}

extension TweetsViewController {
    
    func initRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        page = 1
        fetchHomeTimeline(hasRefresh: refreshControl, isInfinite: false)
    }
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.delegate = self
        cell.toggleRetweetButton()
        cell.toggleFavoriteButton()
        return cell
    }
    
    func reply(tweet: Tweet, target: TweetCell?) {
        performSegueWithIdentifier("NewTweetSegue", sender: target!)
    }
    
    func retweet(tweet: Tweet, target: TweetCell?) {
        tableView.reloadData()
        TwitterClient.sharedInstance.retweet(tweet.id!, retweet: tweet.retweeted, success: { (tweet: Tweet) in
            print("success")
        }) { (error: NSError) in
            
        }
    }
    
    func addToFavorite(tweet: Tweet, target: TweetCell?) {
        tableView.reloadData()
        TwitterClient.sharedInstance.addFavoriteTweet(tweet.id!, favorite: tweet.favorited, success: nil, failure: nil)
    }
}
