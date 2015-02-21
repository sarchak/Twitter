//
//  ComposeViewController.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (nonatomic,strong) UIBarButtonItem *count;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *inputText;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /* Setup the user info */
    User *user = [User currentUser];
    self.screenName.text = [NSString stringWithFormat:@"@%@", user.screenName];
    NSString *biggerImageUrl = [user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:biggerImageUrl]];
    self.profileImageView.layer.cornerRadius = 5.0;
    self.name.text = user.name;


    self.inputText.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancel)];
    
    NSString *count = [NSString stringWithFormat:@"%ld", 140 - self.text.length];
    [self.inputText setSelectedRange:NSMakeRange(0, self.text.length)];
    self.count = [[UIBarButtonItem alloc] initWithTitle:count style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *tweet = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(tweet)];
    self.navigationItem.rightBarButtonItems = @[tweet, self.count];
    [self.inputText setText:self.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) tweet{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.inputText.text forKey:@"status"];
    if(self.in_reply_to_status_id != nil){
        [dictionary setObject:self.in_reply_to_status_id forKey:@"in_reply_to_status_id"];
    }
    [[TwitterClient sharedInstance] tweetWithParams:dictionary completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"Tweet successful");
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate composeViewController:self tweet:tweet];
        }];
    }];
}


-(void) textViewDidChange:(UITextView *)textView{
    NSInteger number = 140 - textView.text.length;
    
    [UIView setAnimationsEnabled:NO];
    [self.count setTitle:[NSString stringWithFormat:@"%ld", number]];
    if(number <=0){
        [self.count setTintColor:[UIColor redColor]];
    } else if(number > 0 && number < 10){
        [self.count setTintColor:[UIColor orangeColor]];
    } else {
        [self.count setTintColor:[UIColor whiteColor]];
    }
    
    
    [UIView setAnimationsEnabled:YES];

}
@end
