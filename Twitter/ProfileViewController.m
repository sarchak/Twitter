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
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"
#import "SVProgressHUD.h"
#import <POP/POP.h>
#import "UIScrollView+SVInfiniteScrolling.h"
#import <WebKit/WebKit.h>
#import "MainViewController.h"
#import "PhotoCell.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HeaderViewWithImage *headerView;
@property (nonatomic,strong) NSMutableArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL scaledDown;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellReuseIdentifier:@"PhotoCell"];
    HeaderViewWithImage *headerView = [HeaderViewWithImage instantiateFromNib];
    self.scaledDown = NO;
    headerView.profileImageView.layer.cornerRadius = 5.0;
    headerView.name.text = self.user.name;
    headerView.screenName.text = [NSString stringWithFormat:@"@%@",self.user.screenName];
    headerView.info.text = self.user.tagline;

    [headerView.headerImageView setImageWithURL:[NSURL URLWithString:self.user.bkImageUrl]];
    [headerView.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];


    NSLog(@"Initial header : %@", NSStringFromCGSize(headerView.contentView.frame.size));
    NSLog(@"Initial header bounds : %@", NSStringFromCGSize(headerView.contentView.bounds.size));
    headerView.info.preferredMaxLayoutWidth = headerView.info.frame.size.width;
    headerView.name.preferredMaxLayoutWidth = headerView.name.frame.size.width;
    headerView.screenName.preferredMaxLayoutWidth = headerView.screenName.frame.size.width;
    headerView.name.numberOfLines = 0;
    headerView.screenName.numberOfLines = 0;
    headerView.info.numberOfLines = 0;
    [headerView.name sizeToFit];
    [headerView.screenName sizeToFit];
    [headerView.info sizeToFit];
    headerView.visualBlurView.alpha = 0;

    CGFloat height = headerView.name.intrinsicContentSize.height +
                    headerView.screenName.intrinsicContentSize.height +
                    headerView.info.intrinsicContentSize.height + headerView.tweetCount.intrinsicContentSize.height;
    headerView.viewHeight.constant = height  +100;
    NSLog(@"Size is = %f", height);
    
    [self.tableView setParallaxHeaderView:headerView
                                     mode:VGParallaxHeaderModeFill
                                   height:350];
    self.headerView = headerView;
    
    [self fetchData:YES];
}

-(void) fetchData: (BOOL) top {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:20], @"count", [NSNumber numberWithBool:YES], @"include_entities",
                                       self.user.screenName, @"screen_name", nil];
    
    if(self.tweets != nil || !top){
        if(top){
            Tweet *first = self.tweets.firstObject;
            if(first != nil){
                [dictionary setObject:first.id_str forKey:@"since_id"];
            }
        }else {
            Tweet *last = self.tweets.lastObject;
            if(last != nil){
                [dictionary setObject:last.id_str forKey:@"max_id"];
            }
            
        }
    }
    
    
    [[TwitterClient sharedInstance] userTimelineWithParams:dictionary completion:^(NSArray *tweets, NSError *error) {
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
        if(tweets != nil){
            if(self.tweets == nil || top){
                NSLog(@"Add to the top");
                NSArray* temp = self.tweets;
                self.tweets = [tweets mutableCopy];
                [self.tweets addObjectsFromArray:temp];
                [self.tableView reloadData];
            }else {
                NSLog(@"Add to the bottom");
                int i = 0;
                for(Tweet *ttweet in tweets){
                    if(i==0){
                        i++;
                        continue;
                    }
                    [self.tweets addObject:ttweet];
                }
                
                [self.tableView.infiniteScrollingView stopAnimating];
                [self.tableView reloadData];
            }
        }
    }];
    
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
    return self.tweets.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    Tweet *tweet = self.tweets[indexPath.row];
    if(tweet.media != nil){
        
        PhotoCell *pcell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
        pcell.retweetedLabel.hidden = YES;
        pcell.retweet.hidden = YES;
        pcell.retweetButton.imageView.image = [UIImage imageNamed:@"retweet"];
        pcell.favoriteButton.imageView.image = [UIImage imageNamed:@"favorite"];
        [pcell.mediaImageView setImageWithURL:[NSURL URLWithString:tweet.media.mediaUrl]];
        pcell.nameLabel.text = tweet.user.name;
        pcell.tweetLabel.text = tweet.text;
        
        
        if(tweet.retweetedBy != nil){
            pcell.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweetedBy.name];
            pcell.retweetedLabel.hidden = NO;
            pcell.retweet.hidden = NO;
        }
        
        NSString *biggerImageUrl = [tweet.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        [pcell.userImageView setImageWithURL:[NSURL URLWithString:biggerImageUrl]];
        
        pcell.screenName.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
        pcell.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
        pcell.rcount.text = [NSString stringWithFormat:@"%ld", tweet.retweetCount];
        pcell.fcount.text = [NSString stringWithFormat:@"%ld", tweet.favoritesCount];
        if(tweet.retweeted){
            pcell.retweetButton.imageView.image = [UIImage imageNamed:@"retweet_on"];
        }
        if(tweet.favorited){
            pcell.favoriteButton.imageView.image = [UIImage imageNamed:@"favorite_on"];
        }
        cell = pcell;
    } else{
        TextCell *tcell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        tcell.retweetedLabel.hidden = YES;
        tcell.retweet.hidden = YES;
        tcell.retweetButton.imageView.image = [UIImage imageNamed:@"retweet"];
        tcell.favoriteButton.imageView.image = [UIImage imageNamed:@"favorite"];
        
        tcell = tcell;
        tcell.nameLabel.text = tweet.user.name;
        tcell.tweetLabel.text = tweet.text;
        if(tweet.retweetedBy != nil){
            tcell.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweetedBy.name];
            tcell.retweetedLabel.hidden = NO;
            tcell.retweet.hidden = NO;
        }
        
        if(tweet.retweeted){
            tcell.retweetButton.imageView.image = [UIImage imageNamed:@"retweet_on"];
        }
        if(tweet.favorited){
            tcell.favoriteButton.imageView.image = [UIImage imageNamed:@"favorite_on"];
        }
        
        
        NSString *biggerImageUrl = [tweet.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        [tcell.userImageView setImageWithURL:[NSURL URLWithString:biggerImageUrl]];
        tcell.rcount.text = [NSString stringWithFormat:@"%ld", tweet.retweetCount];
        tcell.fcount.text = [NSString stringWithFormat:@"%ld", tweet.favoritesCount];
        
        tcell.screenName.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
        tcell.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
        
        cell = tcell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//
    
    CGFloat posNum = abs(scrollView.contentOffset.y) - 64;
    
    if(posNum/128 > 0.5){
        self.headerView.visualBlurView.alpha = 0.5;
        self.navigationItem.title = self.user.name;

    } else {
        self.headerView.visualBlurView.alpha = posNum / 128;
        self.navigationItem.title = nil;
    }

    if(scrollView.contentOffset.y > 0 && !self.scaledDown){
        NSLog(@"Scalled down Offset : %f", scrollView.contentOffset.y);
        self.scaledDown = YES;
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.5;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
        [self.headerView.profileImageView pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    }
    if(scrollView.contentOffset.y < 0 && self.scaledDown){
        NSLog(@"Scaled up Offset : %f", scrollView.contentOffset.y);
        self.scaledDown = NO;
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.5;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        [self.headerView.profileImageView pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    
    }

    [self.tableView shouldPositionParallaxHeader];
    
    // This is how you can implement appearing or disappearing of sticky view
    [self.tableView.parallaxHeader.stickyView setAlpha:scrollView.parallaxHeader.progress];
    [self.tableView.parallaxHeader layoutIfNeeded];
}
@end
