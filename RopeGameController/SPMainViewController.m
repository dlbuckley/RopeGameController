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
    }
    return _team1Controller;
}

- (SPPlayersViewController *)team2Controller
{
    if (!_team2Controller) {
        _team2Controller = [[SPPlayersViewController alloc] initWithStyle:UITableViewStylePlain];
        _team2Controller.tableView.tableHeaderView = [self headerLabelWithText:@"Team 2"];
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

# pragma mark - MCSessionDelegate Methods

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateNotConnected: {
            NSLog(@"Not Connected: %@", peerID);
            break;
        }
        case MCSessionStateConnecting: {
            NSLog(@"Connecting: %@", peerID);
            break;
        }
        case MCSessionStateConnected: {
            NSLog(@"Connected: %@", peerID);
            
            SPPlayer *player = [SPPlayer playerWithPeerID:peerID];
            
            if (self.team2Controller.players.count >= self.team1Controller.players.count) {
                [self.team1Controller addPlayer:player];
            } else {
                [self.team2Controller addPlayer:player];
            }
            
            NSDictionary *dict = @{@"opetationID":@(SPOperationPlayerConnected),
                                   @"value":@""};
            
            [self.session sendData:[NSKeyedArchiver archivedDataWithRootObject:dict]
                           toPeers:@[peerID]
                          withMode:MCSessionSendDataUnreliable
                             error:nil];
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
    
    if ([dict objectForKey:@"operationID"]) {
        
        enum SPOperationType opType = [(NSNumber*)[dict objectForKey:@"operationID"] intValue];
        
        switch (opType) {
            case SPOperationUserProgress:
                
                //NSUInteger value = [(NSNumber*)[dict objectForKey:@"value"] intValue];
                
                
                
                [self.session sendData:nil
                               toPeers:self.session.connectedPeers
                              withMode:MCSessionSendDataUnreliable
                                 error:nil];
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
