//
//  SocketConnection.m
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/8/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import "SocketConnection.h"
#import "ChannelsList.h"

@implementation SocketConnection

NSInputStream *inputStream;
NSOutputStream *outputStream;

MSCSendMessageCompleteBlock currentCallback = nil;

bool grabChannels;

- (SocketConnection *)init {
    return self;
}

- (void)connectToRemoteControlInterface {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.frontendIP,
                                       [self.frontendPort integerValue], &readStream, &writeStream);
    
    inputStream = (__bridge_transfer NSInputStream *)readStream;
    outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (void)disconnectFromRemoteControlInterface {
    [inputStream close];
    [outputStream close];
}

- (void)sendMessage:(NSString *)string {
    self.lastMessageSent = [string mutableCopy];
    NSData *data = [[NSData alloc] initWithData:[string dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

- (void)sendMessage:(NSString *)string
       withCallback:(MSCSendMessageCompleteBlock)callback {
    currentCallback = callback;
    self.lastMessageSent = [string mutableCopy];
    NSData *data = [[NSData alloc] initWithData:[string dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    //NSLog(@"stream event %u", streamEvent);
    
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            grabChannels = YES;
            NSLog(@"Stream opened");
            break;
        case NSStreamEventHasSpaceAvailable: {
            if (grabChannels == YES) {
                grabChannels = NO;
                [ChannelsList refreshChannels];
            }
            break;
        }
        case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                uint8_t buffer[1024];
                long len;
                NSMutableString *finalOutput = [[NSMutableString alloc] init];
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            [finalOutput appendString:[output mutableCopy]];
                        }
                    }
                }
                [self preprocessResponse:finalOutput];
                if (currentCallback != nil) {
                    currentCallback(YES, self.lastMessageSent, finalOutput);
                    currentCallback = nil;
                }
            }
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
        case NSStreamEventEndEncountered:
            break;
        default:
            NSLog(@"Unknown event");
    }
}

- (void)preprocessResponse:(NSString *)response {
    
}

@end
