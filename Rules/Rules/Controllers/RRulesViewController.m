//
//  RRulesViewController.m
//  Rules
//
//  Created by Santiago Lazzari on 10/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "RRulesViewController.h"

#import "RRuleTableViewCell.h"
#import "RRule.h"
#import "RAddRuleViewController.h"
#import "RRuleViewController.h"

@interface RRulesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <RRule *> * rules;

@end

@implementation RRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    [self setupNavigationController];
    
    RRule *r1 = [[RRule alloc] init];
    r1.name = @"rule 1";
    
    RRule *r2 = [[RRule alloc] init];
    r2.name = @"rule 2";

    self.rules = @[r1, r2];
    
    [self.tableView reloadData];
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"RRuleTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RRuleTableViewCell"];
}

- (void)setupNavigationController {
    self.navigationItem.title = @"Reglas";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRuleButtonWasTapped:)];
    
    self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRuleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RRuleTableViewCell"];
    
    cell.rule = self.rules[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RRuleViewController *ruleViewController = [[RRuleViewController alloc] init];
    ruleViewController.rule = self.rules[indexPath.row];
    [self.navigationController pushViewController:ruleViewController animated:YES];
}

#pragma mark - Actions

- (void)addRuleButtonWasTapped:(id)sender {
    [self.navigationController pushViewController:[[RAddRuleViewController alloc] init] animated:YES];
}
@end
