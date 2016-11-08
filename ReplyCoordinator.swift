import CoordinatorKit
import RxSwift

class ReplyCoordinator: Coordinator {
    var tweet: Tweet!
    var composeVC: ComposeVC { return viewController as! ComposeVC }
    
    override func start() {
        super.start()
        viewController = ComposeVC()
        composeVC.setupNavigationBar()
        composeVC.navigationItem.rightBarButtonItem!.rx.tap.subscribe(onNext: {
            let body = self.composeVC.composeView.tweetTextView.text!
            Twitterer.post(reply: body, to: self.tweet)
            self.didSubmit()
        }).addDisposableTo(db)
    }
    
    var didSubmit: (()->())!
    
    let db = DisposeBag()
}
