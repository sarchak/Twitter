//
//  AppDelegate.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TweetsViewController.h"
#import "SideMenuViewController.h"
#import "MainViewController.h"
#import "Chameleon.h"
#import "ProfileViewController.h"
#import "AccountsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LoginViewController *lvc = [[LoginViewController alloc] init];
    TweetsViewController *tvc = [[TweetsViewController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotification object:nil];

    
    SideMenuViewController *svc = [[SideMenuViewController alloc] init];
    MainViewController *mvc = [[MainViewController alloc] init];
    svc.delegate = mvc;
    

    
    if ([User currentUser] != nil){
        ProfileViewController *pvc = [[ProfileViewController alloc] init];
        pvc.user = [User currentUser];
        [pvc.view layoutIfNeeded];
        [pvc.view setNeedsDisplay];
        TweetsViewController *mentionsvc = [[TweetsViewController alloc] init];
        mentionsvc.mentionsTimeLine = YES;
        mvc.viewControllers = @[tvc,pvc,mentionsvc];
    } else {
        mvc.viewControllers = @[lvc,svc];
    }

    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBarTintColor:[UIColor colorWithRed:85.0/255 green:172.0/255 blue:238.0/255 alpha:1.0]];
    [navBar setBarTintColor:[UIColor flatSkyBlueColor]];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [navBar setTintColor:[UIColor whiteColor]];

    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mvc];
    

    [self.window makeKeyAndVisible];
    return YES;
}

-(void) userDidLogout {
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.window.rootViewController= [[LoginViewController alloc] init];
    } completion:nil];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [[TwitterClient sharedInstance] openUrl:url];
    return YES;
}
@end
