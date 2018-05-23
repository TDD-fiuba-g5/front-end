//
//  RRule.h
//  Rules
//
//  Created by Santiago Lazzari on 10/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRule : NSObject

@property (nonatomic) NSUInteger id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *rule;
@property (strong, nonatomic) NSString *status;

@end
