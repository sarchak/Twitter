//
//  PhotoCell.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "PhotoCell.h"
#import "TTTAttributedLabel.h"
@implementation PhotoCell

- (void)awakeFromNib {
    self.tweetLabel.preferredMaxLayoutWidth =  self.tweetLabel.frame.size.width;
    self.userImageView.layer.cornerRadius = 5.0;
    self.mediaImageView.layer.cornerRadius = 5.0;
    self.retweetedLabel.hidden = YES;
    self.retweet.hidden = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.mediaImageView addGestureRecognizer:tapGesture];
    self.tweetLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}


-(void) handleSingleTap:(id)imageView {
    [self.delegate photoCell:self imageTapped:imageView];
}

- (IBAction)reply:(id)sender {
    [self.delegate photoCell:self reply:sender];
}
- (IBAction)retweet:(id)sender {
    [self.delegate photoCell:self retweet:sender];
}
- (IBAction)favorite:(id)sender {
    [self.delegate photoCell:self favorite:sender];
}



@end
