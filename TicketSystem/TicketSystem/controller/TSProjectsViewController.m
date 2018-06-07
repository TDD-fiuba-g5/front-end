//
//  TSProjectsViewController.m
//  TicketSystem
//
//  Created by Santiago Lazzari on 26/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "TSProjectsViewController.h"

#import "AppDelegate.h"
#import "TSProject.h"
#import "TSProjectViewController.h"

@interface TSProjectsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray<TSProject *> *projects;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TSProjectsViewController

#pragma mark - Navigation
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self getProjects];
}

#pragma mark - Setup

- (void)setup {
    [self setupNavigationItem];
    [self setupTableView];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Proyectos";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPrject)];

}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.refreshControl = self.refreshControl;

}

#pragma mark - UITableViewDelegate,UITablewViewDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = self.projects[indexPath.row].name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.projects count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TSProjectViewController *projectViewController = [[TSProjectViewController alloc] init];
    
    projectViewController.project = self.projects[indexPath.row];
    
    [self.navigationController pushViewController:projectViewController animated:YES];
}

#pragma mark - Requests

- (void)getProjects {
//    TSProject *p1 = [[TSProject alloc] init];
//    
//    
//    p1.name = @"proj 1";
//    p1.projectDescription = @"desc 1";
//    
//    TSProjectState *ps1 = [[TSProjectState alloc] init];
//    ps1.title = @"open";
//    
//    TSProjectState *ps2 = [[TSProjectState alloc] init];
//    ps2.title = @"close";
//   
//    p1.states = @[ps1, ps2];
//    
//    self.projects = @[p1];
//    [self.tableView reloadData];
    
    [self.refreshControl beginRefreshing];
    [self getProjectsSuccess:^(NSArray<TSProject *> *projects) {
        self.projects = projects;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {

    }];
}

- (void)getProjectsSuccess:(void(^)(NSArray <TSProject *> *))success failure:(void(^)(NSError *error))failure {
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/projects?owner_id=%lu", kBaseURL, kCurrentUser.userid]]
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
                                                        
                                                        
                                                        NSMutableArray <TSProject *>* projects = [[NSMutableArray alloc] init];
                                                        
                                                        for (NSDictionary *projectJson in remoteObjects) {
                                                            TSProject *project = [[TSProject alloc] init];
                                                            
                                                            project.projectId = [projectJson[@"id"] integerValue];
                                                            project.name = projectJson[@"name"];
                                                            project.projectDescription = projectJson[@"description"];
                                                            
                                                            NSMutableArray *states = [[NSMutableArray alloc] init];
                                                            for (NSDictionary *stateJson in projectJson[@"states"]) {
                                                                TSProjectState *state = [[TSProjectState alloc] init];
                                                                
                                                                state.title = stateJson[@"title"];
                                                                [states addObject:state];
                                                            }
                                                            
                                                            project.states = states;
                                                            [projects addObject:project];
                                                        }
                                                        
                                                        dispatch_async(dispatch_get_main_queue(),^ {
                                                            success(projects);
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}

#pragma mark - Actions
- (void)addPrject {
    [kNavigationFlowManager presentAddProjectViewController:YES];
}

- (void)refresh:(id)sender {
    [self getProjects];
}

@end
