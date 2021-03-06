//
//  Media.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "Media.h"

@implementation Media


-(Media*) initWithDictionary:(NSArray *)arrays {
    self = [super init];
    
    NSDictionary *dictionary = arrays[0];
    self.mediaUrl = dictionary[@"media_url"];
    
    NSDictionary *variant = [dictionary valueForKeyPath:@"video_info.variants"][0];
    self.videoUrl = variant[@"url"];
    if(self.videoUrl != nil){
        self.type = Video;
    } else {
        self.type = Photo;
    }
    return self;
}

@end
