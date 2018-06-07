//
//  TSTicket.h
//  TicketSystem
//
//  Created by Santiago Lazzari on 30/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTicket : NSObject

@property (nonatomic) NSUInteger ticketId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *ticketDescription;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSArray <NSString *> *comments;

@property (strong, nonatomic) NSString *status;

@end
