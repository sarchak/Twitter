//
//  SideMenuViewController.h
//  Twitter
//
//  Created by Shrikar Archak on 2/26/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SideMenuViewController;

@protocol SideMenuViewControllerDelegate <NSObject>

-(void)sideMenuViewController:(SideMenuViewController*) sideMenuController didSelectIndexPath:(NSInteger)index;

@end

@interface SideMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) id<SideMenuViewControllerDelegate> delegate;
@end
