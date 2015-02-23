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
#import <WebKit/WebKit.h>
@interface TweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSMutableArray *tweets;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIImageView *popUpImageView;
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

    
    [self fetchData: YES];

    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCompose target:self action:@selector(compose)];
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self fetchData:NO];
    }];
    
}

-(void) logout {
    [User logOut];
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



-(void) fetchData: (BOOL) top {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:20], @"count", [NSNumber numberWithBool:YES], @"include_entities",nil];
    
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
    

    [[TwitterClient sharedInstance] homeTimelineWithParams:dictionary completion:^(NSArray *tweets, NSError *error) {
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

-(void) refreshTable {
    [self fetchData:YES];
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
        pcell.tweetLabel.delegate = self;
        pcell.delegate = self;
    
        cell = pcell;
    } else{
        TextCell *tcell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        tcell.delegate = self;
        tcell.retweetedLabel.hidden = YES;
        tcell.tweetLabel.delegate = self;
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
                [cell.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.3, 1.3)];
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
            NSDictionary *params = @{@"id":tweet.id_str};
            [[TwitterClient sharedInstance] retweetWithParams:params completion:^(NSError *error) {
                
            }];
            
            cell.retweetButton.alpha = 0;
            tweet.retweetCount = tweet.retweetCount + 1;
            [UIView animateWithDuration:0.3 animations:^{
                cell.retweetButton.alpha = 1;
                [cell.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.3, 1.3)];
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
            NSDictionary *params = @{@"id":tweet.id_str};
            [[TwitterClient sharedInstance] unFavoriteWithParams:params completion:^(NSError *error) {
                
            }];
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
            NSDictionary *params = @{@"id":tweet.id_str};
            [[TwitterClient sharedInstance] favoriteWithParams:params completion:^(NSError *error) {
                
            }];
            
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
            tweet.retweetCount = tweet.retweetCount - 1;
            cell.retweetButton.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                cell.retweetButton.alpha = 1;
                [cell.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.3, 1.3)];
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
            NSDictionary *params = @{@"id":tweet.id_str};
            [[TwitterClient sharedInstance] retweetWithParams:params completion:^(NSError *error) {
                
            }];
            cell.retweetButton.alpha = 0;
            tweet.retweetCount = tweet.retweetCount + 1;
            [UIView animateWithDuration:0.3 animations:^{
                cell.retweetButton.alpha = 1;
                [cell.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.3, 1.3)];
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
            NSDictionary *params = @{@"id":tweet.id_str};
            [[TwitterClient sharedInstance] unFavoriteWithParams:params completion:^(NSError *error) {
                
            }];
            
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
            NSDictionary *params = @{@"id":tweet.id_str};
            [[TwitterClient sharedInstance] favoriteWithParams:params completion:^(NSError *error) {
                
            }];
            
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


-(void) photoCell:(PhotoCell *)photoCell imageTapped:(UIImageView *)imageView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:photoCell];
    Tweet *tweet = self.tweets[indexPath.row];
    UIImageView *imgView = [[UIImageView alloc] init];

    imgView.userInteractionEnabled = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [imgView setImageWithURL:[NSURL URLWithString:tweet.media.mediaUrl]];
    [self.view addSubview:imgView];
    self.popUpImageView = imgView;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [imgView addGestureRecognizer:tapGesture];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:self.tableView.frame];
    anim.springSpeed = 10;
    anim.springBounciness = 10;
    [imgView pop_addAnimation:anim forKey:@"scale"];
}

-(void) handleTap:(UIImageView*) imageView {
    [UIView animateWithDuration:0.5 animations:^{
        self.webView.alpha = 0;
        [self.popUpImageView removeFromSuperview];
    }];
    
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

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    NSLog(@"%@",url);

    CGRect newFrame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    WKWebView *webView = [[WKWebView alloc] initWithFrame:newFrame];

    webView.scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:req];
    [self.view addSubview:webView];
    self.webView = webView;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.backgroundColor = [UIColor clearColor];
    
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)];
    [toolbar setItems:@[close]];

    [webView addSubview:toolbar];
}

-(void) close:(UIBarButtonItem*) sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.webView.alpha = 0;
        [self.webView removeFromSuperview];
    }];
    
}
@end
