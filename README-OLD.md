# Project 3 - *Twitter*

**Twitter** is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

Time spent: **25** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [ ] When composing, you should have a countdown in the upper right for the tweet limit.
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [ ] Retweeting and favoriting should increment the retweet and favorite count.
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [ ] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:

 Once again, my interests are implementation based and not UX/UI based so I focused on writing stronger code and using new frameworks.
- [x] OAuthSwift is used instead of BDBOAuthManager to experience a more modern Swifty framework.
- [x] OAuthSwiftAlamofire is used on top of OAuthSwift to enable the `oauth1` authorization to be injected into Alamofire's framework.
- [x] Moya is used on top of Alamofire. Moya is a typesafe wrapper around Alamofire that eliminates potential error at the networking callsite and isolates them into the data transformation functions and/or the Moya `TargetType` implementation.
- [x] Coordinator framework from last week has been further refined and has had bugs fixed. Also, out of curiosity and for the sake of learning, I pushed it to Cocoapods as [CoordinatorKit](https://cocoapods.org/pods/CoordinatorKit). I plan on using it in all my forthcoming projects and hope to make it somewhat useufl.
- [x] RxSwift is used to observe various tasks that occur asynchronously. Tasks such as waiting for authorization to return. Instead of simply embedding subsequent calls within the first calls completion handler, you set an Rx observer in order to be triggered.
- [x] RxCocoa was used to implement the UITableView.
- [x] Completely programmatic UI and NSLayoutConstraints.
- [x] SwiftyJSON used for JSON conversion.

**Discuss Further With Your Peers**

1. Twitter errors. Their documentation is pretty poor and solving some problems you could run into takes a small miracle.
2. The networking framework Moya and other frameworks like it, if anybody has good opinions. Moya is a wrapper around Alamofire that puts all the non-typesafe content in one enum which allows the callsite to be completely typesafe and thus isolates any mistakes you could have made to the enum.

## Video Walkthrough

<img src='Twitter.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

## Notes

###### Challenges

This project was a nightmare. Luckily, I learned a ton about networking (HTTP, oauth, a variety of frameworks (including OAuthSwift, Alamofire, Moya), experience going into various cocoapods source code to see what is going wrong and how to understand much more complex code than I write, and some more experience working on RxSwift/Cocoa and my own microframework CoordinatorKit.

I decided I didn't want to just use a cocoapod that I could import and have handle `oauth` for me, so I went about learning it. First off, I didn't know how the HTTP protocol worked. So I went and downloaded a networking book for Python and read the first half to learn how HTTP worked.

From there I tried going about implementing the `oauth` dance without any helper frameworks. Well, Twitter's documentation is truly atrocious. There's one pair of documents that say "click here for this step" which takes you to a page that similarly says "click here to do this" which redirects back to the first. Nonetheless, I eventually figured out all the steps and was going about it just fine but ran into reoccurring bugs that I grew tired of tracking.

Ultimately, I chose to use OAuthSwift which optionally supplies an adapter to Alamofire which will handle the authorization and then hand of the API call duty to Alamofire. On top of this, I chose to use Moya as it is a very elegant framework that wraps around Alamofire and provides type-safety to API calls. I'm really a fan of this framework and plan to use it regularly going forward.

Here's where things got really fun. OAuthSwift's Alamofire adapter is bugged and doesn't provide the authentication details correctly when attempting POST calls. Making the call from OAuthSwift's interface works fine, but using the Alamofire adapter fails. To further exasperate things, I also had Moya on top that I had to evaluate before isolating the cause of the error.

So I spent a good six or so hours tracing through Moya, Alamofire, OAuthSwiftAlamofire, OAuthSwift and even URLSession to isolate the issue. The six hours is half my fault as a typo caused an error to come up that was erroneous.

The error is currently an unsolved issue on OAuthSwiftAlamofire's github repository.

UI took a huge backseat to merely finishing the required user stories this time around.

## License

    Copyright [2016] [Nathan Lanza]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
