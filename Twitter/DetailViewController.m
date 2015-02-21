//
//  DetailViewController.m
//  Twitter
//
//  Created by Shrikar Archak on 2/19/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "DetailViewController.h"
#import "Tweet.h"
#import "PhotoCell.h"
#import "TextCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *replies;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:@"TextCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellReuseIdentifier:@"PhotoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StatsCell" bundle:nil] forCellReuseIdentifier:@"StatsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActionCell" bundle:nil] forCellReuseIdentifier:@"ActionCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 250;
    self.tableView.tableFooterView = [[UIView alloc] init] ;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.replies != nil){
        return 1 + self.replies.count;
    }
    return 3;
}



-(UITableViewCell*) getCell{
    UITableViewCell *cell = nil;
    Tweet *tweet = self.tweet;
    if(tweet.media != nil){
        PhotoCell *pcell = [self.tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
        [pcell.mediaImageView setImageWithURL:[NSURL URLWithString:tweet.media.mediaUrl]];
        pcell.nameLabel.text = tweet.user.name;
        pcell.tweetLabel.text = tweet.text;
        
        
        NSString *biggerImageUrl = [tweet.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        [pcell.userImageView setImageWithURL:[NSURL URLWithString:biggerImageUrl]];
        
        pcell.screenName.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
        pcell.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
        
        pcell.replyButton.hidden = YES;
        pcell.favoriteButton.hidden = YES;
        pcell.retweetButton.hidden = YES;
        
        pcell.retweetedLabel.hidden = YES;
        cell = pcell;
        pcell.retweet.hidden = YES;
        
        cell = pcell;
    } else{
        TextCell *tcell = [self.tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        
        tcell.retweetedLabel.hidden = YES;
        tcell.nameLabel.text = tweet.user.name;
        tcell.tweetLabel.text = tweet.text;
        tcell.retweet.hidden = YES;
        
        NSString *biggerImageUrl = [tweet.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        [tcell.userImageView setImageWithURL:[NSURL URLWithString:biggerImageUrl]];
        
        tcell.screenName.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
        tcell.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
        tcell.replyButton.hidden = YES;
        tcell.favoriteButton.hidden = YES;
        tcell.retweetButton.hidden = YES;
        
        
        cell = tcell;
    }
    return cell;
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if(indexPath.row == 0){
        cell = [self getCell];
    } else if(indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"StatsCell"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
