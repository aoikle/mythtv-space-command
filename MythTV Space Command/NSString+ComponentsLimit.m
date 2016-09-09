//
//  NSString+ComponentsLimit.m
//
//  Created by Shilo White on 8/31/13.
//  Copyright (c) 2013 Shilocity Productions. All rights reserved.
//

#import "NSString+ComponentsLimit.h"

@implementation NSString (ComponentsLimit)

- (NSArray *)componentsSeparatedByString:(NSString *)separator limit:(NSUInteger)limit
{
    if (limit == 0)
  	return [self componentsSeparatedByString:separator];
    
	NSArray *allComponents = [self componentsSeparatedByString:separator];
	NSMutableArray *components = [NSMutableArray arrayWithCapacity:MIN(limit, allComponents.count)];
    
	int i = 0;
	for (NSString *component in allComponents)
    {
		if (i >= limit)
        {
            NSRange range = NSMakeRange(i, allComponents.count - i);
			[components addObject:[[allComponents subarrayWithRange:range] componentsJoinedByString:separator]];
			break;
		}
		[components addObject:component];
		i++;
	}
    
	return components;
}
@end
