//
//  ProfileViewController.m
//  Twitter
//
//  Created by Shrikar Archak on 2/27/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "ProfileViewController.h"
#import "HeaderCell.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    cell.name.text = self.tweet.user.name;
    cell.screenName.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    cell.info.text = self.tweet.user.tagline;
    return cell;
}
@end
