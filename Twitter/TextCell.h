//
//  TextCell.h
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
@class TextCell;

@protocol TextCellDelegate <NSObject>
-(void) textCell:(TextCell*) textCell  favorite: (UIButton*) button;
-(void) textCell:(TextCell*) textCell  retweet: (UIButton*) button;
-(void) textCell:(TextCell*) textCell  reply: (UIButton*) button;
@end


@interface TextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *rcount;
@property (weak, nonatomic) IBOutlet UILabel *fcount;
@property (weak, nonatomic) IBOutlet UIImageView *retweet;

@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) id<TextCellDelegate> delegate;
@end
