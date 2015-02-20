//
//  DetailViewController.h
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface DetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) Tweet *tweet;
@end
