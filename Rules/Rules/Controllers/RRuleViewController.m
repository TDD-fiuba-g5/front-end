//
//  RRuleViewController.m
//  Rules
//
//  Created by Santiago Lazzari on 10/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "RRuleViewController.h"

#import "BEMSimpleLineGraphView.h"


@interface RRuleViewController () <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>
@property (weak, nonatomic) IBOutlet UILabel *ruleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ruleRuleLabel;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graph;

@end

@implementation RRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark - Setup

- (void)setup {
    [self setupNavigationItem];
    [self setupGraph];
    
    [self updateUI];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Regla";
}

- (void)setupGraph {
    [self.graph.layer setMasksToBounds:YES];
    [self.graph.layer setCornerRadius:10];
    self.graph.backgroundColor = [UIColor colorWithRed:174/255.0  green:198/255.0  blue:207/255.0 alpha:1.0];
    self.graph.dataSource = self;
    self.graph.delegate = self;
    
    self.graph.enableBezierCurve = YES;
    self.graph.enablePopUpReport = YES;
}

#pragma mark - UI

- (void)updateUI {
    self.ruleNameLabel.text = self.rule.name;
    self.ruleRuleLabel.text = self.rule.rule;
}

- (CGFloat)lineGraph:(nonnull BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return ((float)rand() / RAND_MAX) * 5;
}

- (NSInteger)numberOfPointsInLineGraph:(nonnull BEMSimpleLineGraphView *)graph {
    return 100;
}

@end

