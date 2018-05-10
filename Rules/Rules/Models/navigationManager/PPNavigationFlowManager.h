//
//  SENavigationFlowManager.h
//  secla
//
//  Created by Santiago Lazzari on 11/8/16.
//  Copyright © 2016 Santiago Lazzari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>


@interface PPNavigationFlowManager : NSObject

@property (strong, nonatomic) UIWindow *window;


- (void)presentRulesViewController:(BOOL)animated;

+ (instancetype)sharedInstance;


@end
