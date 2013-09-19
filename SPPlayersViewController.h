//
//  SPPlayersViewController.h
//  RopeGameController
//
//  Created by Valerio Mazzeo on 19/09/13.
//  Copyright (c) 2013 NSSpain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPPlayer.h"

@interface SPPlayersViewController : UITableViewController

@property (nonatomic, strong, readonly) NSMutableDictionary *players;
@property (nonatomic, strong, readonly) NSMutableArray *playersOrder;
@property (assign) NSUInteger *totalScore;

- (BOOL)addPlayer:(SPPlayer *)player;
- (SPPlayer*)playerForID:(NSString*)identifier;
- (BOOL)removePlayer:(SPPlayer *)player;
- (BOOL)removePlayerWithID:(NSString *)identifier;
- (BOOL)doesTeamContainPlayerWithPeerID:(MCPeerID*)peerID;

@end
