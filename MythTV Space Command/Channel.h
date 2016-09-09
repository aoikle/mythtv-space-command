//
//  Channel.h
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/14/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property int mythId;
@property NSString *name;
@property NSString *callsign;
@property NSString *program;

@end
