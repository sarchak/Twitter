//
//  TwitterClient.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString *const twitterConsumerKey = @"Y6slPsZehRLPprJPddoyB20OL";
NSString *const twitterConsumerSecret = @"46hsFGdw4Fy9zRtVCRM2D1Yz7fMXeLXXemNumNDBbsrW42I3zo";
NSString *const baseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic,strong) void (^loginCompletion)(User *user, NSError *error);
@end

@implementation TwitterClient

+ (TwitterClient*) sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil){
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl] consumerKey:twitterConsumerKey  consumerSecret:twitterConsumerSecret];
        }
    });

    return instance;
}

-(void) loginWithCompletion:(void (^)(User *, NSError *))completion {
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got request token");
        
        NSURL *authUrl = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",requestToken.token]];
        [[UIApplication sharedApplication] openURL:authUrl];
    } failure:^(NSError *error) {
        self.loginCompletion(nil,error);
    }];
}

-(void) openUrl:(NSURL *)url {
    [[TwitterClient sharedInstance] fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
            [self.requestSerializer saveAccessToken:accessToken];
            [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                User *user = [[User alloc] initWithDictionary:responseObject];
                NSLog(@"User name : %@", user.name);
                [User setCurrentUser:user];
                self.loginCompletion(user,nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failure");
            }];

        } failure:^(NSError *error) {
            NSLog(@"Failed to get access token");
            self.loginCompletion(nil,error);
        }];
}

-(void)homeTimelineWithParams:(NSDictionary*) params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    
        NSLog(@"%@", params);
        [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *tweets = [Tweet tweetsFromArray:responseObject];
            completion(tweets, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(nil,error);
            NSLog(@"Failed to fetch timeline %@" , error);
        }];
}

-(void)userTimelineWithParams:(NSDictionary*) params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    
    NSLog(@"%@", params);
    [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsFromArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
        NSLog(@"Failed to fetch timeline %@" , error);
    }];
}

-(void)mentionsTimelineWithParams:(NSDictionary*) params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    
    NSLog(@"%@", params);
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsFromArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
        NSLog(@"Failed to fetch timeline %@" , error);
    }];
}


-(void)favoriteWithParams:(NSDictionary*) params completion:(void (^)(NSError *error))completion {
    
    NSLog(@"%@", params);
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
        NSLog(@"Failed to favorite %@" , error);
    }];
}

-(void)unFavoriteWithParams:(NSDictionary*) params completion:(void (^)(NSError *error))completion {
    
    NSLog(@"%@", params);
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
        NSLog(@"Failed to favorite %@" , error);
    }];
}

-(void)retweetWithParams:(NSDictionary*) params completion:(void (^)(NSError *error))completion {
    
    NSLog(@"%@", params);
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", params[@"id"]];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
        NSLog(@"Failed to favorite %@" , error);
    }];
}


-(void) tweetWithParams:(NSDictionary*) params completion:(void (^)(Tweet *tweet, NSError *error)) completion {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
        NSLog(@"Failed to tweet %@" , error);
    }];
    
}


@end
