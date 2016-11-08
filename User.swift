import Foundation
import SwiftyJSON
import RxSwift

class User {
    
    init(json: JSON) {
        name = json["name"].stringValue
        handle = json["screen_name"].stringValue
        profileImageURL = json["profile_image_url_https"].stringValue
        followerCount = json["followers_count"].stringValue
        followingCount = json["friends_count"].stringValue
        profileBackgroundImageURL = json["profile_background_image_url_https"].stringValue
        description = json["description"].stringValue
    }
    init(tweet: Tweet) {
        name = tweet.tweeter
        handle = tweet.handle
        profileImageURL = tweet.profileImageURL
        followingCount = tweet.posterFollowingsCount
        followerCount = tweet.posterFollowerCount
        profileBackgroundImageURL = tweet.profileBackgroundImageURL
        description = tweet.userDescription
    }
    
    static var active: User? {
        didSet {
            activeVariable.value = active
        }
    }
    
    static var activeVariable = Variable(User.active)
    static var users: [User] = []
    
    var profileImageURL: String!
    var profileBackgroundImageURL: String!
    var name: String!
    var handle: String!
    var followerCount: String!
    var followingCount: String!
    var description: String!
}
