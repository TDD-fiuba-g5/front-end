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
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation RRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rules = @[];
    
    [self setupTableView];
    [self setupNavigationController];
    [self getData];
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"RRuleTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RRuleTableViewCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.refreshControl = self.refreshControl;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    [self deleteRule:[self.rules objectAtIndex:indexPath.row]];

}



#pragma mark - Requests

- (void)getData {
    [self getRemoteRules:nil fromPath:nil success:^(NSArray<RRule *> *rules) {
        self.rules = rules;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:nil];
}

- (void)getRemoteRules:(Class)remoteObjectClass fromPath:(NSString *)path success:(void(^)(NSArray <RRule *> *))success failure:(void(^)(NSError *error))failure {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://6aee3677.ngrok.io/states"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                        
                                                        
                                                        NSArray *remoteObjects = (NSArray *)jsonSerialization;
                                                        
                                                        
                                                        NSMutableArray <RRule *>* rules = [[NSMutableArray alloc] init];
                                                        
                                                        for (NSDictionary *ruleJson in remoteObjects) {
                                                            RRule *rule = [[RRule alloc] init];
                                                            
                                                            rule.id = [ruleJson[@"id"] integerValue];
                                                            rule.name = ruleJson[@"name"];
                                                            rule.rule = ruleJson[@"rule"];
                                                            rule.status = ruleJson[@"status"];
                                                            [rules addObject:rule];
                                                        }
                                                        
                                                        dispatch_async(dispatch_get_main_queue(),^ {
                                                            success(rules);
                                                        });
                                                    }
                                                }];
    [dataTask resume];
    
}


- (void)deleteRule:(RRule *)rule {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://6aee3677.ngrok.io/states/%lu", rule.id]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"DELETE"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        [self getData];
                                                    }
                                                }];
    [dataTask resume];
}

#pragma mark - Actions

- (void)addRuleButtonWasTapped:(id)sender {
    [self.navigationController pushViewController:[[RAddRuleViewController alloc] init] animated:YES];
}

- (void)refresh:(id)sender {
    [self getData];
}
@end
