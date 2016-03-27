//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by VietCas on 3/27/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Atributes

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetBarButton: UIBarButtonItem!
    
    var replyId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        
        let user = User.currentUser!
        avatarImageView.setImageWithURL(user.profileUrl!)
        
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
                print(tweet)
                self.performSegueWithIdentifier("UnwindTweetSegue", sender: self)
            }) { (error: NSError) in
                
            }
        }
    }
    
    func replyTweet() {
        if let status = tweetTextView.text {
            TwitterClient.sharedInstance.replyTweet(status, replyId: replyId!, success: { (tweet: Tweet) in
                print("success")
                }, failure: { (error: NSError) in
                    
            })
        }
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        if tweetTextView.text.isEmpty == false {
            tweetBarButton.enabled = true
        } else {
            tweetBarButton.enabled = false
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
