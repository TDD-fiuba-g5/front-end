//
//  SENavigationFlowManager.h
//  secla
//
//  Created by Santiago Lazzari on 11/8/16.
//  Copyright © 2016 Santiago Lazzari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "TSProject.h"

@interface PPNavigationFlowManager : NSObject

@property (strong, nonatomic) UIWindow *window;


- (void)presentLoginViewController:(BOOL)animated;
- (void)presentProjectsViewController:(BOOL)animated;
- (void)presentAddProjectViewController:(BOOL)animated;
- (void)presentAddTicketViewController:(BOOL)animated project:(TSProject *)project;

+ (instancetype)sharedInstance;


@end
