//
//  AppDelegate.h
//  TicketSystem
//
//  Created by Santiago Lazzari on 23/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPNavigationFlowManager.h"

#import "TSUser.h"

#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kNavigationFlowManager kAppDelegate.navigationFlowManager
#define kCurrentUser kAppDelegate.currentUser

#define kBaseURL @"http://db2d1a9b.ngrok.io"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PPNavigationFlowManager *navigationFlowManager;
@property (strong, nonatomic) TSUser *currentUser;

@end

