//
//  TSTicketViewController.m
//  TicketSystem
//
//  Created by Santiago Lazzari on 30/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "TSTicketViewController.h"

#import "AppDelegate.h"

@interface TSTicketViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;

@end

@implementation TSTicketViewController

#pragma mark - Navigation
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    [self updateUI];
}

#pragma mark - Setup
- (void)setup {
    [self setupNavigationItem];
    [self setupStatesTextField];
}

- (void)setupNavigationItem {
    self.navigationItem.title = self.ticket.name;
}

- (void)setupStatesTextField {
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    self.stateTextField.inputView = pickerView;
}

#pragma mark - UI

- (void)updateUI {
    self.nameTextField.text = self.ticket.name;
    self.descriptionTextField.text = self.ticket.ticketDescription;
    self.stateTextField.text = self.ticket.state;
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.project.states count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.project.states[row].title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.stateTextField.text = self.project.states[row].title;
}

#pragma mark - Requests

#pragma mark - Actions

- (IBAction)save:(id)sender {
    self.project.name = self.nameTextField.text;
    self.project.projectDescription = self.descriptionTextField.text;
    
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    
    NSMutableArray *statesArray = [[NSMutableArray alloc] init];
    
    for(TSProjectState *state in self.project.states) {
        [statesArray addObject:@{@"title" : state.title}];
    }
    
    NSDictionary *parameters = @{ @"title": self.nameTextField.text,
                                  @"description": self.descriptionTextField.text,
                                  @"state": self.stateTextField.text};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/projects/%lu/tickets/%lu", kBaseURL, self.project.projectId, self.ticket.ticketId]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"PUT"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        dispatch_async(dispatch_get_main_queue(),^ {
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                        });

                                                    }
                                                }];
    [dataTask resume];
}
@end
