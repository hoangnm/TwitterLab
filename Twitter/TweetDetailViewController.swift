//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by VietCas on 3/27/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit

@objc protocol TweetDetailDelegate {
    func updateTweet(tweet: Tweet)
}

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    weak var delegate: TweetDetailDelegate?
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        avatarImageView.setImageWithURL(tweet.avatarUser!)
        nameLabel.text = tweet.name
        tweetLabel.text = tweet.text
        if let screename = tweet.screenName {
            usernameLabel.text = "@" + screename
        }
        retweetsCountLabel.text = String(tweet.retweetCount)
        favoritesCountLabel.text = String(tweet.favoritesCount)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm"
        timeLabel.text = formatter.stringFromDate(tweet.timestamp!)
        
        if (tweet.screenName == User.currentUser!.screenName) {
            retweetButton.enabled = false
        }
        
        toggleFavoriteButton()
        toggleRetweetButton()
    }

    override func viewWillDisappear(animated: Bool) {
        delegate?.updateTweet(tweet)
    }
    
    func toggleFavoriteButton() {
        let isFavorite = tweet.favorited
        if isFavorite {
            favoriteButton.setImage(UIImage(named: "chrismas_star_filled"), forState: .Normal)
            favoriteButton.tintColor = UIColor.yellowColor()
        } else {
            favoriteButton.setImage(UIImage(named: "chrismas_star"), forState: .Normal)
            favoriteButton.tintColor = UIColor.darkGrayColor()
        }
    }
    
    func toggleRetweetButton() {
        if tweet.retweeted {
            retweetButton.tintColor = UIColor.greenColor()
        } else {
            retweetButton.tintColor = UIColor.darkGrayColor()
        }
    }

    
    @IBAction func favoritesClick(sender: AnyObject) {
        tweet.favorited = !tweet.favorited
        toggleFavoriteButton()
        TwitterClient.sharedInstance.addFavoriteTweet(tweet.id!, favorite: tweet.favorited, success: { (tweet: Tweet) in
            print("success")
        }, failure: nil)
    }

    @IBAction func replyClick(sender: AnyObject) {
        
    }
    
    @IBAction func retweetClick(sender: AnyObject) {
        tweet.retweeted = !tweet.retweeted
        toggleRetweetButton()
        TwitterClient.sharedInstance.retweet(tweet.id!, retweet: tweet.retweeted, success: { (tweet: Tweet) in
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
