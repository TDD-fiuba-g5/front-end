//
//  TSAddProjectViewController.m
//  TicketSystem
//
//  Created by Santiago Lazzari on 30/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "TSAddProjectViewController.h"

#import "AppDelegate.h"
#import "TSProject.h"

@interface TSAddProjectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@property (strong, nonatomic) TSProject *project;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TSAddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark - Setup
- (void)setup {
    [self setupProject];
    [self setupTableView];
}

- (void)setupProject {
    self.project = [[TSProject alloc] init];
    self.project.states = @[];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.project.states count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = self.project.states[indexPath.row].title;
    
    return cell;
}

#pragma mark - Actions

- (IBAction)backButtonWasTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addStateButtonWasTapped:(id)sender {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Estado"
                                 message:@"Agregá un estado para el proyecto"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Estado";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Crear" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *title = alert.textFields[0].text;
        
        TSProjectState *state = [[TSProjectState alloc] init];
        state.title = title;
        
        self.project.states = [self.project.states arrayByAddingObjectsFromArray:@[state]];
        
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)saveButtonWasTapped:(id)sender {
    
    self.project.name = self.nameTextField.text;
    self.project.projectDescription = self.descriptionTextField.text;
    
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    
    NSMutableArray *statesArray = [[NSMutableArray alloc] init];
    
    for(TSProjectState *state in self.project.states) {
        [statesArray addObject:@{@"title" : state.title}];
    }
    
    NSDictionary *parameters = @{ @"name": self.project.name,
                                  @"description": self.project.projectDescription,
                                  @"owner_id": [NSNumber numberWithInteger:kCurrentUser.userid],
                                  @"states_attributes": statesArray};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/projects", kBaseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    }
                                                }];
    [dataTask resume];
    
}

@end
