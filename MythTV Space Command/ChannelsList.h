//
//  ChannelsList.h
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/21/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelsList : NSObject

+ (void)refreshChannels;
+ (NSMutableDictionary *)getChannels;
+ (NSMutableArray *)getChannelsMap;

@end
