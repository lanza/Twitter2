# Project 4 - *Twitter*

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Hamburger menu
   - [x] Dragging anywhere in the view should reveal the menu.
   - [x] The menu should include links to your profile, the home timeline, and the mentions view.
   - [x] The menu can look similar to the example or feel free to take liberty with the UI.
- [x] Profile page
   - [x] Contains the user header view
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline
   - [x] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [x] Profile Page
   - [x] Implement the paging view for the user description.
   - [x] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [x] Pulling down the profile page should blur and resize the header image.
- [x] Account switching
   - [x] Long press on tab bar to bring up Account view with animation
   - [x] Tap account to switch to
   - [x] Include a plus button to Add an Account
   - [x] Swipe to delete an account
- [x] Optional features from last week
  - [x] When composing, you should have a countdown in the upper right for the tweet limit.
  - [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
  - [x] Retweeting and favoriting should increment the retweet and favorite count.
  - [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
  - [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
  - [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

##### Additional features ######
###### UI/UX features ######
- [x] You can reply/retweet/like posts from the main VC.

###### Codebase features ######
- [x] `HamburgerController` implemented 100% programmatically.
- [x] `HamburgerController` is easily reusable. You can pick it up and plug it into any other project with about ten lines of code.
- [x] Extended my coordinator framework to now include a `HamburgerCoordinator` which perfectly works into the coordinator pattern.
- [x] Used container view controllers for the paging view in the profileVC.
- [x] Worked with author of OAuthSwift to fix the bug from the previous assignment. Turns out the encoding of the authorization information wasn't handled properly during the handoff from OAuthSwift and Alamofire.
- [x] Features a full Moya implementation now that the aforementioned bug has been worked out.
- [x] Continued development of my framework CoordinatorKit. The API is starting to resemble that of `UIViewController`, but with the child property being `viewController` instead of `view`.
- [x] Further expansion of usage of RxSwift/Cocoa.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

  1.
  2.


## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='Twitter.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

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
