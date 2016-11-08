import RxSwift
import UIKit

class ComposeVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .done, target: nil, action: nil)
    }
    var composeView: ComposeView!
    func setupViews() {
        
        composeView = Bundle.main.loadNibNamed("ComposeView", owner: nil, options: nil)![0] as! ComposeView
        view.addSubview(composeView)
        composeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            composeView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            composeView.leftAnchor.constraint(equalTo: view.leftAnchor),
            composeView.rightAnchor.constraint(equalTo: view.rightAnchor),
            composeView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ])
        
        composeView.nameLabel.text = User.active!.name
        composeView.handleLabel.text = User.active!.handle
        composeView.profileImageView.af_setImage(withURL: URL(string: User.active!.profileImageURL)!)
        composeView.profileImageView.setupLayer()
        composeView.tweetTextView.text = ""
        
        composeView.tweetTextView.rx.didChange.subscribe(onNext: {
            self.composeView.characterCountLabel.text = String(140 - self.composeView.tweetTextView.text.characters.count)
        }).addDisposableTo(db)
    }
    
    
    let db = DisposeBag()
}
