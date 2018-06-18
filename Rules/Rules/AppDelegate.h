//
//  AppDelegate.h
//  Rules
//
//  Created by Santiago Lazzari on 10/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPNavigationFlowManager.h"

#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kNavigationFlowManager kAppDelegate.navigationFlowManager

#define kBaseURL @"http://e2cedbce.ngrok.io"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PPNavigationFlowManager *navigationFlowManager;


@end

