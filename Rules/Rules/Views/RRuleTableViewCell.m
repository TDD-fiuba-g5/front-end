//
//  RRuleTableViewCell.m
//  Rules
//
//  Created by Santiago Lazzari on 10/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "RRuleTableViewCell.h"

@interface RRuleTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation RRuleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRule:(RRule *)rule {
    _rule = rule;

    [self updateUI];
}

- (void)updateUI {
    self.nameLabel.text = self.rule.name;

//    self.stateLabel.text = self.rule.status != nil ? self.rule.status : @"No status";
}

@end
