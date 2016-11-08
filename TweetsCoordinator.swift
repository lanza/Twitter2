import Foundation
import CoordinatorKit
import RxSwift


class TweetsCoordinator: Coordinator {
    var tweetsTVC: TweetsTVC { return viewController as! TweetsTVC }
    override func loadViewController() {
        viewController = TweetsTVC()
        
    }
    override func viewControllerDidLoad() {
        super.viewControllerDidLoad()
        
        tweetsTVC.setupNavigationBar()
        
        viewController.navigationItem.rightBarButtonItem!.rx.tap.asObservable().subscribe(onNext: { _ in
            self.pushComposeCoordinator()
        }).addDisposableTo(db)
        
        tweetsTVC.tableView.rx.modelSelected(Tweet.self).asObservable().subscribe(onNext: { tweet in
            
            let tc = TweetCoordinator()
            tc.tweet = tweet
            tc.start()
            self.show(tc, sender: self)
            
        }).addDisposableTo(db)
        
        tweetsTVC.goToProfileForUser = { user in
            let pc = OtherUserProfileCoordinator()
            pc.user = user
            self.show(pc, sender: self)
        }
    }
    
    func pushComposeCoordinator() {
        let cc = ComposeCoordinator()
        cc.start()
        cc.didSubmit = {
            _ = self.navigationCoordinator?.popCoordinator(animated: true)
        }
        show(cc, sender: self)
    }
    let db = DisposeBag()
}




class OtherUserProfileCoordinator: Coordinator {
    
    var profileVC: ProfileVC { return viewController as! ProfileVC }
    
    var user: User!
    
    override func loadViewController() {
        viewController = ProfileVC()
        profileVC.otherUser = true
        profileVC.user = self.user
    }
    
    
}
