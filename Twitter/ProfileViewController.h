//
//  ProfileViewController.h
//  Twitter
//
//  Created by Shrikar Archak on 2/27/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) Tweet *tweet;
@end
