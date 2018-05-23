//
//  RAddRuleViewController.m
//  Rules
//
//  Created by Santiago Lazzari on 10/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "RAddRuleViewController.h"

#import "RRule.h"

@interface RAddRuleViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ruleTextField;
@property (weak, nonatomic) IBOutlet UIButton *createRuleButton;

@end

@implementation RAddRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

#pragma mark - Setup

- (void)setup {
    [self setupNavigationItem];
    [self setupCreateRuleButton];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Agregá una regla";
}

- (void)setupCreateRuleButton {
    [self.createRuleButton.layer setCornerRadius:self.createRuleButton.frame.size.height / 2.0];
}

#pragma mark - Request

- (void)postRule:(RRule *)rule {
    [self postRule:rule success:^{
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"Rule error");
    }];
}

- (void)postRule:(RRule *)rule success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    NSDictionary *parameters = @{ @"name": rule.name,
                                  @"rule": rule.rule };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://6aee3677.ngrok.io/states"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        failure(error);
                                                    } else {
                                                        dispatch_async(dispatch_get_main_queue(),^ {
                                                            success();
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}

#pragma mark - Actions

- (IBAction)createRuleButtonWasTapped:(id)sender {
    NSString *name = self.nameTextField.text;
    NSString *ruleRule = self.ruleTextField.text;
    
    RRule *rule = [[RRule alloc] init];
    rule.name = name;
    rule.rule = ruleRule;

    [self postRule:rule];
}


@end
