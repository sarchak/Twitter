//
//  TweetsViewController.h
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCell.h"
#import "TextCell.h"
#import "ComposeViewController.h"

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PhotoCellDelegate, TextCellDelegate, ComposeViewControllerDelegate,TTTAttributedLabelDelegate>
@property (assign, nonatomic) BOOL mentionsTimeLine;
@end
