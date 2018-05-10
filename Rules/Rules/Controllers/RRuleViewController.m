//
//  RRuleViewController.m
//  Rules
//
//  Created by Santiago Lazzari on 10/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "RRuleViewController.h"

@interface RRuleViewController ()

@end

@implementation RRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark - Setup

- (void)setup {
    [self setupNavigationItem];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Regla";
}
@end
