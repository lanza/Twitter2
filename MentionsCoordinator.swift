import UIKit
import CoordinatorKit
import RxSwift



class MentionsCoordinator: TweetsCoordinator {
    
    override func loadViewController() {
        viewController = TweetsTVC()
        
        tweetsTVC.refresh = {
            Twitterer.getMentions()
        }
        tweetsTVC.page = {}
        tweetsTVC.tweetsObservable = Twitterer.mentions
    }
}

