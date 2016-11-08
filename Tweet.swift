import SwiftyJSON
import Foundation

class Tweet {
    static func json(_ json: JSON) -> Tweet {
        let tweet = Tweet()
        tweet.tweeter = json["user"]["name"].stringValue
        tweet.text = json["text"].stringValue
        tweet.retweetCount = json["retweet_count"].intValue
        tweet.retweeted = json["retweeted"].boolValue
        tweet.profileImageURL = json["user"]["profile_image_url"].stringValue
        tweet.handle = json["user"]["screen_name"].stringValue
        tweet.timeTweeted = json["created_at"].stringValue
        tweet.id = json["id"].stringValue
        tweet.favorited = json["favorited"].boolValue
        tweet.favoriteCount = json["favorite_count"].intValue
        tweet.replyTo = json["in_reply_to_screen_name"].string
        if let quoted = json["quoted_status"].dictionary, quoted.count > 5 {
            tweet.responseTo = Tweet.json(JSON(quoted))
        }
        if let retweeted = json["retweeted_status"].dictionary, retweeted.count > 5 {
            tweet.retweetedTweet = Tweet.json(JSON(retweeted))
        }
        tweet.inReplyToScreenName = json["in_reply_to_screen_name"].string
        tweet.posterFollowerCount = json["user"]["followers_count"].stringValue
        tweet.posterFollowingsCount = json["user"]["friends_count"].stringValue
        tweet.profileBackgroundImageURL = json["user"]["profile_background_image_url_https"].stringValue
        tweet.userDescription = json["user"]["description"].stringValue
        return tweet
    }
    var userDescription: String!
    var profileBackgroundImageURL: String!
    var posterFollowerCount: String!
    var posterFollowingsCount: String!
    var retweetedTweet: Tweet?
    var responseTo: Tweet?
    var favoriteCount: Int!
    var replyTo: String?
    var favorited: Bool!
    var handle: String!
    var profileImageURL: String!
    var tweeter: String!
    var text: String!
    var retweetCount: Int!
    var retweeted: Bool!
    var timeTweeted: String!
    var id: String!
    var inReplyToScreenName: String?
}
