//
//  PhotoCell.h
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TTTAttributedLabel.h"
@class PhotoCell;

@protocol PhotoCellDelegate <NSObject>
-(void) photoCell:(PhotoCell*) photoCell  favorite: (UIButton*) button;
-(void) photoCell:(PhotoCell*) photoCell  retweet: (UIButton*) button;
-(void) photoCell:(PhotoCell*) photoCell  reply: (UIButton*) button;
-(void) photoCell:(PhotoCell*) photoCell  imageTapped: (UIImageView*) imageView;
@end

@interface PhotoCell : UITableViewCell <TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UILabel *rcount;
@property (weak, nonatomic) IBOutlet UILabel *fcount;
@property (weak, nonatomic) IBOutlet UIImageView *retweet;

@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak,nonatomic) id<PhotoCellDelegate> delegate;
@end
