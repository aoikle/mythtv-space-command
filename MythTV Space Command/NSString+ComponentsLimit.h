//
//  NSString+ComponentsLimit.h
//
//  Created by Shilo White on 8/31/13.
//  Copyright (c) 2013 Shilocity Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ComponentsLimit)

- (NSArray *)componentsSeparatedByString:(NSString *)separator limit:(NSUInteger)limit;

@end
