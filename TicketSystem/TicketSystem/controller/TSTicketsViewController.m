//
//  TSTicketsViewController.m
//  TicketSystem
//
//  Created by Santiago Lazzari on 30/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "TSTicketsViewController.h"

#import "AppDelegate.h"
#import "TSTicket.h"
#import "TSAddTicketViewController.h"
#import "TSTicketViewController.h"


@interface TSTicketsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray<TSTicket *> *tickets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TSTicketsViewController

#pragma mark - Navigation
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getTickets];
}

- (void)setup {
    [self setupNavigationItem];
    [self setupTableView];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Tickets";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTicket)];
    
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.refreshControl = self.refreshControl;
    
}

#pragma mark - UITableViewDelegate,UITableViewDatasource

//- (NSDictionary *)sections {
//    NSMutableDictionary *sections = [[NSMutableDictionary alloc] init];
//    for (TSTicket *ticket in self.tickets) {
//        if (![sections objectForKey:ticket.state]) {
//            [sections addEntriesFromDictionary:@{ticket.state : [[NSMutableArray alloc] init]}];
//            [[sections objectForKey:ticket.state] addObject:ticket];
//        }
//    }
//    return sections;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [self sections].allKeys[section];
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [[self sections] count];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
//    NSDictionary *sections = [self sections];
    
//    TSTicket *ticket = [sections[sections.allKeys[indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = self.tickets[indexPath.row].name;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tickets count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TSTicketViewController *ticketViewController = [[TSTicketViewController alloc] init];
    ticketViewController.ticket = self.tickets[indexPath.row];
    ticketViewController.project = self.project;
    
    [self.navigationController pushViewController:ticketViewController animated:YES];
}

#pragma mark - Requests
- (void)getTickets {
    
//    TSTicket *t1 = [[TSTicket alloc] init];
//    t1.name = @"ticket 1";
//    t1.ticketDescription = @"desc 1";
//    t1.state = @"open";
//
//    TSTicket *t2 = [[TSTicket alloc] init];
//    t2.name = @"ticket 2";
//    t2.ticketDescription = @"desc 2";
//    t2.state = @"close";
//
//    self.tickets = @[t1, t2];
//    [self.tableView reloadData];
    [self getTicketsSuccess:^(NSArray<TSTicket *> *tickets) {
        self.tickets = tickets;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:nil];
}

- (void)getTicketsSuccess:(void(^)(NSArray <TSTicket *> *))success failure:(void(^)(NSError *error))failure {
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/projects/%lu/tickets?owner_id=%lu", kBaseURL, self.project.projectId, kCurrentUser.userid]]
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
                                                        
                                                        NSArray *remoteObjects = (NSArray *)jsonSerialization;
                                                        
                                                        
                                                        NSMutableArray <TSTicket *>* tickets = [[NSMutableArray alloc] init];
                                                        
                                                        for (NSDictionary *projectJson in remoteObjects) {
                                                            TSTicket *ticket = [[TSTicket alloc] init];
                                                            
                                                            ticket.name = projectJson[@"title"];
                                                            ticket.ticketId = [projectJson[@"id"] integerValue];
                                                            ticket.state = projectJson[@"state"];
                                                            ticket.ticketDescription = projectJson[@"description"];
                                                            
                                                            [tickets addObject:ticket];
                                                        }
                                                        
                                                        dispatch_async(dispatch_get_main_queue(),^ {
                                                            success(tickets);
                                                        });
                                                        
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

#pragma mark - Actions
- (void)addTicket {
    [kNavigationFlowManager presentAddTicketViewController:YES project:self.project];
}

- (void)refresh:(id)sender {
    [self getTickets];
}


@end
