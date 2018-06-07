//
//  TSLoginViewController.m
//  TicketSystem
//
//  Created by Santiago Lazzari on 26/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "TSLoginViewController.h"

#import "AppDelegate.h"

@interface TSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation TSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark - Setup
- (void)setup {
    [self setupButtons];
}

- (void)setupButtons {
    self.registerButton.layer.cornerRadius = self.registerButton.frame.size.height / 2.0;
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height / 2.0;
}

#pragma mark - Requests
- (void)loginUser {
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/login?name=%@&password=%@", kBaseURL, self.userTextField.text, self.passwordTextField.text]]
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
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                        
                                                        kAppDelegate.currentUser = [[TSUser alloc] init];

                                                        NSDictionary *remoteObject = (NSDictionary *)jsonSerialization;
                                                        kAppDelegate.currentUser.userid = [remoteObject[@"id"] integerValue];
                                                        dispatch_async(dispatch_get_main_queue(),^ {
                                                            [kNavigationFlowManager presentProjectsViewController:YES];
                                                        });

                                                    }
                                                }];
    [dataTask resume];
}

- (void)registerUser {
    NSDictionary *headers = @{ @"content-type": @"application/json"};

    NSDictionary *parameters = @{ @"name": self.userTextField.text,
                                  @"password": self.passwordTextField.text};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/users", kBaseURL]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}

#pragma mark - Actions

- (IBAction)registerButtonWasTapped:(id)sender {
    [self registerUser];
}
- (IBAction)loginButtonWasTapped:(id)sender {
    [self loginUser];
//    [kNavigationFlowManager presentProjectsViewController:YES];
}
@end
