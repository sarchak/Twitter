//
//  SideMenuViewController.m
//  Twitter
//
//  Created by Shrikar Archak on 2/26/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SideMenuCell.h"
#import "POP/POP.h"
#import "Chameleon.h"

@interface SideMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* items;
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.items = @[@"Home",@"Mentions",@"Profile"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SideMenuCell" bundle:nil] forCellReuseIdentifier:@"SideMenu"];
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.tableView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight
                                             withFrame:self.view.frame
                                             andColors:@[[UIColor flatBlueColor],[UIColor flatSkyBlueColor]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate sideMenuViewController:self didSelectIndexPath:indexPath.row];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SideMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SideMenu"];
    cell.sideLabel.text = self.items[indexPath.row];
    
    return cell;
}

@end
