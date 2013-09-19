//
//  NSString+Utils.h
//  PCPlatopusClient
//
//  Created by Valerio Mazzeo on 20/09/2012.
//  Copyright (c) 2012 Valerio Mazzeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

- (NSString *)firstLetter;

- (NSString *)stringByEnsuringPrefix:(NSString *)prefix;
- (NSString *)stringByEnsuringSuffix:(NSString *)suffix;

- (NSString *)stringByEnsuringNoPrefix:(NSString *)prefix;
- (NSString *)stringByEnsuringNoSuffix:(NSString *)suffix;

- (NSString*)stringByAppendingQueryParameters:(NSDictionary *)parameters;

- (NSURL *)gravatarURL;
- (NSURL *)gravatarURLWithSize:(int)size;
- (NSURL *)gravatarURLWithSize:(int)size secure:(BOOL)secure;
- (NSURL *)gravatarURLWithSize:(int)size defaultImage:(NSString *)defaultImage secure:(BOOL)secure;

@end
