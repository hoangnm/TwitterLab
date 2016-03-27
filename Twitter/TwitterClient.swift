//
//  TwitterClient.swift
//  Twitter
//
//  Created by VietCas on 3/26/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "Fg6MRwzohaf0Q8mgKc1SLvIrP", consumerSecret: "PT2Wmvo1bcpizQYv51DYwxpLcZfZWZLyV7hOoCIzB0RPtMt7IY")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func homeTimeLine(page: Int, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        let params = ["page": page]
        GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func updateTweet(status: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let params = ["status": status]
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func replyTweet(status: String, replyId: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let params = ["status": status, "in_reply_to_status_id": replyId]
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func addFavoriteTweet(tweetId: String, favorite: Bool, success: ((Tweet) -> ())?, failure: ((NSError) -> ())?) {
        let params = ["id": tweetId]
        let action: String
        if favorite {
            action = "create"
        } else {
            action = "destroy"
        }
        POST("1.1/favorites/\(action).json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success?(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure?(error)
        }
    }
    
    func retweet(tweetId: String, retweet: Bool, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let action: String
        if retweet {
            action = "retweet"
        } else {
            action = "unretweet"
        }
        POST("1.1/statuses/\(action)/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "goodtweet://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) -> Void in
            print(error.localizedDescription)
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            
        }) { (error: NSError!) -> Void in
            print("error:\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
}
