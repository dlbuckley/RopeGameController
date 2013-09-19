//
//  SPPlayer.h
//  RopeGameController
//
//  Created by Valerio Mazzeo on 19/09/13.
//  Copyright (c) 2013 NSSpain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPPlayer : NSObject

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;

+ (SPPlayer *)playerWithIdentifier:(NSString *)identifier;
+ (SPPlayer *)playerWithIdentifier:(NSString *)identifier email:(NSString *)email;

- (id)initWithIdentifier:(NSString *)identifier;

@end
