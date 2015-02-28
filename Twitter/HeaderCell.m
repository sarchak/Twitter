//
//  HeaderCell.m
//  Twitter
//
//  Created by Shrikar Archak on 2/27/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

- (void)awakeFromNib {
    // Initialization code
    self.info.preferredMaxLayoutWidth =  self.info.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

@end
