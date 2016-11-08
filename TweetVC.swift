import UIKit
import RxSwift

class TweetVC: UIViewController {
    var tweet: Tweet!
    
    var tweetView: TweetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tweetView = Bundle.main.loadNibNamed("TweetView", owner: self, options: nil)!.first! as! TweetView
        
        view.addSubview(tweetView)
        tweetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tweetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tweetView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            tweetView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        tweetView.profileImageView.af_setImage(withURL: URL(string: tweet.profileImageURL)!)
        tweetView.profileImageView.setupLayer()
        tweetView.nameLabel.text = tweet.tweeter
        tweetView.handleLabel.text = tweet.handle
        tweetView.dateLabel.text = tweet.timeTweeted
        tweetView.tweetBodyLabel.text = tweet.text
        
        tweetView.retweetsLabel.text = String(tweet.retweetCount!)
        if tweet.retweeted! {
            tweetView.retweetButton.setTitle("Retweeted", for: UIControlState())
            tweetView.retweetButton.setTitleColor(.red, for: UIControlState())
        }
        tweetView.retweetButton.rx.tap.subscribe(onNext: {
            if self.tweet.retweeted! {
                Twitterer.unretweet(tweet: self.tweet)
                self.tweet.retweetCount! -= 1
                self.tweetView.retweetButton.setTitle("Retweet", for: UIControlState())
                self.tweetView.retweetButton.setTitleColor(self.tweetView.dateLabel.textColor, for: UIControlState())
            } else {
                Twitterer.post(retweet: self.tweet)
                self.tweet.retweetCount! += 1
                self.tweetView.retweetButton.setTitle("Retweeted", for: UIControlState())
                self.tweetView.retweetButton.setTitleColor(.red, for: UIControlState())
            }
            self.tweetView.retweetsLabel.text = String(self.tweet.retweetCount!)
            self.tweet.retweeted = !self.tweet.retweeted
        }).addDisposableTo(db)
        
        tweetView.favoritesLabel.text = String(tweet.favoriteCount!)
        if tweet.favorited! {
            tweetView.starButton.setTitle("Liked", for: UIControlState())
            tweetView.starButton.setTitleColor(.red, for: UIControlState())
        }
        tweetView.starButton.rx.tap.subscribe(onNext: {
            if self.tweet.favorited! {
                Twitterer.unfavorite(tweet: self.tweet)
                self.tweet.favoriteCount! -= 1
                self.tweetView.starButton.setTitle("Like", for: UIControlState())
                self.tweetView.starButton.setTitleColor(self.tweetView.dateLabel.textColor, for: UIControlState())
            } else {
                Twitterer.post(favorite: self.tweet)
                self.tweet.favoriteCount! += 1
                self.tweetView.starButton.setTitle("Liked", for: UIControlState())
                self.tweetView.starButton.setTitleColor(.red, for: UIControlState())
            }
            self.tweetView.favoritesLabel.text = String(self.tweet.favoriteCount!)
            self.tweet.favorited = !self.tweet.favorited
        }).addDisposableTo(db)
    }
    let db = DisposeBag()
}
