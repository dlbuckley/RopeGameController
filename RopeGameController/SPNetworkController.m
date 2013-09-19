//
//  SPNetworkController.m
//  RopeGameController
//
//  Created by Dale Buckley on 19/09/2013.
//  Copyright (c) 2013 NSSpain. All rights reserved.
//

#import "SPNetworkController.h"
@import MultipeerConnectivity;

@interface SPNetworkController ()

@property (nonatomic, strong) MCSession *session;

@end

@implementation SPNetworkController

- (MCSession *)session
{
    if (!_session) {
        //_session =
    }
    return _session;
}



@end
