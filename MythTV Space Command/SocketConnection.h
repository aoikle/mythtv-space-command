//
//  SocketConnection.h
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/8/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MSCSendMessageCompleteBlock) (BOOL wasSuccessful,
                                             NSString *lastMessageSent,
                                             NSString *response);

@interface SocketConnection : NSObject

- (void)connectToRemoteControlInterface;
- (void)disconnectFromRemoteControlInterface;
- (void)sendMessage:(NSString *)string;
- (void)sendMessage:(NSString *)string
      withCallback:(MSCSendMessageCompleteBlock)callback;

@property NSMutableString *lastMessageSent;

@property NSString *frontendIP;
@property NSString *frontendPort;

@end
