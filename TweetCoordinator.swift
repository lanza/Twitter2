import UIKit
import CoordinatorKit
import RxCocoa
import RxSwift

class TweetCoordinator: Coordinator {
    
    var tweet: Tweet!
    
    var tweetVC: TweetVC { return viewController as! TweetVC }
    
    override func start() {
        super.start()
        
        viewController = TweetVC()
        tweetVC.tweet = tweet
        print(tweetVC.view)
        tweetVC.tweetView.replyButton.rx.tap.subscribe(onNext: {
            self.startReplyCoordinator()
        }).addDisposableTo(db)
    }
    
    func startReplyCoordinator() {
        let rc = ReplyCoordinator()
        rc.tweet = tweet
        rc.start()
        rc.didSubmit = {
            print(self.navigationCoordinator!.coordinators)
            _ = self.navigationCoordinator?.popCoordinator(animated: true)
        }
        show(rc, sender: self)
    }
    
    let db = DisposeBag()
}





