//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by VietCas on 3/27/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    var tweet: Tweet!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        avatarImageView.setImageWithURL(tweet.avatarUser!)
        nameLabel.text = tweet.name
        tweetLabel.text = tweet.text
        retweetsCountLabel.text = String(tweet.retweetCount)
        favoritesCountLabel.text = String(tweet.favoritesCount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoritesClick(sender: AnyObject) {
        TwitterClient.sharedInstance.addFavoriteTweet(tweet.id!, success: { (tweet: Tweet) in
            print("success")
        }) { (error: NSError) in
            
        }
    }

    @IBAction func replyClick(sender: AnyObject) {
        
    }
    
    @IBAction func retweetClick(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet.id!, success: { (tweet: Tweet) in
            print("success")
        }) { (error: NSError) in
            
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destinationViewController as? NewTweetViewController {
            vc.replyId = tweet.id!
        }
        
    }

}
