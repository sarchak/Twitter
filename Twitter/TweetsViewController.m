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
#import "PhotoCell.h"
#import "DetailViewController.h"
#import "ComposeViewController.h"
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
    self.title = @"Twitter";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:@"TextCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellReuseIdentifier:@"PhotoCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 250;

    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

//    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:8.0/255 green:10.0/255 blue:15.0/255 alpha:1]];
    [SVProgressHUD setForegroundColor: [UIColor colorWithRed:85.0/255 green:172.0/255 blue:238.0/255 alpha:1.0]];
    [SVProgressHUD show];

    
    [self fetchData];

    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCompose target:self action:@selector(compose)];

}

-(void) compose {

    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];

    [self presentViewController:nvc animated:YES completion:nil];
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

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    
    
    Tweet *tweet = self.tweets[indexPath.row];
    if(tweet.media != nil){
        PhotoCell *pcell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
        [pcell.mediaImageView setImageWithURL:[NSURL URLWithString:tweet.media.mediaUrl]];
        pcell.nameLabel.text = tweet.user.name;
        pcell.tweetLabel.text = tweet.text;
        
        
        NSString *biggerImageUrl = [tweet.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        [pcell.userImageView setImageWithURL:[NSURL URLWithString:biggerImageUrl]];
        
        pcell.screenName.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
        pcell.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
        cell = pcell;
        
        cell = pcell;
    } else{
        TextCell *tcell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        tcell = tcell;
        tcell.nameLabel.text = tweet.user.name;
        tcell.tweetLabel.text = tweet.text;
        
        
        NSString *biggerImageUrl = [tweet.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        [tcell.userImageView setImageWithURL:[NSURL URLWithString:biggerImageUrl]];
        
        tcell.screenName.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
        tcell.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
        cell = tcell;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Tweet *tweet = self.tweets[indexPath.row];
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.tweet = tweet;
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
