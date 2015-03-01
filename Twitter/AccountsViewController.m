//
//  AccountsViewController.m
//  Twitter
//
//  Created by Shrikar Archak on 2/28/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "AccountsViewController.h"
#import "SideMenuCell.h"
#import "TwitterClient.h"


@interface AccountsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
///    [self.tableView registerNib:[UINib nibWithNibName:@"SideMenuCell" bundle:nil] forCellReuseIdentifier:@"SideMenuCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
}

-(void) add{
        [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
           
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.accounts.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = @"Hello there";
    return cell;
}
@end
