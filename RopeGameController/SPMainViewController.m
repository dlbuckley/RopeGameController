//
//  SPMainViewController.m
//  RopeGameController
//
//  Created by Dale Buckley on 19/09/2013.
//  Copyright (c) 2013 NSSpain. All rights reserved.
//

#import "SPMainViewController.h"
#import "SPPlayersViewController.h"

CGFloat const kTeamControllerMinWidth = 140.0f;
CGFloat const kTeamControllerMaxWidth = 240.0f;

@interface SPMainViewController ()

@property (nonatomic, strong) SPPlayersViewController *team1Controller;
@property (nonatomic, strong) SPPlayersViewController *team2Controller;

@end

@implementation SPMainViewController

- (UILabel *)headerLabelWithText:(NSString *)text
{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    header.text = text;
    return header;
}

- (SPPlayersViewController *)team1Controller
{
    if (!_team1Controller) {
        _team1Controller = [[SPPlayersViewController alloc] initWithStyle:UITableViewStylePlain];
        
        _team1Controller.tableView.tableHeaderView = [self headerLabelWithText:@"Team 1"];
        [_team1Controller addPlayer:[SPPlayer playerWithIdentifier:@"aaa" email:@"asdasd@asdas.it"]];
    }
    return _team1Controller;
}

- (SPPlayersViewController *)team2Controller
{
    if (!_team2Controller) {
        _team2Controller = [[SPPlayersViewController alloc] initWithStyle:UITableViewStylePlain];
        _team2Controller.tableView.tableHeaderView = [self headerLabelWithText:@"Team 2"];
        [_team2Controller addPlayer:[SPPlayer playerWithIdentifier:@"valerio" email:@"valerio.it"]];
        [_team2Controller addPlayer:[SPPlayer playerWithIdentifier:@"aaa" email:@"asdasd@asdas.it"]];
    }
    return _team2Controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.team1Controller willMoveToParentViewController:self];
    [self.view addSubview:self.team1Controller.view];
    [self addChildViewController:self.team1Controller];
    [self.team1Controller didMoveToParentViewController:self];
    
    [self.team2Controller willMoveToParentViewController:self];
    [self.view addSubview:self.team2Controller.view];
    [self addChildViewController:self.team2Controller];
    [self.team2Controller didMoveToParentViewController:self];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect frame = CGRectMake(0, 0, 0, self.view.bounds.size.height);
    
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            
            frame.size.width = kTeamControllerMaxWidth;
            
            break;
            
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            
            frame.size.width = kTeamControllerMinWidth;
            
            break;
    }
    
    self.team1Controller.view.frame = frame;
    
    frame.origin.x = self.view.bounds.size.width - frame.size.width;
    self.team2Controller.view.frame = frame;
}

@end
