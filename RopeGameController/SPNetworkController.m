//
//  SPNetworkController.m
//  RopeGameController
//
//  Created by Dale Buckley on 19/09/2013.
//  Copyright (c) 2013 NSSpain. All rights reserved.
//

#import "SPNetworkController.h"

static NSString *const kServiceType = @"ropegame";

@interface SPNetworkController ()

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

@end

@implementation SPNetworkController

# pragma mark - Properties

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

- (MCNearbyServiceBrowser *)browser
{
    if (!_browser) {
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID
                                                    serviceType:kServiceType];
        _browser.delegate = self;
    }
    return _browser;
}

+ (SPNetworkController*)sharedController
{
    static SPNetworkController *networkController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkController = [SPNetworkController new];
    });
    return networkController;
}

- (id)init
{
    if (self = [super init]) {
        [self.browser startBrowsingForPeers];
    }
    return self;
}

#pragma mark - Public Methods

- (void)broadcastData:(NSData*)data
{
    NSError *error;
    
    [self.session sendData:data
                   toPeers:self.peers
                  withMode:MCSessionSendDataUnreliable // Faster, reliable is slower :(
                     error:&error];
    
    if (error) {
        NSLog(@"Failed to broadcast data with error: %@", error.localizedDescription);
    }
}

#pragma mark - MCNearbyServiceBrowserDelegate Methods

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [self.session connectPeer:peerID withNearbyConnectionData:nil];
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
}

// Browsing did not start due to an error
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    
}

#pragma mark - Methods

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateNotConnected: {
            if ([self.peers containsObject:peerID]) {
                [self.peers removeObject:peerID];
                [[NSNotificationCenter defaultCenter] postNotificationName:kSPNetworkControllerNotificationDidRemovePeer
                                                                    object:nil];
            }
            break;
        }
        case MCSessionStateConnecting: {
            
            break;
        }
        case MCSessionStateConnected: {
            if (![self.peers containsObject:peerID]) {
                [self.peers addObject:peerID];
                [[NSNotificationCenter defaultCenter] postNotificationName:kSPNetworkControllerNotificationDidAddPeer
                                                                    object:nil];
                [self.session sendData:[@"You are connected! It's time to dance! .... Dance bitch, DANCE!" dataUsingEncoding:NSUTF8StringEncoding]
                               toPeers:@[peerID]
                              withMode:MCSessionSendDataUnreliable
                                 error:nil];
            }
            break;
        }
        default:
            break;
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"%@", [NSString stringWithUTF8String:[data bytes]]);
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress;
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}



@end
