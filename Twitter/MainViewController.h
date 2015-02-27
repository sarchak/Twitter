//
//  MainViewController.h
//  Twitter
//
//  Created by Shrikar Archak on 2/26/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideMenuViewController.h"

extern NSString *const MenuOpened;
extern NSString *const MenuClosed;
@class MainViewController;

@interface MainViewController : UIViewController <SideMenuViewControllerDelegate>

@property (strong,nonatomic) NSArray *viewControllers;
@property (strong,nonatomic) UIViewController *currentViewController;

@end
