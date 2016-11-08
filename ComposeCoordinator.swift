import UIKit
import CoordinatorKit
import RxSwift

class ComposeCoordinator: Coordinator {
    var composeVC: ComposeVC { return viewController as! ComposeVC }
    override func start() {
        super.start()
        viewController = ComposeVC()
        composeVC.setupNavigationBar()
        composeVC.navigationItem.rightBarButtonItem!.rx.tap.subscribe(onNext: {
            let body = self.composeVC.composeView.tweetTextView.text!
            Twitterer.post(tweet: body)
            self.didSubmit()
        }).addDisposableTo(db)
    }
    let db = DisposeBag()
    
    var didSubmit: (() -> ())!
}
