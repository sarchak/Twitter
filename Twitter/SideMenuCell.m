//
//  SideMenuCell.m
//  Twitter
//
//  Created by Shrikar Archak on 2/26/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//


#import "SideMenuCell.h"
#import "POP/POP.h"
#import "Chameleon.h"

@implementation SideMenuCell

- (void)awakeFromNib {
    // Initialization code

    self.backgroundColor =  [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight
                                                       withFrame:self.frame
                                                       andColors:@[[UIColor flatBlueColor],[UIColor flatSkyBlueColor]]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.2;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        [self.sideLabel pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
        [self.iconImageView pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
        
        
    } else {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.2)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        sprintAnimation.springBounciness = 1.f;
        [self.sideLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
        [self.iconImageView pop_addAnimation:sprintAnimation forKey:@"scalingUp"];
    }
}
@end
