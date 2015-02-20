//
//  TweetsViewController.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TextCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"
#import "SVProgressHUD.h"

@interface TweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSArray *tweets;
@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:@"TextCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 85;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

//    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:8.0/255 green:10.0/255 blue:15.0/255 alpha:1]];
    [SVProgressHUD setForegroundColor: [UIColor colorWithRed:85.0/255 green:172.0/255 blue:238.0/255 alpha:1.0]];
    [SVProgressHUD show];

    
    [self fetchData];
    
}

-(void) fetchData {
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:200], @"count", [NSNumber numberWithBool:YES], @"include_entities",nil];
    [[TwitterClient sharedInstance] homeTimelineWithParams:dictionary completion:^(NSArray *tweets, NSError *error) {
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
        if(tweets != nil){
            self.tweets = tweets;
            [self.tableView reloadData];
        }
    }];

}

-(void) refreshTable {
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    cell.nameLabel.text = tweet.user.name;
    cell.tweetLabel.text = tweet.text;
    

    NSString *biggerImageUrl = [tweet.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    [cell.userImageView setImageWithURL:[NSURL URLWithString:biggerImageUrl]];
    
    cell.screenName.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
    cell.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
    return cell;
}

@end
