//
//  TSProjectViewController.m
//  TicketSystem
//
//  Created by Santiago Lazzari on 30/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "TSProjectViewController.h"

#import "AppDelegate.h"
#import "TSTicketsViewController.h"

@interface TSProjectViewController ()

@end

@implementation TSProjectViewController

#pragma mark - Navigation
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

#pragma mark - Setup
- (void)setup {
    [self setupNavigationItem];
}

- (void)setupNavigationItem {
    self.navigationItem.title = self.project.name;
}

#pragma mark - UI
- (void)updateUI {
    
}

#pragma mark - Requests

#pragma mark - Actions

- (IBAction)viewTicketsButtonWasTapped:(id)sender {
    TSTicketsViewController *ticketsViewController = [[TSTicketsViewController alloc] init];
    ticketsViewController.project = self.project;
    [self.navigationController pushViewController:ticketsViewController animated:YES];
}

@end
