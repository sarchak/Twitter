//
//  User.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"


NSString *const UserDidLoginNotification = @"UserDidLoginNotification";
NSString *const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()

@property (nonatomic,strong) NSDictionary *dictionary;
@end

@implementation User

-(id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
    }
    return self;
}

+(void) logOut {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

static User *_currentUser = nil;
NSString * const kCurrentUser = @"kCurrentUser";
+(User*) currentUser {
    if(_currentUser == nil){
       NSData *data =  [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUser];
        if(data != nil){
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+(void) setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    if(_currentUser != nil){
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUser];
    }
}
@end
