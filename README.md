Twitter app with hamburger menu

Time spent: 20hrs

![Video Walkthrough](twitter_hamburger.gif)

   - [x] Hamburger menu
      - [x] Dragging anywhere in the view should reveal the menu.
      - [x] The menu should include links to your profile, the home timeline, and the mentions view.
      [x] The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.
      
   [x] Profile page
      [x] Contains the user header view
      [x] Contains a section with the users basic stats: # tweets, # following, # followers

   [x] Optional: Implement the paging view for the user description.
      [x] Optional: As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
      [x] Optional: Pulling down the profile page should blur and resize the header image.
   
   [x] Home Timeline
      [x] Tapping on a user image should bring up that user's profile page
   
   []Optional: Account switching
      [] Long press on tab bar to bring up Account view with animation
      [] Tap account to switch to
      [] Include a plus button to Add an Account
      [] Swipe to delete an account


This is a basic twitter app to read and compose tweets the Twitter API.

Time spent: 30hrs

![Video Walkthrough](twitter_latest.gif)

###Features
####Required

   * User can sign in using OAuth login flow - **Completed**
   * User can view last 20 tweets from their home timeline - **Completed**
   * The current signed in user will be persisted across restarts - **Completed**
   * In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes. - **Completed**
   * User can pull to refresh - **Completed**
   * User can compose a new tweet by tapping on a compose button. - **Completed**
   * User can tap on a tweet to view it, with controls to retweet, favorite, and reply. - **Completed**
   * User can retweet, favorite, and reply to the tweet directly from the timeline feed. - **Completed**

####Optional

   * When composing, you should have a countdown in the upper right for the tweet limit. - **Completed**
   * After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network. - **Completed**
   * Retweeting and favoriting should increment the retweet and favorite count. - **Completed**
   * User should be able to unretweet and unfavorite and should decrement the retweet and favorite count. - **Completed**
   * Replies should be prefixed with the username and the reply_id should be set when posting the tweet - **Completed**
   * User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client. - **Completed**
   

###Cocoapods used 
   * pod 'SVPullToRefresh'
   * pod 'SVProgressHUD', '~> 1.1'
   * pod 'AFNetworking'
   * pod 'DateTools'
   * pod 'pop', '~> 1.0'
   * pod 'TTTAttributedLabel'
   *pod 'BDBOAuth1Manager', '~> 1.5'
