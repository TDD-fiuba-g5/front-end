//
//  ViewController.m
//  TicketSystem
//
//  Created by Santiago Lazzari on 23/05/2018.
//  Copyright © 2018 Santiago Lazzari. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendEventButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}


#pragma mark - Setup
- (void)setup {
    [self setupSendEventButton];
}

- (void)setupSendEventButton {
    self.sendEventButton.layer.cornerRadius = self.sendEventButton.frame.size.height / 2.0;
}

#pragma mark - Actions
- (IBAction)sendEventButtonWasTapped:(id)sender {
    NSLog(@"Send event button was tapped");
}

@end
