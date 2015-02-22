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
#import <POP/POP.h>
#import "UIScrollView+SVInfiniteScrolling.h"

@interface TweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSMutableArray *tweets;
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

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self fetchData];
    }];
    
}

-(void) compose {

    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    cvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];

    [self presentViewController:nvc animated:YES completion:nil];
}

-(void) composeViewController:(ComposeViewController *)composeViewController tweet:(Tweet *)tweet {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tweets insertObject:tweet atIndex:0];
//    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView endUpdates];

}


-(void) fetchData {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:20], @"count", [NSNumber numberWithBool:YES], @"include_entities",nil];
    
    if(self.tweets != nil){
        Tweet *last = self.tweets.lastObject;
        
        [dictionary setObject:last.id_str forKey:@"max_id"];
    }
    

    [[TwitterClient sharedInstance] homeTimelineWithParams:dictionary completion:^(NSArray *tweets, NSError *error) {
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
        if(tweets != nil){
            if(self.tweets == nil){
                self.tweets = [tweets mutableCopy];
                [self.tableView reloadData];
            }else {
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

        pcell.delegate = self;
    
        cell = pcell;
    } else{
        TextCell *tcell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        tcell.delegate = self;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Tweet *tweet = self.tweets[indexPath.row];
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.tweet = tweet;
    [self.navigationController pushViewController:dvc animated:YES];
}


-(void) togglePhotoCell:(Tweet*) tweet forCell: (PhotoCell*)cell type: (NSString*) type {
    
    if([type isEqual: @"retweet"]){
        if(tweet.retweeted){
            tweet.retweetCount = tweet.retweetCount - 1;
            cell.retweetButton.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                cell.retweetButton.alpha = 1;
                [cell.retweetButton setImage:[UIImage imageNamed:@"retweet_animated"] forState:UIControlStateNormal];
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.5, 1.5)];
                scaleAnimation.springBounciness = 10.f;
                [cell.retweetButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            } completion:^(BOOL finished) {
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
                scaleAnimation.springBounciness = 10.f;
                [cell.retweetButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
                [cell.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
            }];
        } else {
            cell.retweetButton.alpha = 0;
            tweet.retweetCount = tweet.retweetCount + 1;
            [UIView animateWithDuration:0.3 animations:^{
                cell.retweetButton.alpha = 1;
                [cell.retweetButton setImage:[UIImage imageNamed:@"retweet_animated"] forState:UIControlStateNormal];
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2, 2)];
                scaleAnimation.springBounciness = 10.f;
                [cell.retweetButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            } completion:^(BOOL finished) {
                
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
                scaleAnimation.springBounciness = 10.f;
                [cell.retweetButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
                [cell.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
            }];
            
        }
        tweet.retweeted  = !tweet.retweeted;

        cell.rcount.text =[NSString stringWithFormat:@"%ld", tweet.retweetCount];
    }
    if([type isEqual: @"favorite"]){
        if(tweet.favorited){
            tweet.favoritesCount = tweet.favoritesCount - 1;
            cell.favoriteButton.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                cell.favoriteButton.alpha = 1;
                [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite_animated"] forState:UIControlStateNormal];
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2, 2)];
                scaleAnimation.springBounciness = 10.f;
                [cell.favoriteButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            } completion:^(BOOL finished) {
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
                scaleAnimation.springBounciness = 10.f;
                [cell.favoriteButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
                [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
            }];
        } else {
            cell.favoriteButton.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                cell.favoriteButton.alpha = 1;
                [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite_animated"] forState:UIControlStateNormal];
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2, 2)];
                scaleAnimation.springBounciness = 10.f;
                [cell.favoriteButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            } completion:^(BOOL finished) {
                
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
                scaleAnimation.springBounciness = 10.f;
                [cell.favoriteButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
                [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
            }];
            
            tweet.favoritesCount = tweet.favoritesCount + 1;
        }
        tweet.favorited = !tweet.favorited;
        cell.fcount.text = [NSString stringWithFormat:@"%ld", tweet.favoritesCount];
    }
}

-(void) toggleTextCell:(Tweet*) tweet forCell: (TextCell*)cell type: (NSString*) type {
    
    if([type isEqual: @"retweet"]){
        if(tweet.retweeted){
            [cell.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
            tweet.retweetCount = tweet.retweetCount - 1;
        } else {
            [cell.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
            tweet.retweetCount = tweet.retweetCount + 1;
        }
        tweet.retweeted  = !tweet.retweeted;
        
        cell.rcount.text =[NSString stringWithFormat:@"%ld", tweet.retweetCount];
    }
    if([type isEqual: @"favorite"]){
        if(tweet.favorited){
            
            tweet.favoritesCount = tweet.favoritesCount - 1;
            cell.favoriteButton.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                cell.favoriteButton.alpha = 1;
                [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite_animated"] forState:UIControlStateNormal];
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2, 2)];
                scaleAnimation.springBounciness = 10.f;
                [cell.favoriteButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            } completion:^(BOOL finished) {
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
                scaleAnimation.springBounciness = 10.f;
                [cell.favoriteButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
                [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
            }];
        } else {
            cell.favoriteButton.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                cell.favoriteButton.alpha = 1;
                [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite_animated"] forState:UIControlStateNormal];
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2, 2)];
                scaleAnimation.springBounciness = 10.f;
                [cell.favoriteButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            } completion:^(BOOL finished) {
                
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
                scaleAnimation.springBounciness = 10.f;
                [cell.favoriteButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
                [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
            }];
            
            tweet.favoritesCount = tweet.favoritesCount + 1;
        }
        tweet.favorited = !tweet.favorited;
        cell.fcount.text = [NSString stringWithFormat:@"%ld", tweet.favoritesCount];
    }
}


-(void)photoCell:(PhotoCell *)photoCell reply:(UIButton *)button {
    NSLog(@"Reply");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:photoCell];
    Tweet *tweet = self.tweets[indexPath.row];
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    cvc.delegate = self;
    cvc.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    cvc.in_reply_to_status_id = tweet.id_str;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    [self presentViewController:nvc animated:YES completion:nil];
    
}

-(void) photoCell:(PhotoCell *)photoCell retweet:(UIButton *)button{
    NSLog(@"Retweet");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:photoCell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self togglePhotoCell:tweet forCell:photoCell type:@"retweet"];
}

-(void) photoCell:(PhotoCell *)photoCell favorite:(UIButton *)button{
    NSLog(@"favorite");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:photoCell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self togglePhotoCell:tweet forCell:photoCell type:@"favorite"];
}

-(void)textCell:(TextCell *)textCell reply:(UIButton *)button {
    NSLog(@"Reply");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textCell];
    Tweet *tweet = self.tweets[indexPath.row];
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    cvc.delegate = self;
    cvc.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    cvc.in_reply_to_status_id = tweet.id_str;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    [self presentViewController:nvc animated:YES completion:nil];
    
}

-(void) textCell:(TextCell *)textCell retweet:(UIButton *)button{
    NSLog(@"Retweet");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textCell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self toggleTextCell:tweet forCell:textCell type:@"retweet"];
}

-(void) textCell:(TextCell *)textCell favorite:(UIButton *)button{
    NSLog(@"favorite");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textCell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self toggleTextCell:tweet forCell:textCell type:@"favorite"];
}

@end
