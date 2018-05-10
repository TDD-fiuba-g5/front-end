//
//  RAddRuleViewController.m
//  Rules
//
//  Created by Santiago Lazzari on 10/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "RAddRuleViewController.h"

@interface RAddRuleViewController ()

@end

@implementation RAddRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

#pragma mark - Setup

- (void)setup {
    [self setupNavigationItem];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Agregá una regla";
}

@end
