//
//  SPNetworkController.h
//  RopeGameController
//
//  Created by Dale Buckley on 19/09/2013.
//  Copyright (c) 2013 NSSpain. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MultipeerConnectivity;

static NSString *const kSPNetworkControllerNotificationDidAddPeer = @"kSPNetworkControllerNotificationDidAddPeer";
static NSString *const kSPNetworkControllerNotificationDidRemovePeer = @"kSPNetworkControllerNotificationDidRemovePeer";

@interface SPNetworkController : NSObject <MCNearbyServiceBrowserDelegate, MCSessionDelegate>

@property (nonatomic, strong) NSMutableArray *peers;

+ (SPNetworkController*)sharedController;

- (void)broadcastData:(NSData*)data;

@end
