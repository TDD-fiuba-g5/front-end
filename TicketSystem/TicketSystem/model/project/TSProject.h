//
//  TSProject.h
//  TicketSystem
//
//  Created by Santiago Lazzari on 26/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TSUser.h"
#import "TSProjectState.h"

@interface TSProject : NSObject

@property (nonatomic) NSUInteger projectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *projectDescription;
@property (nonatomic) NSUInteger ownerId;
@property (strong, nonatomic) NSArray<TSProjectState *> *states;

@end
