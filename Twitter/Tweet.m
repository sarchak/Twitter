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
        self.id_str = dictionary[@"id_str"];
        self.favorited = [[dictionary objectForKey:@"favorited"] boolValue];
        self.retweeted = [[dictionary objectForKey:@"retweeted"] boolValue];
        
        NSDictionary* tempdictionary = nil;
        if(dictionary[@"retweeted_status"]!=nil){
            self.retweetedBy = [[User alloc] initWithDictionary:dictionary[@"user"]];
            tempdictionary = dictionary[@"retweeted_status"];
        } else {
            tempdictionary = dictionary;
        }
        
        self.text = tempdictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:tempdictionary[@"user"]];
        NSString *createdAtString = tempdictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.retweetCount = [[tempdictionary objectForKey:@"retweet_count"] integerValue];
        self.favoritesCount = [[tempdictionary objectForKey:@"favorite_count"] integerValue];
        NSLog(@"Favorites count :%ld", self.favoritesCount);
        NSArray *currentMedia = [tempdictionary valueForKeyPath:@"entities.media"];
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
