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
    

    self.count = [[UIBarButtonItem alloc] initWithTitle:@"140" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *tweet = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItems = @[tweet, self.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) cancel{
    
}

-(void) textViewDidChange:(UITextView *)textView{
    NSInteger number = 140 - textView.text.length;
//    [UIView animateWithDuration:0.1 animations:^{
//        self.count.title = ;
//    }];
    [UIView setAnimationsEnabled:NO];
    [self.count setTitle:[NSString stringWithFormat:@"%ld", number]];
    [UIView setAnimationsEnabled:YES];

}
@end
