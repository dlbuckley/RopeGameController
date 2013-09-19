//
//  NSString+Utils.m
//  PCPlatopusClient
//
//  Created by Valerio Mazzeo on 20/09/2012.
//  Copyright (c) 2012 Valerio Mazzeo. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (NSString *)stringByEnsuringPrefix:(NSString *)prefix
{
    if (prefix) {
        if ([self hasPrefix:prefix]) {
            return self;
        } else {
            return [prefix stringByAppendingString:self];
        }
    } else {
        return self;
    }
}

- (NSString *)stringByEnsuringSuffix:(NSString *)suffix
{
    if (suffix) {
        if ([self hasSuffix:suffix]) {
            return self;
        } else {
            return [self stringByAppendingString:suffix];
        }
    } else {
        return self;
    }
}

- (NSString *)stringByEnsuringNoPrefix:(NSString *)prefix
{
    if (prefix) {
        NSString *result = [self copy];
        while ([result hasPrefix:prefix]) {
            result = [result substringFromIndex:prefix.length];
        }
        return result;
    } else {
        return self;
    }
}

- (NSString *)stringByEnsuringNoSuffix:(NSString *)suffix
{
    if (suffix) {
        NSString *result = [self copy];
        while ([result hasSuffix:suffix]) {
            result = [result substringToIndex:result.length - suffix.length];
        }
        return result;
    } else {
        return self;
    }    
}

- (NSString*)stringByAppendingQueryParameters:(NSDictionary *)parameters
{
    NSMutableString *URLWithQuerystring = [[NSMutableString alloc] initWithString:self];
    
    NSString *formatString;
    
    for (id key in parameters) {
        NSString *keyString = [key description];
        NSString *valueString = [[parameters objectForKey:key] description];
        
        if ([URLWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            formatString = @"?%@=%@";
        } else {
            formatString = @"&%@=%@";
        }
        
        [URLWithQuerystring appendFormat:formatString,
         [keyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
         [valueString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return URLWithQuerystring;
}

- (NSURL *)gravatarURL
{
    return [self gravatarURLWithSize:0 secure:FALSE];
}

- (NSURL *)gravatarURLWithSize:(int)size
{
    return [self gravatarURLWithSize:size secure:FALSE];
}

- (NSURL *)gravatarURLWithSize:(int)size
                        secure:(BOOL)secure
{
    return [self gravatarURLWithSize:size defaultImage:nil secure:secure];
}

- (NSURL *)gravatarURLWithSize:(int)size
                  defaultImage:(NSString *)defaultImage
                        secure:(BOOL)secure
{
    NSString *fixedString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    
	const char *cStr = [fixedString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // compute MD5
    
	NSString *md5String = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (size) {
        [parameters setValue:[NSNumber numberWithInteger:size] forKey:@"s"];
    }
    
    if (defaultImage) {
        [parameters setValue:defaultImage forKey:@"d"];
    } else {
        [parameters setValue:@"404" forKey:@"d"];
    }
    
    NSURL *gravatarEndPointURL;
    if (secure) {
        gravatarEndPointURL = [NSURL URLWithString:@"https://secure.gravatar.com/avatar/"];
    } else {
        gravatarEndPointURL = [NSURL URLWithString:@"http://www.gravatar.com/avatar/"];
    }

	return [NSURL URLWithString:[md5String stringByAppendingQueryParameters:parameters] relativeToURL:gravatarEndPointURL];
}

@end
