import UIKit
import RxSwift
import RxCocoa

extension TweetsTVC {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !Twitterer.isLoadingMoreData.value {
            let height = tableView.contentSize.height
            let threshold = height - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > threshold && tableView.isDragging {
                page()
            }
        }
    }
}

class TweetsTVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRx()
        setupRefreshControl()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Compose", style: .plain, target: nil, action: nil)
    }
    
    var refresh: (() -> ()) = {
        Twitterer.get(timeline: .refresh)
    }
    var page: (() -> ()) = {
        Twitterer.get(timeline: .page)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Twitterer.isAuthed.value {
            self.refresh()
        } else {
            Twitterer.isAuthed.asObservable().subscribe(onNext: { value in
                if value {
                    self.refresh()
                }
            }).addDisposableTo(db)
        }
    }
    
    var tweetsObservable = Twitterer.timeline
    
    func setupRx() {
        Twitterer.isLoadingMoreData.asObservable().subscribe(onNext: { value in
            if value {
                self.refreshControl?.beginRefreshing()
            } else {
                self.refreshControl?.endRefreshing()
            }
        }).addDisposableTo(db)
    
        let thing = tweetsObservable.asObservable().bindTo(tableView.rx.items(cellIdentifier: "cell"))
        thing { (row,tweet,cell) in
            let cell = cell as! TweetCell
            cell.configure(for: tweet)
            cell.goToProfileForUser = { [unowned self] user in
                self.goToProfileForUser(user)
            }
        }.addDisposableTo(db)
        
        tableView.rx.setDelegate(self).addDisposableTo(db)
        
    }
    let db = DisposeBag()
    
    var goToProfileForUser: ((User) -> ())!
    
    func setupTableView() {
        let nib = UINib(nibName: "TweetCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.insertSubview(refreshControl!, at: 0)
        
        refreshControl?.rx.controlEvent(.valueChanged).asObservable().subscribe(onNext: { _ in
            self.refreshControl?.beginRefreshing()
            self.refresh()
        }).addDisposableTo(db)
    }
  
}
