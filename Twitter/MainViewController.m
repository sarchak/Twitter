//
//  MainViewController.m
//  Twitter
//
//  Created by Shrikar Archak on 2/26/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "MainViewController.h"
#import "SideMenuViewController.h"
#import "POP/POP.h"
#import "ProfileViewController.h"
#import "TweetsViewController.h"

NSString *const MenuOpened = @"MenuOpened";
NSString *const MenuClosed = @"MenuClosed";

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (assign, nonatomic) BOOL menuOpen;
@property (assign, nonatomic) NSInteger currIndex;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currIndex = 0;
    self.currentViewController = self.viewControllers[self.currIndex];
    [self addChildViewController:self.currentViewController];
    [self.contentView addSubview:self.currentViewController.view];
    [self.currentViewController didMoveToParentViewController:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.menuOpen = NO;
//    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleDone target:self action:@selector(menu)];
    self.title = @"Twitter";
    
}
-(void) menu {
    
    if(self.menuOpen ) {
        [self closeMenu];
        [self reset: self.currIndex];
        
        NSLog(@"Menu notification close");
        [[NSNotificationCenter defaultCenter] postNotificationName:MenuClosed object:nil];
    } else {
        
        CGFloat xoffset = self.contentView.frame.size.width - 50;
        [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.3 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            self.currentViewController.view.frame = CGRectMake(xoffset, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        } completion:^(BOOL finished) {
            CGRect newframe = CGRectMake(0, 0, xoffset, self.contentView.frame.size.height);
            SideMenuViewController *svc = [[SideMenuViewController alloc] init];
            
            svc.delegate = self;
            svc.view.frame = newframe;
            self.currentViewController = svc;
            [self addChildViewController:svc];
            [self.view addSubview:svc.view];
            [svc didMoveToParentViewController:self];
            
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:MenuOpened object:nil];
        NSLog(@"Menu notification open");
    }
    self.menuOpen = !self.menuOpen;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


-(void) closeMenu {
//    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self.currentViewController removeFromParentViewController];
//        [self.currentViewController.view removeFromSuperview];
//    } completion:^(BOOL finished) {
//        self.contentView.bounds = self.view.bounds;
//        self.contentView.frame = self.view.bounds;
//    }];
    [self.currentViewController removeFromParentViewController];
    [self.currentViewController.view removeFromSuperview];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.contentView.bounds = self.view.bounds;
        self.contentView.frame = self.view.bounds;

    } completion:^(BOOL finished) {
        
    }];

    
}



-(void) reset: (NSInteger) index {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.currentViewController = self.viewControllers[index];
        [self addChildViewController:self.currentViewController];
        [self.contentView addSubview:self.currentViewController.view];
        [self.currentViewController didMoveToParentViewController:self];
        self.currentViewController.view.frame = self.contentView.frame;
        self.currentViewController.view.bounds = self.contentView.bounds;

    } completion:^(BOOL finished) {

    }];
    
    
    
}

-(void)sideMenuViewController:(SideMenuViewController *)sideMenuController didSelectIndexPath:(NSInteger)index {

    [self closeMenu];
    [self reset:index];
    self.menuOpen = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuClosed object:nil];
    self.currIndex = index;
    

    [self.currentViewController removeFromParentViewController];
    [self.currentViewController.view removeFromSuperview];
    self.currentViewController = self.viewControllers[index];
    
    [self addChildViewController:self.currentViewController];
    [self.contentView addSubview:self.currentViewController.view];
    [self.currentViewController didMoveToParentViewController:self];

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.currentViewController.view.frame = self.contentView.frame;
    } completion:^(BOOL finished) {

    }];


//
}
- (IBAction)viewPanned:(UIPanGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded){
        [self menu];
    }
    
}
@end
