//
//  RRuleViewController.m
//  Rules
//
//  Created by Santiago Lazzari on 10/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "RRuleViewController.h"

#import "BEMSimpleLineGraphView.h"

#import "AppDelegate.h"

@interface RRuleViewController () <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>
@property (weak, nonatomic) IBOutlet UILabel *ruleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation RRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self getCounter];
}

#pragma mark - Setup

- (void)setup {
    [self setupNavigationItem];
    [self setupGraph];
    
    [self updateUI];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Regla";
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getCounter)];
    self.navigationItem.rightBarButtonItem = refresh;
}

- (void)setupGraph {
//    [self.graph.layer setMasksToBounds:YES];
//    [self.graph.layer setCornerRadius:10];
//    self.graph.backgroundColor = [UIColor colorWithRed:174/255.0  green:198/255.0  blue:207/255.0 alpha:1.0];
//    self.graph.dataSource = self;
//    self.graph.delegate = self;
//    
//    self.graph.enableBezierCurve = YES;
//    self.graph.enablePopUpReport = YES;
}

#pragma mark - UI

- (void)updateUI {
    self.ruleNameLabel.text = self.rule.name;
}

- (CGFloat)lineGraph:(nonnull BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return ((float)rand() / RAND_MAX) * 5;
}

- (NSInteger)numberOfPointsInLineGraph:(nonnull BEMSimpleLineGraphView *)graph {
    return 100;
}

#pragma mark - Requests
- (void)getCounter {
    NSDictionary *headers = @{ @"content-type": @"application/json"};

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.datePicker.date];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/states/%lu/counter?date=%ld-%02ld-%02ld", kBaseURL, self.rule.id, components.year, components.month, components.day]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];


                                                        NSDictionary *remoteObject = (NSDictionary *)jsonSerialization;
                                                        dispatch_async(dispatch_get_main_queue(),^ {
                                                            self.countLabel.text = [NSString stringWithFormat:@"%@", remoteObject[@"count"]];
                                                        });
                                                    }

                                                }];
    [dataTask resume];
}

@end

