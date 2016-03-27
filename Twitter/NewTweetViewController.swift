//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by VietCas on 3/27/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewDelegate {
    func didUpdateTweet(updatedTweet: Tweet)
}

class NewTweetViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Atributes

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetBarButton: UIBarButtonItem!
    @IBOutlet weak var newTweetNavigationItem: UINavigationItem!
    
    let countLabel = UILabel()
    
    weak var delegate: NewTweetViewDelegate?
    
    var replyId: String?
    var replyUserName: String?
    
    let tweetLimit = 140
    var remainingCharacter = 140 {
        didSet {
            countLabel.text = String(remainingCharacter)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        
        countLabel.text = String(tweetLimit)
        countLabel.textColor = UIColor.lightGrayColor()
        countLabel.sizeToFit()
        let labelButton = UIBarButtonItem(customView: countLabel)
        newTweetNavigationItem.rightBarButtonItems?.append(labelButton)
        
        
        let user = User.currentUser!
        avatarImageView.setImageWithURL(user.profileUrl!)
        
        if replyUserName != nil {
            tweetTextView.text = "@\(replyUserName!) "
            remainingCharacter = tweetLimit - tweetTextView.text.characters.count
        }
        
        if tweetTextView.text.isEmpty {
            tweetBarButton.enabled = false
        }
    }
    
    @IBAction func newTweetClick(sender: AnyObject) {
        if replyId != nil {
            replyTweet()
        } else {
            addNewTweet()
        }
    }
    
    @IBAction func cancelClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addNewTweet() {
        if let status = tweetTextView.text {
            TwitterClient.sharedInstance.updateTweet(status, success: { (tweet: Tweet) in
                self.delegate?.didUpdateTweet(tweet)
            }) { (error: NSError) in
                
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func replyTweet() {
        if let status = tweetTextView.text {
            TwitterClient.sharedInstance.replyTweet(status, replyId: replyId!, success: { (tweet: Tweet) in
                self.delegate?.didUpdateTweet(tweet)
            }, failure: { (error: NSError) in
                    
            })
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        if tweetTextView.text.isEmpty == false {
            remainingCharacter = tweetLimit - textView.text.characters.count
            if remainingCharacter < 0 {
                tweetBarButton.enabled = false
            } else {
                tweetBarButton.enabled = true
            }
        } else {
            tweetBarButton.enabled = false
            remainingCharacter = tweetLimit
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
