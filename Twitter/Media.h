//
//  Media.h
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import <Foundation/Foundation.h>

enum MediaType {
    Photo,
    Video
};

@interface Media : NSObject
@property (strong, nonatomic) NSString * mediaUrl;
@property (strong, nonatomic) NSString * videoUrl;
@property (assign, nonatomic) enum MediaType type;

-(Media*) initWithDictionary:(NSArray*) dictionary;
@end
