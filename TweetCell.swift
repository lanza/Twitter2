import UIKit
import RxSwift

class TweetCell: UITableViewCell {
    @IBOutlet weak var retweetLabelHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var profileImageTGR: UITapGestureRecognizer!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageTGR = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        profileImageView.addGestureRecognizer(profileImageTGR)
        profileImageView.isUserInteractionEnabled = true
    }
    
    func imageTapped(_ tgr: UITapGestureRecognizer) {
        let user = User(tweet: tweet)
        goToProfileForUser(user)
    }
    
    var goToProfileForUser: ((User) -> ())!
    
    var tweet: Tweet!
    
    func configure(for tweet: Tweet) {
        self.tweet = tweet
        var tweet = tweet
        if let retweetedTweet = tweet.retweetedTweet {
            retweetLabelHeightConstraint.constant = 16
            retweetedLabel.text = "\(tweet.tweeter!) retweeted"
            self.tweet = retweetedTweet
            tweet = retweetedTweet
        } else if let replyScreenName = tweet.inReplyToScreenName {
            retweetLabelHeightConstraint.constant = 16
            retweetedLabel.text = "In reply to \(replyScreenName)"
        } else {
            retweetedLabel.text = ""
            retweetLabelHeightConstraint.constant = 0
        }
        profileImageView.af_setImage(withURL: URL(string: tweet.profileImageURL)!)
        profileImageView.setupLayer()
        nameLabel.text = tweet.tweeter
        handleLabel.text = tweet.handle
        dateLabel.text = tweet.timeTweeted
        tweetBodyLabel.text = tweet.text
        
        likeCount.text = String(tweet.favoriteCount!)
        if tweet.favorited! {
            likeButton.setTitleColor(.red, for: UIControlState())
            likeButton.setTitle("Liked", for: UIControlState())
        } else {
            likeButton.setTitleColor(dateLabel.textColor, for: UIControlState())
            likeButton.setTitle("Like", for: UIControlState())
        }
        likeButton.rx.tap.subscribe(onNext: {
            if tweet.favorited! {
                Twitterer.unfavorite(tweet: tweet)
                tweet.favoriteCount! -= 1
                self.likeButton.setTitle("Like", for: UIControlState())
                self.likeButton.setTitleColor(self.dateLabel.textColor, for: UIControlState())
            } else {
                Twitterer.post(favorite: tweet)
                tweet.favoriteCount! += 1
                self.likeButton.setTitle("Liked", for: UIControlState())
                self.likeButton.setTitleColor(.red, for: UIControlState())
            }
            self.likeCount.text = String(tweet.favoriteCount!)
            tweet.favorited = !tweet.favorited
        }).addDisposableTo(db)
        
        retweetCount.text = String(tweet.retweetCount!)
        if tweet.retweeted! {
            retweetButton.setTitleColor(.red, for: UIControlState())
            retweetButton.setTitle("Retweeted", for: UIControlState())
        } else {
            retweetButton.setTitleColor(dateLabel.textColor, for: UIControlState())
            retweetButton.setTitle("Retweet", for: UIControlState())
        }
        retweetButton.rx.tap.subscribe(onNext: {
            if tweet.retweeted! {
                Twitterer.unretweet(tweet: tweet)
                tweet.retweetCount! -= 1
                self.retweetButton.setTitle("Retweet", for: UIControlState())
                self.retweetButton.setTitleColor(self.dateLabel.textColor, for: UIControlState())
            } else {
                Twitterer.post(retweet: tweet)
                tweet.retweetCount! += 1
                self.retweetButton.setTitleColor(.red, for: UIControlState())
                self.retweetButton.setTitle("Retweeted", for: UIControlState())
            }
            self.retweetCount.text = String(tweet.retweetCount!)
            tweet.retweeted = !tweet.retweeted
        }).addDisposableTo(db)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        db = DisposeBag()
    }
    var db = DisposeBag()
}
