//
//  TwitterClient.h
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+ (TwitterClient*) sharedInstance ;
- (void) openUrl:(NSURL*) url;
- (void) loginWithCompletion:(void (^)(User *user, NSError *error))completion;

-(void)homeTimelineWithParams:(NSDictionary*) params completion:(void (^)(NSArray *tweets, NSError *error))completion;
@end
