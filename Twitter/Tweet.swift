//
//  Tweet.swift
//  Twitter
//
//  Created by VietCas on 3/26/16.
//  Copyright © 2016 com.demo. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: NSDate?
    var retweetCount = 0
    var favoritesCount = 0
    var name: String?
    var avatarUser: NSURL?
    var id: String?
    var screenName: String?
    var favorited: Bool = false
    var retweeted: Bool = false
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        name = dictionary["user"]?["name"] as? String
        id = dictionary["id_str"] as? String
        screenName = dictionary["user"]?["screen_name"] as? String
        favorited = dictionary["favorited"] as? Bool ?? false
        retweeted = dictionary["retweeted"] as? Bool ?? false
        
        let timestampString = dictionary["created_at"] as? String
        
        if let avatar = dictionary["user"]?["profile_image_url"] as? String {
            let avatarUrl = NSURL(string: avatar)
            avatarUser = avatarUrl
        }
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
