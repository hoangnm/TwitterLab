//
//  TweetCell.swift
//  Twitter
//
//  Created by VietCas on 3/27/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    func addToFavorite(tweet: Tweet, target: TweetCell?)
    func reply(tweet: Tweet, target: TweetCell?)
    func retweet(tweet: Tweet, target: TweetCell?)
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    
    @IBOutlet weak var imageVerticalTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameVerticalTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameVerticalTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var hourVerticalTopConstraint: NSLayoutConstraint!
    
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.name
            tweetLabel.text = tweet.text
            if let screename = tweet.screenName {
                usernameLabel.text = "@" + screename
            }
            if let avatar = tweet.avatarUser {
                avatarImageView.setImageWithURL(avatar)
            }
            
            if let retweetedStatusScreenName = tweet.retweetedStatusScreenName {
                retweetLabel.text = "\(retweetedStatusScreenName) has retweeted"
                retweetLabel.hidden = false
                imageVerticalTopConstraint.constant = 25
                nameVerticalTopConstraint.constant = 25
                usernameVerticalTopConstraint.constant = 25
                hourVerticalTopConstraint.constant = 25
            } else {
                retweetLabel.hidden = true
                imageVerticalTopConstraint.constant = 8
                nameVerticalTopConstraint.constant = 8
                usernameVerticalTopConstraint.constant = 8
                hourVerticalTopConstraint.constant = 8
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            timeLabel.text = formatter.stringFromDate(tweet.timestamp!)
            
            if (tweet.screenName == User.currentUser!.screenName) {
                retweetButton.enabled = false
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func replyClick(sender: AnyObject) {
        delegate?.reply(tweet, target: self)
    }
    @IBAction func retweetClick(sender: AnyObject) {
        tweet.retweeted = !tweet.retweeted
        delegate?.retweet(tweet, target: nil)
    }
    @IBAction func ratingClick(sender: AnyObject) {
        tweet.favorited = !tweet.favorited
        delegate?.addToFavorite(tweet, target: nil)
    }
    
    func toggleRetweetButton() {
        if tweet.retweeted {
            retweetButton.tintColor = UIColor.greenColor()
        } else {
            retweetButton.tintColor = UIColor.darkGrayColor()
        }
    }
    
    func toggleFavoriteButton() {
        if tweet.favorited {
            let image = UIImage(named: "chrismas_star_filled")
            favoriteButton.setImage(image, forState: .Normal)
            favoriteButton.tintColor = UIColor.yellowColor()
        } else {
            favoriteButton.setImage(UIImage(named: "chrismas_star"), forState: .Normal)
            favoriteButton.tintColor = UIColor.darkGrayColor()
        }
    }
}
