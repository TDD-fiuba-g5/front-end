//
//  RRuleTableViewCell.h
//  Rules
//
//  Created by Santiago Lazzari on 10/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RRule.h"

@interface RRuleTableViewCell : UITableViewCell

@property (strong, nonatomic) RRule *rule;

@end
