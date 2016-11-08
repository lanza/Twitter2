import CoordinatorKit
import RxSwift
import RxCocoa
import SwiftyJSON
import AlamofireImage

class MainCoordinator: HamburgerCoordinator {

    override func viewControllerDidLoad() {
        super.viewControllerDidLoad()
        
        Twitterer.getLastUser()
        Twitterer.isAuthed.asObservable().subscribe(onNext: { value in
            if value {
                Twitterer.getUser()
            }
        }).addDisposableTo(db)
        
        setupTheme()
        
        let tc = TweetsCoordinator()
        tc.start()
        tc.viewController.title = "Home"
        let tcNav = NavigationCoordinator(rootCoordinator: tc)
       
        let pc = ProfileCoordinator()
        pc.start()
        pc.viewController.title = "Profile"
        let pcNav = NavigationCoordinator(rootCoordinator: pc)
        
        let mc = MentionsCoordinator()
        mc.start()
        mc.viewController.title = "Mentions"
        let mcNav = NavigationCoordinator(rootCoordinator: mc)
        
        setCoordinators([tcNav,mcNav,pcNav], animated: false)
        
        hamburgerController.grRec = {
            let uc = UsersCoordinator()
            let ucNav = NavigationCoordinator(rootCoordinator: uc)
            uc.viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.close))
           
            uc.usersVC.done = {
                self.dismiss(animated: true)
            }
            self.present(ucNav, animated: true)
        }
    }
    func setupTheme() {
        let nca = UINavigationBar.appearance()
        nca.barStyle = .black
        nca.tintColor = .white
        nca.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        hamburgerController.tableView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    let titles = ["Home","Mentions","Me"]
    override func titleFor(row: Int) -> String {
        return titles[row]
    }
    
    
    let db = DisposeBag()
}

class UsersCoordinator: Coordinator {
    var usersVC: UsersVC { return viewController as! UsersVC }
    override func loadViewController() {
        viewController = UsersVC()
    }
}

class UsersVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = UserDefaults.standard.value(forKey: "credentials") as? [[String:String]] ?? [[String:String]]()
    }
    var users: [[String:String]]!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.textAlignment = .center
        if indexPath.row == 0 {
            cell.textLabel?.text = "Add Twitter Account"
        } else {
            cell.textLabel?.text = users[indexPath.row - 1]["name"]!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height - (navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height) / CGFloat(users.count + 1)
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            Twitterer.auth()
        } else {
            Twitterer.oAuthSwift.client.credential.oauthToken = users[indexPath.row - 1]["token"]!
            Twitterer.oAuthSwift.client.credential.oauthTokenSecret = users[indexPath.row - 1]["secret"]!
            Twitterer.getUser()
        }
        done()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 ? false : true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { fatalError() }
        
        if User.active!.name == users[indexPath.row - 1]["name"]! {
            navigationItem.rightBarButtonItem = nil
        }
        users.remove(at: indexPath.row - 1)
        UserDefaults.standard.set(users, forKey: "credentials")
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    var done: (() -> ())!
    
    
}



