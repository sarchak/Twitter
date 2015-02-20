//
//  PhotoCell.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib {
    self.tweetLabel.preferredMaxLayoutWidth =  self.tweetLabel.frame.size.width;
    self.userImageView.layer.cornerRadius = 5.0;
    self.mediaImageView.layer.cornerRadius = 5.0;
    self.retweetedLabel.hidden = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end