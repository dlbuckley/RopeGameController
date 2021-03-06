//
//  SPPlayer.m
//  RopeGameController
//
//  Created by Valerio Mazzeo on 19/09/13.
//  Copyright (c) 2013 NSSpain. All rights reserved.
//

#import "SPPlayer.h"

@interface SPPlayer ()

@property (nonatomic, strong, readwrite) NSString *identifier;

@end

@implementation SPPlayer

+ (SPPlayer*)playerWithPeerID:(MCPeerID*)peerID
{
    SPPlayer *player = [SPPlayer playerWithIdentifier:[NSString stringWithFormat:@"%d", [peerID.displayName hash]]];
    player.peerID = peerID;
    player.email = peerID.displayName;
    
    return player;
}

+ (SPPlayer *)playerWithIdentifier:(NSString *)identifier
{
    return [[SPPlayer alloc] initWithIdentifier:identifier];
}

+ (SPPlayer *)playerWithIdentifier:(NSString *)identifier email:(NSString *)email
{
    SPPlayer *player = [[SPPlayer alloc] initWithIdentifier:identifier];
    player.email = email;
    return player;
}

- (id)initWithIdentifier:(NSString *)identifier
{
    if (self = [super init]) {
        self.identifier = identifier;
    }
    return self;
}

- (void)setEmail:(NSString *)email
{
    _email = email;
    
    NSRange atRange = [_email rangeOfString:@"@"];
    if (atRange.location != NSNotFound) {
        NSArray *components = [[_email substringToIndex:atRange.location] componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
    
        self.name = [[components componentsJoinedByString:@" "] capitalizedString];
    }
}

@end
