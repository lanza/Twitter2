import UIKit
import CoordinatorKit
import RxSwift
import RxCocoa
import StretchHeader

class ProfileCoordinator: Coordinator {
    
    var profileVC: ProfileVC { return viewController as! ProfileVC }
    
    override func loadViewController() {
        viewController = ProfileVC()
    }
    
    
}

class TableHeaderView: UIView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var follwersCount: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageContainerView: UIView!
    
    
    let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    let nahvc = NameAndHandleVC()
    let dvc = DescriptionVC()
}

class ProfileVC: TweetsTVC, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
   
    var otherUser = false
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController === tableHeader.nahvc {
            return tableHeader.dvc
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController === tableHeader.dvc {
            return tableHeader.nahvc
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if pendingViewControllers[0] === tableHeader.nahvc {
            tableHeader.pageControl.currentPage = 0
            UIView.animate(withDuration: 0.3) {
                self.header.imageView.alpha = 0.4
            }
        } else {
            tableHeader.pageControl.currentPage = 1
            UIView.animate(withDuration: 0.5) {
                self.header.imageView.alpha = 1
            }
            
        }
        tableHeader.pageControl.updateCurrentPageDisplay()
    }
    
   
    var tableHeader: TableHeaderView!
    func setupHeader() {
        
        let options = StretchHeaderOptions()
        options.position = .underNavigationBar
        
        header = StretchHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 208), imageSize: CGSize(width: view.frame.width, height: 104), controller: self, options: options)
        if let url = URL(string: user.profileBackgroundImageURL) {
            header.imageView.af_setImage(withURL: url)
        } else {
            header.imageView.image = #imageLiteral(resourceName: "default")
        }
        
        tableHeader = Bundle.main.loadNibNamed("TableHeaderView", owner: nil, options: nil)![0] as! TableHeaderView
        tableHeader.profileImageView.af_setImage(withURL: URL(string: user.profileImageURL)!)
        tableHeader.profileImageView.setupLayer()
        tableHeader.follwersCount.text = user.followerCount
        tableHeader.followingCount.text = user.followingCount
        tableHeader.dvc.descriptionLabel.text = user.description
        tableHeader.nahvc.nameLabel.text = user.name
        tableHeader.nahvc.handleLabel.text = user.handle
        
        tableHeader.pvc.dataSource = self
        tableHeader.pvc.delegate = self
        tableHeader.pvc.setViewControllers([tableHeader.nahvc], direction: .forward, animated: true, completion: nil)
        tableHeader.pageControl.numberOfPages = 2
        tableHeader.pageControl.pageIndicatorTintColor = .black
        tableHeader.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.3462666273, green: 0.7172634602, blue: 0.9668716788, alpha: 1)
       
        addChildViewController(tableHeader.pvc)
        tableHeader.pageContainerView.addSubview(tableHeader.pvc.view)
        tableHeader.pvc.didMove(toParentViewController: self)
        
        let tempView = UIView(frame: CGRect(x: 0, y: 70, width: tableView.frame.width, height: 138))
        tempView.addSubview(tableHeader)
        tableHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableHeader.topAnchor.constraint(equalTo: tempView.topAnchor),
            tableHeader.leftAnchor.constraint(equalTo: tempView.leftAnchor),
            tableHeader.bottomAnchor.constraint(equalTo: tempView.bottomAnchor),
            tableHeader.rightAnchor.constraint(equalTo: tempView.rightAnchor)
            ])
        
        header.addSubview(tempView)
        
        tableView.tableHeaderView = header
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        header.updateScrollViewOffset(scrollView)
        header.imageView.alpha = CGFloat(1) - CGFloat(-scrollView.contentOffset.y / 300)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init() {
        super.init(nibName: nil, bundle: nil)
        refresh = {
            Twitterer.getUserTweets(user: self.user)
        }
        page = {}
        tweetsObservable = Twitterer.userTweets
    }
    
    override func setupRx() {
        super.setupRx()
    }
 
    var _user: User! {
        didSet {
            setupHeader()
            refresh()
        }
    }
    var user: User! {
        get {
            if _user == nil {
                _user = User.active
            }
            return _user!
        }
        set {
            _user = newValue
        }
    }
   
    override func setupTableView() {
        super.setupTableView()
        
        setupHeader()
    }
    
    var header: StretchHeader!
    

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        header.backgroundColor = .white
        let segment = UISegmentedControl(items: ["Tweets","Media","Likes"])
        header.addSubview(segment)
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        let separator = UIView()
        separator.backgroundColor = .gray
        header.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segment.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 8),
            segment.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -8),
            segment.topAnchor.constraint(equalTo: header.topAnchor, constant: 8),
            segment.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8),
            separator.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leftAnchor.constraint(equalTo: header.leftAnchor),
            separator.rightAnchor.constraint(equalTo: header.rightAnchor)
        ])
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if !otherUser {
            User.activeVariable.asObservable().subscribe(onNext: { user in
                self.user = user!
            }).addDisposableTo(db)
        }
    }
}



