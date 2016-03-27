//
//  TweetCell.swift
//  Twitter
//
//  Created by VietCas on 3/27/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    func addToFavorite(tweetId: String)
    func reply(tweetId: String, cell: TweetCell)
    func retweet(tweetId: String)
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var isFavorite = false
    
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
            
            //timeLabel.text = String(tweet.timestamp)
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
        delegate?.reply(tweet.id!, cell: self)
    }
    @IBAction func retweetClick(sender: AnyObject) {
        delegate?.retweet(tweet.id!)
    }
    @IBAction func ratingClick(sender: AnyObject) {
        toggleFavoriteButton()
        delegate?.addToFavorite(tweet.id!)
    }
    
    func toggleFavoriteButton() {
        isFavorite = !isFavorite
        if isFavorite {
            favoriteButton.setImage(UIImage(named: "chrismas_star_filled"), forState: .Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "chrismas_star"), forState: .Normal)
        }
    }
}
