//
//  TSTicketViewController.h
//  TicketSystem
//
//  Created by Santiago Lazzari on 30/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TSProject.h"
#import "TSTicket.h"

@interface TSTicketViewController : UIViewController

@property (strong, nonatomic) TSTicket *ticket;
@property (strong, nonatomic) TSProject *project;

@end
