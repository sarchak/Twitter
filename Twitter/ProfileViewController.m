//
//  ProfileViewController.m
//  Twitter
//
//  Created by Shrikar Archak on 2/27/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "ProfileViewController.h"
#import "HeaderCell.h"
#import "UIImageView+AFNetworking.h"
#import "TextCell.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 300;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    cell.name.text = self.tweet.user.name;
    cell.screenName.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    cell.info.text = self.tweet.user.tagline;
    [cell.headerImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.bkImageUrl]];
    [cell.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    return cell;
}

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



-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
//    CATransform3D avatarTransform = CATransform3DIdentity;
    CATransform3D headerTransform = CATransform3DIdentity;
    
    // PULL DOWN -----------------
    UIView *header = self.tableView.tableHeaderView;
    HeaderCell *cell = header;
    
    if (offset < 0 ){
        NSLog(@"Going in : %@", NSStringFromCGSize(header.frame.size));
        CGFloat headerScaleFactor = 0.75; //-(offset) / header.bounds.size.height;
        CGFloat headerSizevariation = 200; //((header.bounds.size.height * (1.0 + headerScaleFactor)) - header.bounds.size.height)/2.0;
        cell.height.constant = 300;
        NSLog(@"Scale  : %f", headerScaleFactor);
        NSLog(@"Scale  : %f", headerSizevariation);
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        header.layer.transform = headerTransform;
        
        [UIView animateWithDuration:1 animations:^{
            header.transform = CGAffineTransformMakeScale(.5, .5);
            [header layoutIfNeeded];
        }];
        
        
    }
}
@end
