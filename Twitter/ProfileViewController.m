//
//  ProfileViewController.m
//  Twitter
//
//  Created by Shrikar Archak on 2/27/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "ProfileViewController.h"
#import "HeaderCell.h"
#import "HeaderViewWithImage.h"
#import "UIImageView+AFNetworking.h"
#import "TextCell.h"
#import "UIScrollView+VGParallaxHeader.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forCellReuseIdentifier:@"HeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:@"TextCell"];
    HeaderViewWithImage *headerView = [HeaderViewWithImage instantiateFromNib];
    headerView.name.text = self.tweet.user.name;
    headerView.screenName.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    headerView.info.text = self.tweet.user.tagline;
    [headerView.headerImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.bkImageUrl]];
    [headerView.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    
    [self.tableView setParallaxHeaderView:headerView
                                     mode:VGParallaxHeaderModeFill
                                   height:350];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 300;
//}
//
//-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
//    cell.name.text = self.tweet.user.name;
//    cell.screenName.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
//    cell.info.text = self.tweet.user.tagline;
//    [cell.headerImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.bkImageUrl]];
//    [cell.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
//    return cell;
//}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
    cell.retweetedLabel.hidden = YES;
    
    cell.retweet.hidden = YES;
    cell.retweetButton.imageView.image = [UIImage imageNamed:@"retweet"];
    cell.favoriteButton.imageView.image = [UIImage imageNamed:@"favorite"];
    cell.nameLabel.text = self.tweet.user.name;
    cell.tweetLabel.text = self.tweet.text;
    if(self.tweet.retweetedBy != nil){
        cell.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.retweetedBy.name];
        cell.retweetedLabel.hidden = NO;
        cell.retweet.hidden = NO;
    }
    
    if(self.tweet.retweeted){
        cell.retweetButton.imageView.image = [UIImage imageNamed:@"retweet_on"];
    }
    if(self.tweet.favorited){
        cell.favoriteButton.imageView.image = [UIImage imageNamed:@"favorite_on"];
    }
    
    
    NSString *biggerImageUrl = [self.tweet.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    [cell.userImageView setImageWithURL:[NSURL URLWithString:biggerImageUrl]];
    cell.rcount.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
    cell.fcount.text = [NSString stringWithFormat:@"%ld", self.tweet.favoritesCount];
    
    cell.screenName.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
//    cell.timeLabel.text = self.tweet.createdAt.shortTimeAgoSinceNow;
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    
    // This is how you can implement appearing or disappearing of sticky view
    [self.tableView.parallaxHeader.stickyView setAlpha:scrollView.parallaxHeader.progress];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}
@end
