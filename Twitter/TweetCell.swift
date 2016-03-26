//
//  TweetCell.swift
//  Twitter
//
//  Created by VietCas on 3/27/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.name
            tweetLabel.text = tweet.text
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
    }
    @IBAction func retweetClick(sender: AnyObject) {
    }
    @IBAction func ratingClick(sender: AnyObject) {
    }
}
