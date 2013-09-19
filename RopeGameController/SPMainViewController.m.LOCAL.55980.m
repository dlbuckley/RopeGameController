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

static NSString *const kServiceType = @"ropegame";

@interface SPMainViewController ()

@property (nonatomic, strong) SPPlayersViewController *team1Controller;
@property (nonatomic, strong) SPPlayersViewController *team2Controller;

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;

@property (assign) BOOL gameStarted;

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
        _team1Controller.tableView.tableFooterView = [UIView new];
    }
    return _team1Controller;
}

- (SPPlayersViewController *)team2Controller
{
    if (!_team2Controller) {
        _team2Controller = [[SPPlayersViewController alloc] initWithStyle:UITableViewStylePlain];
        _team2Controller.tableView.tableHeaderView = [self headerLabelWithText:@"Team 2"];
        _team2Controller.tableView.tableFooterView = [UIView new];
    }
    return _team2Controller;
}

- (MCPeerID *)peerID
{
    if (!_peerID) {
        _peerID = [[MCPeerID alloc] initWithDisplayName:@"Game Controller"];
    }
    return _peerID;
}

- (MCSession *)session
{
    if (!_session) {
        _session = [[MCSession alloc] initWithPeer:self.peerID];
        _session.delegate = self;
    }
    return _session;
}

- (MCAdvertiserAssistant *)advertiserAssistant
{
    if (!_advertiserAssistant) {
        _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:kServiceType discoveryInfo:nil session:self.session];
    }
    return _advertiserAssistant;
}

- (id)init
{
    if (self = [super init]) {
        [self.advertiserAssistant start];
        self.gameStarted = FALSE;
    }
    return self;
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

- (NSData*)dataForOperation:(SPOperationType)opType value:(id)value
{
    NSDictionary *dict = @{@"operationid":@(opType),
                           @"value":value};
    
    return [NSKeyedArchiver archivedDataWithRootObject:dict];
}

- (void)startGame
{
    if (!self.gameStarted) {
        self.gameStarted = TRUE;
        // Tell the players the game has started
        [self.session sendData:[self dataForOperation:SPOperationStartGame value:@(0)]
                       toPeers:self.session.connectedPeers
                      withMode:MCSessionSendDataUnreliable
                         error:nil];
    }
}

# pragma mark - MCSessionDelegate Methods

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateNotConnected: {
            NSLog(@"Not Connected: %@", peerID);
            [self.team1Controller removePlayerWithID:[NSString stringWithFormat:@"%d",[peerID.displayName hash]]];
            [self.team2Controller removePlayerWithID:[NSString stringWithFormat:@"%d",[peerID.displayName hash]]];
            break;
        }
        case MCSessionStateConnecting: {
            NSLog(@"Connecting: %@", peerID);
            break;
        }
        case MCSessionStateConnected: {
            NSLog(@"Connected: %@", peerID);
            
            SPPlayer *player = [SPPlayer playerWithPeerID:peerID];
            
            int teamNumber = 0;

            if (self.team2Controller.players.count >= self.team1Controller.players.count) {
                [self.team1Controller addPlayer:player];
                teamNumber = 1;
            } else {
                [self.team2Controller addPlayer:player];
                teamNumber = 2;
            }
            
            // Tell the player they are connected to a team
            NSError *error;
            [self.session sendData:[self dataForOperation:SPOperationPlayerConnected value:@(teamNumber)]
                           toPeers:@[peerID]
                          withMode:MCSessionSendDataUnreliable
                             error:&error];
            if (!error)
                NSLog(@"Player %@ connected to team %d", peerID.displayName, teamNumber);
            else
                NSLog(@"Error adding %@ to a team", peerID);
            
            double delayInSeconds = 8.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self startGame];
            });
            
            break;
        }
        default:
            break;
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if ([dict objectForKey:@"operationid"]) {
        
        SPOperationType opType = [(NSNumber*)[dict objectForKey:@"operationid"] intValue];
        
        switch (opType) {
            case SPOperationUserProgress:
                
                //int value = (int)[dict objectForKey:@"value"]
                
                if ([self.team1Controller doesTeamContainPlayerWithPeerID:peerID]) {
                    self.team1Controller.totalScore += [(NSNumber*)[dict objectForKey:@"value"] intValue];
                }else if ([self.team2Controller doesTeamContainPlayerWithPeerID:peerID]) {
                    self.team2Controller.totalScore += [(NSNumber*)[dict objectForKey:@"value"] intValue];
                }
                
                int difference = self.team1Controller.totalScore - self.team2Controller.totalScore;
                
                // Switch to positive value
                if (difference < 0)
                    difference = -difference;
                
                if (difference > 1000) {
                    
                    self.gameStarted = FALSE;
                    
                    // A team has won!
                    [self.session sendData:[self dataForOperation:SPOperationEndGame value:self.team1Controller.totalScore > self.team2Controller.totalScore ? @(1) : @(2)]
                                   toPeers:self.session.connectedPeers
                                  withMode:MCSessionSendDataUnreliable
                                     error:nil];
                } else {
                    // Update the players progress
                    [self.session sendData:[self dataForOperation:SPOperationGameProgress value:nil]
                                   toPeers:self.session.connectedPeers
                                  withMode:MCSessionSendDataUnreliable
                                     error:nil];
                }
                
                
                break;
                
            default:
                break;
        }
    }
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}


@end
