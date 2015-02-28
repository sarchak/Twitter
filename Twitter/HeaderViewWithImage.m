//
//  HeaderViewWithImage.m
//  Twitter
//
//  Created by Shrikar Archak on 2/28/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "HeaderViewWithImage.h"

@implementation HeaderViewWithImage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}


@end
