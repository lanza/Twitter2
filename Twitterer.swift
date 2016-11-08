import OAuthSwift
import OAuthSwiftAlamofire
import Alamofire
import Moya
import SwiftyJSON
import RxSwift

class Twitterer {
    
    static let isAuthed = Variable(false)
    static let isLoadingMoreData = Variable(false)
    static var timeline = Variable([Tweet]())
   
    static var provider: MoyaProvider<Twitter>!
    
    static let oauthConsumerKey = "R8IkjsyifH87HxO185lNoIybB"
    static let oauthConsumerSecret = "xgg6CIGy42oda5fuPwk9BK2N1O32q3eHLb1T6udPwBCblSI3MI"
    static let baseURL = "https://api.twitter.com"
    static var oauthURL: String { return baseURL + "/oauth" }
    static var requestTokenURL: String { return oauthURL + "/request_token" }
    static var authorizeURL: String { return oauthURL + "/authorize" }
    static var accessTokenURL: String { return oauthURL + "/access_token" }
    static var callbackURL: String { return "oauth-swift://oauth-callback/twitter" }

    static let oAuthSwift = OAuth1Swift(consumerKey: oauthConsumerKey, consumerSecret: oauthConsumerSecret, requestTokenUrl: requestTokenURL, authorizeUrl: authorizeURL, accessTokenUrl: accessTokenURL)

    static func didAuth() {
        let sessionManager = SessionManager.default
        sessionManager.adapter = oAuthSwift.requestAdapter
        
        let endpointClosure = { (target: Twitter) -> Endpoint<Twitter> in
            return  Endpoint(
                URL: target.baseURL.appendingPathComponent(target.path).absoluteString,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                parameters: target.parameters,
                parameterEncoding: URLEncoding.queryString
            )
        }
        provider = MoyaProvider<Twitter>(endpointClosure: endpointClosure, manager: sessionManager)
        isAuthed.value = true
    }
    
    static let defaults = UserDefaults.standard
    
    static func getLastUser() {
        if let token = defaults.value(forKey: "lastToken") as? String, let secret = defaults.value(forKey: "lastSecret") as? String {
            oAuthSwift.client.credential.oauthToken = token
            oAuthSwift.client.credential.oauthTokenSecret = secret
            didAuth()
        } else {
            auth()
        }
    }
    
    
    
    static func auth() {
        isLoadingMoreData.value = true
        let success: OAuthSwift.TokenSuccessHandler = { credential, response, parameters in
            didAuth()
            defaults.set(oAuthSwift.client.credential.oauthToken, forKey: "lastToken")
            defaults.set(oAuthSwift.client.credential.oauthTokenSecret, forKey: "lastSecret")
            self.isLoadingMoreData.value = false
            Twitterer.getUser()
        }
        let failure: OAuthSwift.FailureHandler = { error in
            print(error)
            self.isLoadingMoreData.value = false
        }
        oAuthSwift.authorize(withCallbackURL: callbackURL, success: success, failure: failure)
    }
    
    static func getUser() {
        provider.request(.user) { result in
            switch result {
            case .failure(let error):
                print(error)
                fatalError()
            case .success(let response):
                print("==============================================")
                dump(JSON(data:response.data))
                print("==============================================")
                User.active = User(json: JSON(data: response.data))
                
                var credentials = defaults.value(forKey: "credentials") as? [[String:String]] ?? [[String:String]]()
                let exists = credentials.map { $0["token"]! == oAuthSwift.client.credential.oauthToken }.reduce(false) { $0 || $1 }
                if !exists {
                    let credential = [
                        "token":oAuthSwift.client.credential.oauthToken,
                        "secret":oAuthSwift.client.credential.oauthTokenSecret,
                        "name":(User.active!.name)!
                    ]
                    credentials.append(credential)
                }
                defaults.setValue(credentials, forKey: "credentials")
            }
        }
    }
    enum Timeline {
        case page
        case refresh
    }
    static var max_id: String? = nil
    static func get(timeline: Timeline) {
        self.isLoadingMoreData.value = true
        if timeline == .refresh {
            max_id = nil
        }
        provider?.request(.home(maxID: max_id)) { result in
            self.isLoadingMoreData.value = false
            switch result {
            case .success(let response):
                let tweets = JSON(data: response.data).arrayValue.map { Tweet.json($0) }
                
                self.max_id = tweets.last?.id
                
                switch timeline {
                case .refresh:
                    self.timeline.value = tweets
                case .page:
                    self.timeline.value += tweets
                }
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    static var mentions = Variable([Tweet]())
    static func getMentions() {
        self.isLoadingMoreData.value = true
        provider?.request(.mentions) { result in
            self.isLoadingMoreData.value = false
            switch result {
            case .success(let response):
                self.mentions.value = JSON(data: response.data).arrayValue.map { Tweet.json($0) }
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    static var userTweets = Variable([Tweet]())
    static func getUserTweets(user: User) {
        self.isLoadingMoreData.value = true
        provider?.request(.userTweets(user: user)) { result in
            self.isLoadingMoreData.value = false
            switch result {
            case .success(let response):
                self.userTweets.value = JSON(data: response.data).arrayValue.map { Tweet.json($0) }
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    static func post(tweet: String) {
        provider.request(.tweet(body: tweet)) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                dump(response.request!)
                Twitterer.get(timeline: .refresh)
            }
        }
    }
    static func post(reply: String, to tweet: Tweet) {
        provider.request(.reply(tweet: tweet, body: reply)) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                print(response)
                Twitterer.get(timeline: .refresh)
            }
        }
    }
    static func post(favorite tweet: Tweet) {
        provider.request(.favorite(tweet: tweet)) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                print(response)
            }
        }
    }
    static func unfavorite(tweet: Tweet) {
        provider.request(.unfavorite(tweet: tweet)) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                print(response)
            }
        }
    }
    static func post(retweet: Tweet) {
        provider.request(.retweet(tweet: retweet)) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
               print("")
            }
        }
    }
    static func unretweet(tweet: Tweet) {
        provider.request(.unretweet(tweet: tweet)) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let _):
                print("")
            }
        }
    }
}













