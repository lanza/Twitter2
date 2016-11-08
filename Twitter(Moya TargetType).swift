import Moya

enum Twitter: TargetType {
    case home(maxID: String?)
    case mentions
    case userTweets(user: User)
    case user
    case tweet(body: String)
    case reply(tweet: Tweet, body: String)
    case favorite(tweet: Tweet)
    case unfavorite(tweet: Tweet)
    case retweet(tweet: Tweet)
    case unretweet(tweet: Tweet)
    
}
extension Twitter {
    
    var baseURL: URL { return URL(string: "https://api.twitter.com/1.1")! }
    
    var path: String {
        switch self {
        case .home: return "/statuses/home_timeline.json"
        case .mentions: return "/statuses/mentions_timeline.json"
        case .userTweets: return "/statuses/user_timeline.json"
    
        case .user: return "/account/verify_credentials.json"
            
        case .tweet: return "/statuses/update.json"
        case .reply: return "/statuses/update.json"
            
        case .favorite: return "/favorites/create.json"
        case .unfavorite: return "/favorites/destroy.json"
            
        case .retweet(let retweet): return "/statuses/retweet/\(retweet.id!).json"
        case .unretweet(let tweet): return "/statuses/unretweet/\(tweet.id!).json"
        }
    }
    var method: Method {
        switch self {
        case .tweet, .reply, .retweet, .favorite, .unfavorite, .unretweet: return .POST
        case .home, .mentions, .userTweets, .user: return .GET
        }
    }
    var parameters: [String : Any]? {
        switch self {
        case .home(let maxID):
            var dict = [String:Any]()
            dict["count"] = 20
            if let maxID = maxID {
                dict["max_id"] = maxID
            }
            return dict
        case .mentions:
            return nil
        case .userTweets(let user):
            return ["screen_name":user.handle]
        case .user:
            return nil
        case .tweet(body: let body):
            return ["status":body.urlEscaped]
        case .reply(tweet: let tweet, body: let body):
            return ["status":body, "in_reply_to_status_id":tweet.id]
        case .favorite(tweet: let tweet):
            return ["id":tweet.id]
        case .unfavorite(tweet: let tweet):
            return ["id":tweet.id]
        case .retweet(tweet: let tweet):
            return ["id":tweet.id]
        case .unretweet(tweet: let tweet):
            return ["id":tweet.id]
        }
    }
    var sampleData: Data { return Data() }
    var task: Task { return .request}
    
}

extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
