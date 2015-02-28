//
//  TextCell.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "TextCell.h"

@implementation TextCell

- (void)awakeFromNib {
    // Initialization code
//    self.tweetLabel.preferredMaxLayoutWidth =  self.tweetLabel.frame.size.width;
    self.userImageView.layer.cornerRadius = 5.0;
    self.tweetLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.userImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    [self.userImageView addGestureRecognizer:gesture];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth =  self.tweetLabel.frame.size.width;
}

-(void) imageTapped {
    NSLog(@"Image tapped");
    [self.delegate textCell:self userProfileTapped:nil];
}

- (IBAction)reply:(id)sender {
    [self.delegate textCell:self reply:sender];
}
- (IBAction)retweet:(id)sender {
    [self.delegate textCell:self retweet:sender];
}
- (IBAction)favorite:(id)sender {
    [self.delegate textCell:self favorite:sender];
}

@end
