//
//  LoginViewController.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "SideMenuViewController.h"
#import "MainViewController.h"
#import "ProfileViewController.h"
#import "AccountsViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)OnLogin:(id)sender {
    
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
       
        NSLog(@"In login view controller : %@", user.name);
        if(user != nil){
            TweetsViewController *tvc = [[TweetsViewController alloc] init];

            MainViewController *mvc = [[MainViewController alloc] init];
            ProfileViewController *pvc = [[ProfileViewController alloc] init];
            pvc.user = user;

            TweetsViewController *mentionsvc = [[TweetsViewController alloc] init];
            mentionsvc.mentionsTimeLine = YES;
            mvc.viewControllers = @[tvc,pvc,mentionsvc];
            
            UINavigationController *snvc = [[UINavigationController alloc] initWithRootViewController:mvc];
            
            [self presentViewController:snvc animated:YES completion:nil];
        } else {
            
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
