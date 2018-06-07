//
//  SENavigationFlowManager.m
//  secla
//
//  Created by Santiago Lazzari on 11/8/16.
//  Copyright © 2016 Santiago Lazzari. All rights reserved.
//

#import "PPNavigationFlowManager.h"

#import "TSLoginViewController.h"
#import "TSProjectsViewController.h"
#import "TSAddProjectViewController.h"
#import "TSAddTicketViewController.h"

@implementation PPNavigationFlowManager

#pragma mark - Init
+ (instancetype)sharedInstance {
    static PPNavigationFlowManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PPNavigationFlowManager alloc] init];
        [sharedInstance setup];
    });
    return sharedInstance;
}

#pragma mark - Setup
- (void)setup {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
}

#pragma mark - Presentation

- (void)presentLoginViewController:(BOOL)animated {
    
    TSLoginViewController *loginViewController = [[TSLoginViewController alloc] init];

    [self presentViewController:loginViewController animated:animated completion:nil];
}

- (void)presentProjectsViewController:(BOOL)animated {
    TSProjectsViewController *projectViewController = [[TSProjectsViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:projectViewController];
    
    [self presentViewController:nc animated:animated completion:nil];
}

- (void)presentAddProjectViewController:(BOOL)animated {
    TSAddProjectViewController *addProjectViewController = [[TSAddProjectViewController alloc] init];
    
    [self presentViewController:addProjectViewController animated:animated completion:nil];
}

- (void)presentAddTicketViewController:(BOOL)animated project:(TSProject *)project {
    TSAddTicketViewController *addTicketViewController = [[TSAddTicketViewController alloc] init];
    addTicketViewController.project = project;
    [self presentViewController:addTicketViewController animated:animated completion:nil];
}

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *topViewController = [self topMostViewController];
    
    if (topViewController == nil) {
        self.window.rootViewController = viewController;
    } else {
        [topViewController presentViewController:viewController animated:animated completion:completion];
    }
}

- (UIViewController *)topMostViewController {
    UIViewController *topViewController = [self.window rootViewController];
    
    while ([topViewController presentedViewController] != nil) {
        topViewController = [topViewController presentedViewController];
    }
    
    return topViewController;
}

@end
