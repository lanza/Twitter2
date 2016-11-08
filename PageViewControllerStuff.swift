import UIKit

class NameAndHandleVC: UIViewController {
   
    let nameLabel = UILabel()
    let handleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(nameLabel)
        view.addSubview(handleLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        handleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            handleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            handleLabel.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
      
}

class DescriptionVC: UIViewController {
    let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 9)
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 39)
        ])
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
    }
    
}

