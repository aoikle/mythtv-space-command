//
//  Channels.m
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/21/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import "ChannelsList.h"
#import "Channel.h"
#import "AppDelegate.h"
#import "SocketConnection.h"
#import "NSString+ComponentsLimit.h"

@implementation ChannelsList

static NSMutableDictionary *channels;
static NSMutableArray *channelsMap;

SocketConnection *conn;

+ (NSMutableDictionary *)getChannels {
    return channels;
}

+ (NSMutableArray *)getChannelsMap {
    return channelsMap;
}

+ (void)refreshChannels {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    conn = appDelegate.conn;
    
    MSCSendMessageCompleteBlock callback = ^(BOOL wasSuccessful,
                                             NSString *lastMessageSent,
                                             NSString *response) {
        if (wasSuccessful) {
            if ([conn.lastMessageSent isEqualToString:@"query channels\n"]) {
                NSMutableArray *data = [[response componentsSeparatedByString:@"\r\n"] mutableCopy];
                    
                channels = [[NSMutableDictionary alloc] initWithCapacity:[data count] - 1];
                channelsMap = [[NSMutableArray alloc] initWithCapacity:[data count] - 1];
                
                for (int i = 0; i < [data count]; i++)
                {
                    NSArray *item = [[[data objectAtIndex: i] componentsSeparatedByString: @" " limit:3]mutableCopy];
                        
                    if ([item count] != 4) {
                        continue;
                    }
                        
                    Channel *channel = [[Channel alloc] init];
                    channel.mythId = [NSString stringWithString: item[1]].intValue;
                    channel.callsign = [item[2] stringByReplacingOccurrencesOfString:@"\""
                                                                        withString:@""];
                    channel.name = [item[3] stringByReplacingOccurrencesOfString:@"\""
                                                                        withString:@""];
                    channel.program = @"";
                    
                    [channels setObject:channel forKey:item[1]];
                    [channelsMap addObject:item[1]];
                    
                }
                
            }

        }
    };
    
    
    [conn sendMessage:@"query channels\n" withCallback:callback];
    
    
}

@end
