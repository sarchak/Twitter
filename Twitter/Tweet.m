//
//  Tweet.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
@implementation Tweet

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.retweetCount = [[dictionary objectForKey:@"retweet_count"] integerValue];
        self.favoritesCount = [[dictionary objectForKey:@"favorites_count"] integerValue];
        NSArray *currentMedia = [dictionary valueForKeyPath:@"entities.media"];
        if(currentMedia != nil){
            self.media = [[Media alloc] initWithDictionary:currentMedia];
        }
    }
    return self;
}

+(NSArray *) tweetsFromArray:(NSArray*) dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for(NSDictionary *dictionary in dictionaries){
        
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];


    }
    return tweets;
}

@end
