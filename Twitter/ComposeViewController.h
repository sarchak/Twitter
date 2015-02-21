//
//  ComposeViewController.h
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class ComposeViewController;

@protocol ComposeViewControllerDelegate <NSObject>

-(void) composeViewController: (ComposeViewController*) composeViewController tweet:(Tweet*) tweet;

@end
@interface ComposeViewController : UIViewController <UITextViewDelegate>
@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSString* in_reply_to_status_id;
@property (nonatomic,weak) id<ComposeViewControllerDelegate> delegate;
@end
